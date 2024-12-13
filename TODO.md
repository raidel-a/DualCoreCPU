## Remaining for Dual-Core CPU design
### Verify Connections:
Ensure all connections between the CPU cores, MemoryArbiter, and SharedMemory are correct.
Specifically, confirm that:
Both CPU cores' memory interfaces (mem_write, mem_addr, mem_writedata, mem_readdata) are properly routed through the MemoryArbiter to the SharedMemory.
Clock and reset signals are correctly distributed to all components.
### Test Functionality:
Simulate the system to verify that both cores can access shared memory without conflicts.
Confirm that the arbiter handles read and write requests correctly.


## GPU Component
The GPU component will be a SingleCycle GPU.

### Features of the GPU:
#### Multiple Processing Elements (PEs):
The GPU will consist of multiple parallel processing elements (similar to simplified CPU cores).
Each PE will execute instructions independently but share access to global memory.

#### Shared Memory:
The same SharedMemory block can be used for the GPU.
The MemoryArbiter must be updated to handle requests from both CPU cores and GPU PEs.

#### Instruction Set:
Define a simple instruction set for the GPU (e.g., arithmetic operations, memory load/store).

#### Control Unit:
Add a control unit for coordinating execution across PEs.

