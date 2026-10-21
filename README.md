# Mini 8-bit Accumulator CPU

**CSE 450 (VLSI Lab) — Final Project, Spring 2026**
University of Asia Pacific, Department of Computer Science and Engineering

| | |
|---|---|
| **Student ID** | 22201139 |
| **Instruction Set** | Set 9 |
| **Instructions** | `LDI`, `ADD` (mandatory) + `NOT`, `SHL`, `JZ` (assigned) |
| **Language / Tool** | VHDL, Xilinx ISE 14.7 (ISim) |

## 1. Overview

A single-cycle 8-bit accumulator CPU written in VHDL. Fetch, decode and execute
happen in one clock cycle, and the result is written at the rising edge of `CLK`.
All state (PC, ACC, Z) is cleared by a synchronous, active-high `RESET`.

## 2. Architecture

| Block | File | Description |
|---|---|---|
| Full adder | `full_adder.vhd` | 1-bit full adder built from XOR/AND/OR gates. |
| Ripple-carry adder | `ripple_adder.vhd` | N-bit adder made of full adders (N = 8 in the ALU, N = 4 in the PC). |
| D flip-flop | `dff_sr.vhd` | Rising-edge D flip-flop with synchronous active-high reset and enable. |
| Program Counter | `pc.vhd` | 4 D flip-flops + ripple-adder incrementer + gate-level 2:1 mux. `PC + 1` after every instruction, or the jump target when `JZ` is taken. |
| Program ROM | `prog_rom.vhd` | 16 x 12-bit constant array, read combinationally with `PC`. Unused locations are `0x000` (NOP). |
| Control Unit | `control_unit.vhd` | Gate-level (AND/OR/NOT) decoder of `opcode[11:8]`; generates one-hot ALU selects, ACC write enable and PC load. |
| ALU | `alu.vhd` | Ripple-carry adder (ADD), inverters (NOT), shift wiring (SHL) and an AND-OR output selector (LDI). |
| ACC and Z flag | `acc_z.vhd` | 8 D flip-flops (accumulator, also output `Q`) and 1 D flip-flop for the zero flag (NOR of the written value). |
| Top level | `cpu_top.vhd` | Connects all blocks. Ports: `CLK`, `RESET`, `Q[7:0]`, `Z`, `PC[3:0]`. |
| Testbench | `cpu_tb.vhd` | Clock, one-edge reset, runs the Set 9 program and checks every cycle. |

## 3. Instruction format and instruction set

12-bit instruction: `instr[11:8]` = opcode, `instr[7:0]` = 8-bit operand.

| Mnemonic | Opcode | Operation | Z flag |
|---|---|---|---|
| `LDI imm` | 0001 | ACC <- imm | updated |
| `ADD imm` | 0010 | ACC <- ACC + imm (carry discarded) | updated |
| `NOT` | 0111 | ACC <- NOT ACC | updated |
| `SHL` | 1000 | ACC <- ACC << 1, 0 enters LSB | updated |
| `JZ addr` | 1100 | if Z = 1 then PC <- addr[3:0], else PC <- PC + 1 | unchanged |

Any other opcode (including `0000`) behaves as NOP: `PC <- PC + 1`, nothing else changes.

## 4. Reset behaviour

`RESET = 1` at a rising edge: `PC <- 0`, `ACC <- 0x00`, `Z <- 1` (priority over everything).

## 5. Test program (Appendix B, Set 9)

| Addr | Instruction | ROM word |
|---|---|---|
| 0 | `LDI 0xFF` | `0x1FF` |
| 1 | `NOT` | `0x700` |
| 2 | `JZ 0x05` | `0xC05` |
| 3 | `ADD 0x77` | `0x277` |
| 4 | `ADD 0x77` | `0x277` |
| 5 | `ADD 0x11` | `0x211` |
| 6 | `SHL` | `0x800` |
| 7 | `JZ 0x00` | `0xC00` |
| 8 | `SHL` | `0x800` |

Expected results after each rising edge:

| Cycle | PC | Instruction | ACC | Z | Next PC |
|---|---|---|---|---|---|
| 0 | - | RESET = 1 | 0x00 | 1 | 0 |
| 1 | 0 | LDI 0xFF | 0xFF | 0 | 1 |
| 2 | 1 | NOT | 0x00 | 1 | 2 |
| 3 | 2 | JZ 0x05 (taken) | 0x00 | 1 | 5 |
| 4 | 5 | ADD 0x11 | 0x11 | 0 | 6 |
| 5 | 6 | SHL | 0x22 | 0 | 7 |
| 6 | 7 | JZ 0x00 (not taken) | 0x22 | 0 | 8 |
| 7 | 8 | SHL | 0x44 | 0 | 9 |

## 6. How to simulate (Xilinx ISE 14.7)

1. Create a project with Simulator = ISim, Preferred Language = VHDL.
2. Add all design files (`full_adder`, `ripple_adder`, `dff_sr`, `pc`, `prog_rom`, `control_unit`, `alu`, `acc_z`, `cpu_top`).
3. Add `cpu_tb.vhd` as a simulation-only source.
4. Switch to the Simulation view, select `cpu_tb`, run
   **ISim Simulator -> Simulate Behavioral Model**.
5. In ISim run for 80 ns. Check `Q`, `Z`, `PC` against the table above.
   The console should end with `Simulation finished` and no `MISMATCH` message.

## 7. Repository layout

```
.
|-- full_adder.vhd
|-- ripple_adder.vhd
|-- dff_sr.vhd
|-- pc.vhd
|-- prog_rom.vhd
|-- control_unit.vhd
|-- alu.vhd
|-- acc_z.vhd
|-- cpu_top.vhd
|-- cpu_tb.vhd
|-- screenshots/      waveform and console output
`-- README.md
```
