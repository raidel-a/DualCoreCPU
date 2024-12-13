`timescale 1ns/1ps

module DualCoreCPU_tb();
    // Test signals
    reg clock;
    reg reset;
    
    // Core 0 signals to monitor
    wire [31:0] core0_pc;
    wire [31:0] core0_mem_addr;
    wire core0_mem_write;
    wire [31:0] core0_mem_writedata;
    wire [31:0] core0_mem_readdata;
    
    // Core 1 signals to monitor
    wire [31:0] core1_pc;
    wire [31:0] core1_mem_addr;
    wire core1_mem_write;
    wire [31:0] core1_mem_writedata;
    wire [31:0] core1_mem_readdata;
    
    // Shared memory signals to monitor
    wire [31:0] shared_addr;
    wire shared_write;
    wire [31:0] shared_writedata;
    wire [31:0] shared_readdata;

    // Instantiate DualCoreCPU
    DualCoreCPU dut (
        .clock(clock),
        .reset(reset)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    // Test stimulus
    initial begin
        // Initialize waveform dump
        $dumpfile("DualCoreCPU_tb.vcd");
        $dumpvars(0, DualCoreCPU_tb);

        // Reset sequence
        reset = 1;
        @(posedge clock);
        @(posedge clock);
        reset = 0;

        // Wait for some cycles to observe memory operations
        repeat(100) @(posedge clock);

        // End simulation
        $display("Simulation complete");
        $finish;
    end

    // Monitor memory operations
    always @(posedge clock) begin
        if (core0_mem_write)
            $display("Core0 Write: Addr=%h Data=%h", core0_mem_addr, core0_mem_writedata);
        if (core1_mem_write)
            $display("Core1 Write: Addr=%h Data=%h", core1_mem_addr, core1_mem_writedata);
        
        // Monitor read data
        if (core0_mem_readdata !== 32'bx)
            $display("Core0 Read: Addr=%h Data=%h", core0_mem_addr, core0_mem_readdata);
        if (core1_mem_readdata !== 32'bx)
            $display("Core1 Read: Addr=%h Data=%h", core1_mem_addr, core1_mem_readdata);
    end

    // Check for memory conflicts
    always @(posedge clock) begin
        if (core0_mem_write && core1_mem_write && 
            core0_mem_addr == core1_mem_addr)
            $display("WARNING: Memory conflict detected at address %h", core0_mem_addr);
    end

    // Verify arbiter operation
    property valid_arbitration;
        @(posedge clock) disable iff (reset)
        (core0_mem_write && core1_mem_write) |-> 
        ##1 $onehot({shared_addr == core0_mem_addr, shared_addr == core1_mem_addr});
    endproperty

    assert property (valid_arbitration)
        else $error("Arbitration failed: Multiple cores accessing memory simultaneously");

endmodule 