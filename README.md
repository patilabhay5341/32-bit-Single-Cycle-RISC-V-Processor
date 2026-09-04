# 32-bit Single-Cycle RISC-V Processor

A **32-bit Single-Cycle RISC-V Processor** designed and implemented using **Verilog HDL**. This project demonstrates the basic architecture and working of a RISC-V CPU, including instruction fetch, instruction decode, execution, memory access, and write-back.

## 📌 Project Overview

This project implements a simple **32-bit RISC-V processor using a single-cycle architecture**.

In a single-cycle processor, each instruction is completed within **one clock cycle**. The processor consists of different hardware modules that work together to execute RISC-V instructions.

### Main Features

* 32-bit RISC-V processor
* Single-cycle CPU architecture
* Designed using Verilog HDL
* ALU for arithmetic and logical operations
* 32 general-purpose registers
* Program Counter (PC)
* Instruction Memory
* Data Memory
* Control Unit
* Register File
* Instruction decoding
* Branch and memory operations
* Verilog testbench for simulation and verification

## 🏗️ Processor Architecture

The basic datapath of the processor is:

```text
                ┌──────────────────┐
                │ Program Counter  │
                │       (PC)       │
                └────────┬─────────┘
                         │
                         ▼
                ┌──────────────────┐
                │ Instruction      │
                │ Memory           │
                └────────┬─────────┘
                         │
                         ▼
                ┌──────────────────┐
                │ Control Unit     │
                └────────┬─────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │   Register File     │
              └─────────┬───────────┘
                        │
                        ▼
                ┌──────────────────┐
                │       ALU        │
                └────────┬─────────┘
                         │
              ┌──────────┴──────────┐
              │                     │
              ▼                     ▼
       ┌──────────────┐      ┌──────────────┐
       │ Data Memory  │      │ Write Back   │
       └──────────────┘      └──────┬───────┘
                                    │
                                    ▼
                              Register File
```

## 🔧 Main Modules

| Module              | Description                                        |
| ------------------- | -------------------------------------------------- |
| Program Counter     | Stores the address of the current instruction      |
| Instruction Memory  | Stores and provides instructions                   |
| Control Unit        | Generates control signals based on the instruction |
| Register File       | Stores 32-bit general-purpose registers            |
| ALU                 | Performs arithmetic and logical operations         |
| Data Memory         | Stores and retrieves data                          |
| Immediate Generator | Generates immediate values from instructions       |
| Multiplexers        | Select appropriate datapath inputs                 |
| Testbench           | Verifies the functionality of the processor        |

## 📚 RISC-V Instruction Set

The processor supports the following instructions:

### R-Type

```text
ADD
SUB
AND
OR
SLT
```

### I-Type

```text
ADDI
```

### Load / Store

```text
LW
SW
```

### Branch

```text
BEQ
```

> **Note:** Update this list according to the instructions actually implemented in your Verilog design.

## 🔄 Instruction Execution

Each instruction passes through the following stages:

1. **Instruction Fetch**
   The Program Counter provides the address of the instruction.

2. **Instruction Decode**
   The instruction is decoded and the required control signals are generated.

3. **Register Read**
   Required operands are read from the register file.

4. **Execution**
   The ALU performs the required arithmetic or logical operation.

5. **Memory Access**
   Load and store instructions access the data memory.

6. **Write Back**
   The result is written back into the destination register when required.

Since this is a **single-cycle architecture**, all these operations are completed during one clock cycle.

## 🧪 Simulation and Verification

The processor can be simulated using Verilog simulation tools such as:

* ModelSim
* QuestaSim
* Vivado Simulator
* Icarus Verilog
* Verilator

The testbench provides clock, reset, instructions, and required inputs to verify the processor's operation.

## 📁 Project Structure

```text
32-bit-Single-Cycle-RISC-V/
│
├── rtl/
│   ├── cpu.v
│   ├── alu.v
│   ├── control_unit.v
│   ├── register_file.v
│   ├── instruction_memory.v
│   ├── data_memory.v
│   └── ...
│
├── tb/
│   └── riscv_tb.v
│
├── programs/
│   └── program.hex
│
├── README.md
└── .gitignore
```

> The file names and folders should be changed to match the actual project structure.

## 💻 Technologies Used

* **HDL:** Verilog
* **Architecture:** RISC-V
* **Processor:** 32-bit
* **CPU Design:** Single-Cycle
* **Simulation:** Verilog Simulator

## 🎯 Learning Objectives

This project helps demonstrate:

* RISC-V instruction formats
* CPU datapath design
* Control unit design
* ALU design
* Register file implementation
* Instruction and data memory
* Single-cycle processor architecture
* Verilog RTL design
* Digital design verification

## 🚀 Future Improvements

Possible improvements include:

* Implementing additional RISC-V instructions
* Adding pipelining
* Implementing hazard detection
* Adding forwarding
* Improving memory architecture
* Adding more comprehensive test programs
* FPGA implementation

## 👨‍💻 Author

**Abhay Patil**

This project was developed as an academic/learning project to understand the design and implementation of a 32-bit RISC-V processor using Verilog HDL.
