# BCA181FinalProject_Calculator_with_Number_System_Converter
Final Project Vivado File for BCA181 HDL Programming: Verilog RTL design for a dual-mode signed arithmetic ALU and simultaneous multi-base converter

# FPGA-Based Dual-Mode Arithmetic ALU and Number System Converter

## System Architecture
This project features a dual-mode Arithmetic Logic Unit (ALU) and simultaneous multi-base number system converter written in Verilog for the Zynq-7000 (xc7z020) FPGA. It addresses the hardware fault issue commonly encountered when passing signed negative binary numbers into modular BCD/Octal converters. An integrated Absolute Value pre-processor (`abs_A`) acts as a bridge, safely handling Two's Complement negative numbers so the system can calculate arithmetic and instantly output the results to Decimal, Octal, Hexadecimal, and Binary displays concurrently without logic faults.

## Features
* **Signed Arithmetic:** Natively processes Two's Complement arithmetic (Addition, Subtraction, Multiplication, Division).
* **Simultaneous Multi-Base Output:** Dynamically converts and displays results in BCD (Decimal), Octal, Hexadecimal, and native Binary at the exact same time.
* **Hardware Fault Prevention:** Built-in `abs_A` pre-processor prevents modulo/division errors when converting negative binary strings to modular bases.
* **Interactive Verification:** Optimized for real-time, stimulus-free interactive testing via the Vivado GUI.

## Control Logic
The `mode_select` switch toggles the datapath between Arithmetic and Converter operations. In Arithmetic mode, the `opcode` routes the datapath through the respective logic block.

| `mode_select` | `opcode` (Binary) | Active System | Operation Performed | Active Output Wire(s) |
| :---: | :---: | :--- | :--- | :--- |
| **0** | `0000` | Arithmetic | Addition (A + B) | `math_result` |
| **0** | `0001` | Arithmetic | Subtraction (A - B) | `math_result` |
| **0** | `0010` | Arithmetic | Multiplication (A * B) | `math_result` |
| **0** | `0011` | Arithmetic | Division (A / B) | `math_result` |
| **0** | `0100` to `1111` | Arithmetic | *Default / Off* | Outputs `0` |
| **1** | `XXXX` *(Don't Care)* | Converter | Simultaneous Multi-Base Conversion | `out_decimal`, `out_octal`, `out_hex`, `out_binary` |

## Simulation & Verification
*(Drag and drop your Vivado waveform screenshot image here to upload it to the README)*

## How to Run
This project utilizes a "blank-slate" stimulus-free testbench (`tb_calculator.v`). To verify the logic:
1. Open the project in Xilinx Vivado.
2. Run Behavioral Simulation.
3. Apply the provided `tb_calculator_behav.wcfg` to format the waveforms (Signed Decimal, Hex, and Binary).
4. Use the Vivado **Force Constant** GUI on `mode_select`, `opcode`, `operand_A`, and `operand_B` to inject real-time stimuli and observe the datapath routing dynamically.
