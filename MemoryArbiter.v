module MemoryArbiter (
    input clock,
    input reset,
    // Core0 interface
    input core0_mem_write,
    input [31:0] core0_mem_addr,
    input [31:0] core0_mem_writedata,
    output reg [31:0] core0_mem_readdata,
    // Core1 interface
    input core1_mem_write,
    input [31:0] core1_mem_addr,
    input [31:0] core1_mem_writedata,
    output reg [31:0] core1_mem_readdata,
    // Shared memory interface
    output reg [31:0] shared_addr,
    output reg shared_write,
    output reg [31:0] shared_writedata,
    input [31:0] shared_readdata
);

    // Round-robin arbitration
    reg current_core;
    
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            current_core <= 0;
            shared_write <= 0;
            shared_addr <= 32'b0;
            shared_writedata <= 32'b0;
            core0_mem_readdata <= 32'b0;
            core1_mem_readdata <= 32'b0;
        end
        else begin
            if (core0_mem_write && !current_core) begin
                shared_addr <= core0_mem_addr;
                shared_writedata <= core0_mem_writedata;
                shared_write <= 1;
                current_core <= 1;
                core0_mem_readdata <= shared_readdata;
            end
            else if (core1_mem_write && current_core) begin
                shared_addr <= core1_mem_addr;
                shared_writedata <= core1_mem_writedata;
                shared_write <= 1;
                current_core <= 0;
                core1_mem_readdata <= shared_readdata;
            end
            else begin
                shared_write <= 0;
                // Handle read operations
                if (!current_core) begin
                    shared_addr <= core0_mem_addr;
                    core0_mem_readdata <= shared_readdata;
                end else begin
                    shared_addr <= core1_mem_addr;
                    core1_mem_readdata <= shared_readdata;
                end
            end
        end
    end

endmodule
