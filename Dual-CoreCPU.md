# Dual-Core CPU Implementation Details

## Overview
This implementation extends the FIUSCIS-CDA single-cycle CPU into a dual-core system with shared memory. The key additions include memory arbitration and a shared memory system that allows both cores to communicate.

## Key Components

### 1. DualCoreCPU (DualCoreCPU.bdf)
The top-level block diagram implements:
- Two instances of CPU_SingleCycle (core0 and core1)
- A MemoryArbiter module
- A SharedMemory module
- Clock and reset distribution

Key differences from original FIUSCIS-CDA:
- Removed internal memory from CPU cores
- Added memory interface signals (mem_addr, mem_write, mem_writedata, mem_readdata)
- Implemented shared memory access through arbiter

### 2. Modified CPU_SingleCycle
Changes from original FIUSCIS-CDA implementation:

```verilog
module CPU_SingleCycle(
// Original ports maintained
input wire clk,
input wire reset,
output wire Overflow,
output wire [5:0] FUNCTCODE,
output wire [31:26] OPCODE,
output wire [31:0] PC,
// New memory interface ports
output wire [31:0] mem_addr,
output wire mem_write,
output wire [31:0] mem_writedata,
input wire [31:0] mem_readdata
);
```


Key modifications:
- Removed internal DM_synch module
- Added external memory interface
- Maintained original instruction handling
- Memory operations now route through arbiter

### 3. Memory Arbiter (MemoryArbiter.v)
Purpose: Manages memory access between cores to prevent conflicts
Features:
- Round-robin arbitration
- Separate interfaces for each core
- Single interface to shared memory
- Conflict resolution logic

### 4. Shared Memory (SharedMemory.v)
Purpose: Provides shared memory space accessible by both cores
Features:
- Synchronous read/write operations
- 1024 words (32-bit each)
- Single port access through arbiter

## Why Separate Memory Implementation?

The original FIUSCIS-CDA CPU_SingleCycle used internal memory modules:
1. IM (Instruction Memory)
2. DM_synch (Data Memory)

For dual-core operation, we needed:
1. Shared data memory access
2. Conflict prevention
3. Inter-core communication

Solution:
- Keep original IM in each core (separate instruction spaces)
- Replace DM_synch with external SharedMemory
- Add MemoryArbiter for controlled access

## Quartus Implementation Guide

1. Project Setup:

```tcl
Create new project
Add all files to project
Set DualCoreCPU as top-level entity
```


2. Required Files:
- DualCoreCPU.bdf
- CPU_SingleCycle.v
- MemoryArbiter.v
- SharedMemory.v
- Original FIUSCIS-CDA components

3. Block Diagram Setup:

1. Open DualCoreCPU.bdf
Add two CPU_SingleCycle instances
Add MemoryArbiter instance
Add SharedMemory instance
5. Connect signals:
Clock and reset to all components
Memory interfaces through arbiter
Arbiter to shared memory

4. Memory Configuration:

```verilog
// In SharedMemory.v
parameter MEM_SIZE = 1024; // Adjustable memory size
```


5. Compilation Steps:
- Analysis & Synthesis
- Place & Route
- Timing Analysis
- Generate Programming File

## Testing and Verification

1. Memory Access Patterns:

```mips
Core 0 writes to address 0
sw $2, 0($0)
Core 1 reads from address 0
lw $3, 0($0)
```


2. Arbiter Verification:
- Check round-robin operation
- Verify no simultaneous access
- Confirm data consistency

3. Timing Considerations:
- Memory operations take 1-2 cycles
- Arbitration adds 1 cycle latency
- Core synchronization through memory

## Key Differences from Original

1. Memory Architecture:
- Original: Single core, internal memory
- New: Dual core, shared external memory

2. Data Access:
- Original: Direct memory access
- New: Arbitrated access

3. System Complexity:
- Original: Standalone CPU
- New: Multi-core system with arbitration

4. Performance Implications:
- Added memory access latency
- Potential memory contention
- Inter-core communication overhead

## Usage Notes

1. Memory Mapping:
- Lower addresses (0x000-0x3FF): Shared data
- Each core has separate instruction memory

2. Core Synchronization:
- Use memory locations for flags/signals
- Implement software-level synchronization

3. Performance Optimization:
- Minimize shared memory access
- Use local registers when possible
- Consider memory access patterns