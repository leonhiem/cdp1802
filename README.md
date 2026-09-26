# cdp1802

A reverse-engineered VHDL model of the RCA CDP1802 COSMAC microprocessor.

## Overview

This is a gate/register-level re-implementation of the CDP1802, built
directly from the datasheet and user manual rather than a black-box
reinterpretation of its instruction set. The internal architecture mirrors
the real chip: a register file (R0-RF), an ALU, N/I opcode decode, an
address mux (AMUX) and data mux (DMUX) forming the internal data paths, and
a state machine driving the S0 (fetch) / S1 (execute) / S2 (DMA) / S3
(interrupt) machine cycle with its TPA/TPB timing pulses. Timing is close
to the real CDP1802, with a few small documented exceptions.

All pins are implemented per the datasheet, except the XTAL pin.

- Datasheet: https://wiki.techinc.nl/images/5/5f/Cdp1802.pdf
- User manual: http://bitsavers.trailing-edge.com/components/rca/cosmac/MPM-201A_User_Manual_for_the_CDP1802_COSMAC_Microprocessor_1976.pdf
- See also: http://www.cosmacelf.com/

## Repository layout

```
src/vhdl/     the CPU and example systems around it
tb/vhdl/      testbenches
sim/ghdl/     GHDL simulation flow + committed golden reference trace
sim/xsim/     Vivado xsim cross-check against that same golden trace
doc/          original design sketches and simulation screenshots
```

### `src/vhdl/`

| File | Role |
|---|---|
| `cdp1802.vhd` | Top-level CDP1802 entity: every datasheet pin. |
| `control.vhd` | Main state machine: fetch/execute/DMA/interrupt sequencing, TPA/TPB. |
| `instr.vhd` | Instruction decoder/micro-sequencer for the full opcode map. |
| `instr_pkg.vhd` | Opcode encodings for every CDP1802 mnemonic (incl. aliases like `BDF`/`BGE`/`BPZ`). |
| `alu.vhd`, `amux.vhd`, `dmux.vhd` | Datapath: ALU, address mux, data mux (see `doc/dmux_alu_D_.jpg` for the original design sketch). |
| `reg.vhd`, `reg_R.vhd`, `ff.vhd`, `dff.vhd` | Register file and flip-flop primitives. |
| `cdp1802_pkg.vhd` | Shared state-machine and ALU-operation encodings. |
| `cdp18.vhd` | Example system: CDP1802 + RAM + simple I/O, driven directly by the datasheet pins (`nWAIT`, `nCLEAR`, `nINT`, `nDMA_IN`/`OUT`). |
| `cs1800.vhd`, `cs1800_cpu.vhd` | A second top-level wrapper around the same core, driven by simpler system control lines (`reset`/`halt`/`single`/`run`) instead of the raw datasheet handshake; this variant has already been run through Intel Quartus once. |
| `ram.vhd` | RAM containing a small embedded test program that exercises most instructions. |
| `io_inp.vhd`, `io_out.vhd` | Minimal input/output port models. |

### `tb/vhdl/`

- `tb_cdp1802.vhd`, `tb_reg_R.vhd` — unit-level testbenches.
- `tb_cdp18.vhd`, `tb_cs1800.vhd` — system-level testbenches: drive reset,
  run, pause, interrupt and DMA sequences against `cdp18` / `cs1800`.
- `tb_cdp18_dump.vhd`, `tb_cs1800_dump.vhd` — the same stimulus, plus a
  monitor that records `{ram_addr, data, nMRD, nMWR, Q, SC}` on every TPB
  pulse to a text file, without modifying any existing design or
  testbench file (VHDL-2008 external names reach into the DUT). Used by
  `sim/ghdl/` and `sim/xsim/` below.

## Implementation status

- The full CDP1802 instruction set is implemented (`instr_pkg.vhd` defines
  261 opcode constants, covering every mnemonic and its aliases); 74 of
  them are marked `-- tested` against the `ram.vhd` test program.
- The S0/S1/S2/S3 fetch/execute/DMA/interrupt cycle and TPA/TPB timing are
  implemented per the datasheet.
- No outstanding `TODO`/`FIXME` markers in the source.

### Fixes brought back from the FPGA port (2026-09-26)

