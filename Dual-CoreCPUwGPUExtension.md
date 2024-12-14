# Dual-Core CPU with GPU Extension

## Overview
This project implements a dual-core MIPS CPU with a GPU extension, built upon the FIUSCIS-CDA single-cycle CPU architecture. The system features two CPU cores that share memory access through an arbiter, and a GPU component with multiple Processing Elements (PEs) for parallel computation.

## Architecture
![Dual-Core CPU Architecture](./docs/dualcore_architecture.png)

The system consists of:
- Two Single-Cycle CPU cores (based on FIUSCIS-CDA CPU_SingleCycle)
- Memory Arbiter for managing shared memory access
- Shared Memory module
- GPU module with multiple Processing Elements

### Components

#### CPU Cores
Each CPU core is a complete MIPS single-cycle implementation supporting:
- R-type arithmetic instructions
- I-type immediate and memory operations
- Memory read/write operations

#### Memory Arbiter
Manages memory access between components:
- Round-robin arbitration between CPU cores and GPU
- Conflict resolution for simultaneous memory requests
- Read/Write operation handling

#### GPU Module
SIMD-style processing unit featuring:
- 4 Processing Elements (PEs)
- Shared register file between PEs
- State machine for operation control
- Memory interface for data transfer

## Interface

### DualCoreCPU Top Level 
```verilog
module DualCoreCPU(
    input wire clk, System clock
    inpe wire clock, System reset
);
```

### GPU_SingleCycle
```verilog
module GPU_SingleCycle (
input wire clk, // System clock
input wire reset, // System reset
output wire [31:0] mem_addr, // Memory address
output wire mem_write, // Memory write enable
output wire [31:0] mem_writedata, // Data to write
input wire [31:0] mem_readdata, // Data read from memory
input wire [31:0] instruction, // Current instruction
input wire start, // Start execution
output wire done // Execution complete
);
```


## Testing

### Test Program
The system includes a test program demonstrating inter-core communication:
```mips
Core 0
addi $2, $0, 1 # Store 1 in register $2
sw $2, 0($0) # Store to shared memory
lw $3, 0($0) # Load from shared memory
Core 1
addi $2, $0, 3 # Store 3 in register $2
sw $2, 8($0) # Store to shared memory
lw $3, 4($0) # Load from shared memory
```


### Verification
Use the provided testbench to verify:
1. Memory access arbitration
2. Inter-core communication
3. GPU operation
4. System stability


Compile the design
```
iverilog -o dual_core_test DualCoreCPU_tb.v DualCoreCPU.v CPU_SingleCycle.v MemoryArbiter.v SharedMemory.v GPU_SingleCycle.v
```

Run simulation
```
vvp dual_core_test
```

View waveforms
```
gtkwave DualCoreCPU_tb.vcd


## Dependencies
- Icarus Verilog (iverilog)
- GTKWave for waveform viewing
- MIPS toolchain for program compilation

## Implementation Notes
1. The system clock should be stable with a 50% duty cycle
2. Reset should be asserted for at least 2 clock cycles
3. Memory arbitration adds 1-2 cycle latency to memory operations
4. GPU operations require proper synchronization with start/done signals

## PossibleFuture Enhancements
- Cache implementation for each CPU core
- Extended GPU instruction set
- Additional Processing Elements in GPU
- DMA controller for efficient data transfer

## References
1. [FIUSCIS-CDA CPU_SingleCycle](https://github.com/FIUSCIS-CDA/CPU_SingleCycle)
2. Patterson and Hennessy, "Computer Organization and Design"
3. 
