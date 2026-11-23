# APB RAM — SystemVerilog RTL Design & Verification

> **Project status: In progress.** The RTL and modular SystemVerilog testbench are being developed and debugged. Scoreboard refinement and functional validation remain ongoing; this README does not claim completed verification sign-off.

📘 Project Overview

This project implements a RAM-based peripheral using the AMBA Advanced Peripheral Bus (APB) and develops a SystemVerilog verification environment to evaluate its functional behavior.

The project focuses on APB RTL design, transaction-level testbench development, simulation debug and an FPGA-oriented synthesis workflow. Functional validation and scoreboard refinement are still in progress.

The verification environment is organized around reusable components for generating transactions, driving the APB interface, monitoring activity, and checking the design response.

---

🎯 Objectives

- Implement an APB-based RAM using SystemVerilog.
- Model APB read and write transactions.
- Develop a structured verification environment.
- Generate stimulus for different APB operations.
- Monitor transactions at the interface.
- Compare expected and observed behavior.
- Analyze simulation results for functional correctness.
- Synthesize the design for FPGA implementation.

---

🚌 APB Interface

The Advanced Peripheral Bus (APB) is a low-complexity AMBA interface commonly used for communication with peripheral blocks.

An APB transfer is organized into two main phases:

        APB TRANSFER

          ┌─────────┐
          │  SETUP  │
          └────┬────┘
               │
               ▼
          ┌─────────┐
          │ ENABLE  │
          └─────────┘

During a write transaction, address and write data are presented to the peripheral.

During a read transaction, the peripheral returns the requested memory data through the APB read-data path.

---

🧩 Design Architecture

The project can be viewed as four major sections:

               ┌─────────────────────┐
               │      APB Master     │
               │   / Test Stimulus   │
               └──────────┬──────────┘
                          │
                          ▼
                 ┌─────────────────┐
                 │    APB RAM      │
                 │      RTL        │
                 └────────┬────────┘
                          │
                          ▼
                 ┌─────────────────┐
                 │ Memory Storage  │
                 └─────────────────┘

The verification side operates around the DUT to generate transactions, observe the APB interface, and determine whether the resulting behavior matches the expected operation.

---

🧪 Verification Environment

The test environment contains dedicated components for handling different verification tasks.

Generator

Creates APB transactions and provides the required stimulus for the DUT.

Driver

Converts generated transactions into signal-level activity on the APB interface.

Monitor

Observes APB signals and collects information about the transactions taking place.

Scoreboard

Checks the observed results against the expected behavior and helps identify functional mismatches.

Testbench

Connects the verification components with the APB RAM design and controls the simulation flow.

---

🔄 Verification Flow

Test Scenario
      ↓
Transaction Generation
      ↓
Driver
      ↓
APB Interface
      ↓
APB RAM DUT
      ↓
Monitor
      ↓
Expected vs. Observed Comparison
      ↓
Test Result

This structure separates stimulus generation, signal driving, monitoring, and checking, making the verification flow easier to understand and extend.

---

💾 APB RAM Operation

The RAM is accessed through APB transactions.

Write Operation

1. Select the APB peripheral
2. Provide the memory address
3. Indicate a write operation
4. Drive write data
5. Complete the APB transfer
6. Store the data in the selected memory location

Read Operation

1. Select the APB peripheral
2. Provide the memory address
3. Indicate a read operation
4. Complete the APB transfer
5. Return the stored data

The verification environment can then check whether the returned data matches the value previously written to the corresponding location.

---

📊 Simulation & Verification

Simulation is used to evaluate the functional behavior of the APB RAM.

The verification process focuses on:

- APB write transactions
- APB read transactions
- Address handling
- Data transfer
- Memory storage and retrieval
- Reset behavior
- Expected-versus-observed results

The project documentation identifies Aldec Riviera Pro 2022.04 as the simulation environment used for the design and verification flow.

---

⚙️ Synthesis Flow

The documented workflow targets Intel Quartus Prime with a MAX 10 FPGA. Because functional validation is still in progress, this synthesis flow should not be interpreted as completed verification sign-off or a validated FPGA deployment.

The overall flow is:

SystemVerilog RTL
       ↓
Functional Simulation
       ↓
Verification
       ↓
RTL Synthesis
       ↓
FPGA Netlist
       ↓
MAX 10 Target

This gives the project exposure beyond simulation and connects RTL development with practical FPGA implementation.


---

🛠️ Tools & Technologies

Area| Technology
HDL| SystemVerilog
Protocol| AMBA APB
Design Type| APB RAM
Verification| SystemVerilog Test Environment
Simulation| Aldec Riviera Pro 2022.04
Synthesis| Intel Quartus Prime
FPGA Target| Intel MAX 10

---

🧠 Skills Demonstrated

- SystemVerilog RTL Design
- APB Protocol
- Digital Design
- Memory / RAM Modeling
- Testbench Development
- Transaction-Based Verification
- Generator-Driver-Monitor Architecture
- Scoreboard-Based Checking
- Simulation Debugging
- RTL Synthesis
- FPGA Design Flow

---

📚 Key Learning Outcomes

This project provides practical experience in:

- Understanding the APB bus transaction flow
- Designing protocol-based RTL
- Connecting a memory model to a peripheral interface
- Building a structured SystemVerilog verification environment
- Generating and monitoring digital transactions
- Checking functional correctness using a scoreboard
- Interpreting simulation results
- Moving verified RTL toward FPGA synthesis

---

🔍 Why This Project Matters

This project combines three important areas of digital hardware development:

        RTL DESIGN
            +
      FUNCTIONAL
       VERIFICATION
            +
        FPGA FLOW

It therefore demonstrates experience with both design and verification, rather than focusing only on writing RTL.

---

📌 Project Summary

Project: APB RAM Design & Verification using SystemVerilog 
Protocol: AMBA APB
HDL: SystemVerilog
Verification: Structured SystemVerilog Test Environment
Simulation: Aldec Riviera Pro 2022.04
Synthesis: Intel Quartus Prime
Target: MAX 10 FPGA

---
