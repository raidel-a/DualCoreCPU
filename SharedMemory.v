module SharedMemory (
    input clock,
    input [31:0] addr,
    input write_enable,
    input [31:0] write_data,
    output reg [31:0] read_data
);

    // Memory array declaration
    reg [31:0] memory [0:1023]; // 1024 words of 32-bit memory
    
    // Address calculation
    wire [9:0] word_addr = addr[11:2]; // Only use relevant address bits
    
    // Memory write and read operations
    always @(posedge clock) begin
        if (write_enable) begin
            memory[word_addr] <= write_data;
        end
        read_data <= memory[word_addr];
    end

    // Initialize memory to zero
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            memory[i] = 32'b0;
        end
    end

endmodule