Porting this core to real hardware -- an FPGA running the original CS1800
rack's own PRCX-18 EPROM -- turned up thirteen defects that the test
program here never exercised. They are fixed in `src/vhdl/` now. Each one
is written up, with the datasheet citation, the failure it caused and the
test that catches it, in **[cdp1802-fpga's core
review](https://github.com/leonhiem/cdp1802-fpga/blob/main/doc/CDP1802_CORE_REVIEW.md)**
-- not repeated here.

In brief: `INP` not loading D; `SHRC`/`SHLC` ignoring DF; no S3 cycle when
IE=0, losing interrupts; bus/address deviations from datasheet Table 2 in
cycles with no memory access; a spurious read at every interrupt; a DMA
during a long branch dropping its second execute cycle; `INP`'s write
strobe running past the end of its cycle; an interrupt taken too early
after a multi-cycle instruction; a DMA ending an `IDL` instead of
resuming it; DMA direction re-sampled from the live request lines; an
8-clock initialization cycle where the datasheet gives it 9; TPA
suppressed during `IDL` rather than only in LOAD mode; and five
instructions sampling the data bus a whole clock before a real
multiplexed-address memory card can have presented the address.

The verification those fixes rest on -- an independent instruction-set
model in lockstep, exhaustive ALU checks, 1000 random instruction
streams, DMA/interrupt edge cases, pin-level timing against the datasheet
waveforms, and the real PRCX-18 OS booting for 295,626 instructions with
zero mismatches -- lives in that repository too.

`sim/ghdl/reference/` was regenerated to match. Every timestamp after the
first moves 250 ns later (the initialization cycle is now the datasheet's
9 clocks, not 8), and the address bus changes in execute cycles that make
no memory access (Table 2). Cross-checked against `cdp1802-fpga`'s own
reference traces: the two are identical except where this core's
bidirectional `DATA` bus reads `ZZ` and the FPGA port's split bus reads a
driven value -- 0 differences in address, strobes, Q or SC.

## Simulating

### ModelSim (original workflow)

```
modelsim_config unb2c -v1
run_modelsim unb2c
```
In ModelSim:
```
lp cdp1802
mk clean
mk all
```
Double click testbench `tb_cdp18.vhd` or `tb_cs1800.vhd`, then:
```
as 10
run 1200us
```
Exit with `quit -sim`.

### GHDL

```
sim/ghdl/run.sh            # both designs
sim/ghdl/run.sh cdp18      # just tb_cdp18_dump
sim/ghdl/run.sh cs1800     # just tb_cs1800_dump
```
Analyzes/elaborates/runs `tb_cdp18_dump` and `tb_cs1800_dump` with GHDL
(`--std=08`) and writes their TPB traces into `sim/ghdl/reference/`, which
is committed as the golden reference for the current design. See
`sim/ghdl/README.md` for the trace format.

### Vivado xsim

```
source <Vivado install>/<version>/settings64.sh   # puts xvhdl/xelab/xsim on PATH
sim/xsim/run.sh
```
Runs the same testbenches on Vivado's simulator and diffs the result
against `sim/ghdl/reference/` — confirmed bit-for-bit identical on both
designs (Vivado 2024.1). See `sim/xsim/README.md`.

### Waveforms — watching the test program run (Vivado xsim GUI)

To watch the golden test program in `src/vhdl/ram.vhd` execute
instruction by instruction, use `wave.sh` rather than `run.sh`: the latter
elaborates with `--debug off`, which is right for a text-trace check but
leaves the waveform viewer nothing to show.

```
source <Vivado install>/<version>/settings64.sh

sim/xsim/wave.sh                 # tb_cdp18_dump  (CPU + RAM + I/O)
sim/xsim/wave.sh cs1800          # tb_cs1800_dump (the larger system)
```

Each run elaborates with `--debug typical`, logs every signal in the
hierarchy (`log_wave -r /`, so the CPU's internals are captured and not
just the testbench top), runs to completion, and leaves a waveform
database. Open it with:

```
xsim --gui sim/xsim/run/cdp18_wave.wdb      # or cs1800_wave.wdb
```

Or skip the batch run and drive the simulation yourself from time 0:

```
sim/xsim/wave.sh cdp18 --gui
```

Everything is in the scope tree on the left; drag what you want into the
wave window. Useful signals for following the test program:

| where | signals |
|---|---|
| on the DUT | `CLOCK`, `TPA`, `TPB`, `ADDR`, `DATA`, `nMRD`, `nMWR`, `SC`, `Q` |
| inside the CPU | `A_out` (address register), `D_out`, the `R` registers |

The waveform runs are real runs, not just elaborations: each writes a
`tb_*_tpb.txt` identical to `sim/ghdl/reference/`, the same check
`run.sh` makes. Verified with Vivado Simulator v2024.1 — except the GUI
step itself, which was never launched here.

## License

MIT

## Status

This repository holds the CDP1802 core itself, in its original form: a
bidirectional `DATA` bus as the datasheet has it, and the golden test
program inline in `ram.vhd`. It is no longer a frozen pre-port snapshot --
it now carries the fixes the FPGA port found (above).

Active development, the CS1800 system around the core, and all the
verification continue in
[cdp1802-fpga](https://github.com/leonhiem/cdp1802-fpga). That repository
splits `DATA` into `DATA_IN`/`DATA_OUT`/`DATA_OE` because FPGA fabric has
no internal tri-states, and adds debug ports; neither belongs here.
