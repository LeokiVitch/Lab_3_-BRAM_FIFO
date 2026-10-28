# Lab_3_-BRAM_FIFO

## Screenshots 
Synthesis Memory Report
<img width="412" height="109" alt="Screenshot 2026-10-27 232452" src="https://github.com/user-attachments/assets/5a20dec1-9f50-402c-b9ad-d6697cdffef1" />

<img width="366" height="107" alt="Screenshot 2026-10-27 232515" src="https://github.com/user-attachments/assets/d0c76aab-4bf1-43c5-90fb-2397ee8d42c7" />


## Overview

This lab focused on designing and verifying a synchronous FIFO using Verilog and Vivado. The FIFO is parameterized for data width, depth, almost-full and almost-empty thresholds, and read latency. Its storage array is marked for block RAM inference.

## Design Summary

The default design stores 16-bit words and has a depth of 32 entries.

- The FIFO reports its data count, FULL, EMPTY, ALMOST_FULL, and ALMOST_EMPTY status.
- Writes are accepted when the FIFO is not full, and reads are accepted when it is not empty.
- DATA_OUT and VALID reflect the configured read latency.

## Verification and Results

The Verilog testbench uses a 50 MHz clock and covers six test cases:

- Reset behavior, including clearing the count, output, and VALID signal.
- Write and read sequences using all 1s, all 0s, and alternating bit patterns.
- Writing and reading a distinct value at every FIFO location.
- FULL, EMPTY, ALMOST_FULL, and ALMOST_EMPTY flag behavior.
- Write and read enable behavior, including ignoring a read while the FIFO is empty.

The testbench checks the output data and status after each operation and prints a PASS message after all six test cases complete.

## Known Issues or Limitations

No known issues in the scope of this class.

## Sources

ECE 520/L Lab 3 references and slides. 

ChatGPT
