#!/usr/bin/env bash
#
# Run a testbench on Vivado's simulator with waveform capture, so the
# golden test program in src/vhdl/ram.vhd can be watched instruction by
# instruction in the XSIM GUI.
#
# sim/xsim/run.sh is the batch cross-check against the golden traces and
# deliberately elaborates with --debug off, which makes signals invisible
# to the waveform viewer. This script elaborates with --debug typical and
# logs every signal instead.
#
# Requires xvhdl/xelab/xsim on PATH:
#   source <Vivado install>/<version>/settings64.sh
#
# Usage:
#   sim/xsim/wave.sh [cdp18|cs1800] [--gui]
#
#   (no target)  cdp18, the CPU + RAM + I/O testbench
#   cs1800       the larger CS1800 system testbench
#   --gui        open the XSIM GUI right away and stop at time 0, so you
#                can add signals and step yourself. Without it the run is
#                batch and leaves a .wdb to open afterwards.
#
# Afterwards:
#   xsim --gui sim/xsim/run/<target>.wdb
# every signal is in the scope tree on the left; drag what you want into
# the wave window. The interesting ones for following the test program are
# under the testbench's DUT: CLOCK, TPA, TPB, ADDR, DATA, nMRD, nMWR, SC,
# Q, and inside the CPU, A_out / D_out / the R registers.

set -euo pipefail

if ! command -v xvhdl >/dev/null 2>&1; then
  echo "xvhdl not found on PATH. Source Vivado's settings64.sh first, e.g.:" >&2
  echo "  source <Vivado install>/<version>/settings64.sh" >&2
  exit 1
fi

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
SRC="$ROOT/src/vhdl"
TB="$ROOT/tb/vhdl"
WORK="$HERE/run"

TARGET=cdp18
GUI=0
for a in "$@"; do
  case "$a" in
    --gui) GUI=1 ;;
    cdp18|cs1800) TARGET="$a" ;;
    *) echo "usage: $0 [cdp18|cs1800] [--gui]" >&2; exit 2 ;;
  esac
done

case "$TARGET" in
  cdp18)  TB_NAME=tb_cdp18_dump;  TB_FILE="$TB/tb_cdp18_dump.vhd" ;;
  cs1800) TB_NAME=tb_cs1800_dump; TB_FILE="$TB/tb_cs1800_dump.vhd" ;;
esac

SRCS=(
  "$SRC/cdp1802_pkg.vhd"
  "$SRC/instr_pkg.vhd"
  "$SRC/dff.vhd"
  "$SRC/ff.vhd"
  "$SRC/reg.vhd"
  "$SRC/amux.vhd"
  "$SRC/dmux.vhd"
  "$SRC/alu.vhd"
  "$SRC/reg_R.vhd"
  "$SRC/control.vhd"
  "$SRC/instr.vhd"
  "$SRC/cdp1802.vhd"
  "$SRC/ram.vhd"
  "$SRC/io_out.vhd"
  "$SRC/io_inp.vhd"
  "$SRC/cdp18.vhd"
  "$SRC/cs1800_cpu.vhd"
  "$SRC/cs1800.vhd"
)

mkdir -p "$WORK"
cd "$WORK"

echo "=== analysing ==="
xvhdl --2008 --relax --nolog "${SRCS[@]}" "$TB_FILE"

# --debug typical is what makes signals visible to the waveform database;
# sim/xsim/run.sh uses --debug off because it only wants the text trace.
echo "=== elaborating $TB_NAME (with debug info) ==="
xelab --debug typical --relax "work.$TB_NAME" -s "${TARGET}_wave" --nolog

if [ "$GUI" = 1 ]; then
  echo "=== opening the XSIM GUI ==="
  echo "(the simulation stops at time 0: add signals, then 'run all')"
  exec xsim "${TARGET}_wave" -gui --nolog
fi

cat > "${TARGET}_wave.tcl" <<'TCL'
# Log every signal in the design, then run to completion. -r recurses into
# the whole hierarchy, so the CPU's internals are captured too, not just
# the testbench's top level.
log_wave -r /
run all
quit
TCL

echo "=== running (waveforms logged) ==="
xsim "${TARGET}_wave" -tclbatch "${TARGET}_wave.tcl" --nolog

WDB="$WORK/${TARGET}_wave.wdb"
if [ -f "$WDB" ]; then
  echo
  echo "wrote $WDB ($(du -h "$WDB" | cut -f1))"
  echo "open it with:"
  echo "  xsim --gui $WDB"
else
  echo "no .wdb was produced -- check the output above" >&2
  exit 1
fi
