# Vivado (xsim) cross-check

Runs the same `tb_cdp18_dump` / `tb_cs1800_dump` testbenches (see
`sim/ghdl/`) on Vivado's simulator instead of GHDL, and diffs the
resulting trace against the golden reference committed under
`sim/ghdl/reference/`. This is a cross-simulator check, not a second
source of truth — the golden reference stays the one GHDL produced.

## Running

```
source <Vivado install>/<version>/settings64.sh   # puts xvhdl/xelab/xsim on PATH
sim/xsim/run.sh             # both designs
sim/xsim/run.sh cdp18       # just tb_cdp18_dump
sim/xsim/run.sh cs1800      # just tb_cs1800_dump
```

Tested with Vivado Simulator v2024.1. Each target: `xvhdl --2008` compiles
the sources (order taken from `hdllib.cfg`) into the default `work`
library, `xelab` elaborates the `*_dump` testbench, `xsim -runall` runs it
to completion, and the script diffs the produced `tb_*_tpb.txt` against
`sim/ghdl/reference/`, printing `PASS`/`FAIL`.

Confirmed bit-for-bit identical to the GHDL reference on both designs.

`run/` (xvhdl/xelab/xsim build products and the freshly generated trace)
is scratch and gitignored.

## Waveforms

`run.sh` elaborates with `--debug off`, because it only wants the text
trace -- which also means the waveform viewer can see nothing. Use
`wave.sh` instead to watch the golden test program in `src/vhdl/ram.vhd`
run, instruction by instruction:

```
source <Vivado install>/<version>/settings64.sh
sim/xsim/wave.sh                 # cdp18, batch, leaves a .wdb
sim/xsim/wave.sh cs1800          # the larger system testbench
sim/xsim/wave.sh cdp18 --gui     # open the GUI at time 0 and drive it yourself
```

The batch form elaborates with `--debug typical`, logs every signal
(`log_wave -r /`, so the CPU's internals are captured, not just the
testbench top) and runs to completion. Open the result with:

```
xsim --gui sim/xsim/run/cdp18_wave.wdb
```

Everything is in the scope tree on the left; drag what you want into the
wave window. For following the test program: `CLOCK`, `TPA`, `TPB`,
`ADDR`, `DATA`, `nMRD`, `nMWR`, `SC` and `Q` on the DUT, and inside the
CPU the `A_out` address register, `D_out`, and the `R` registers.

The waveform runs are real runs, not just elaborations: both targets
produce a `tb_*_tpb.txt` identical to `sim/ghdl/reference/`, same as
`run.sh` does. Verified with Vivado Simulator v2024.1.
