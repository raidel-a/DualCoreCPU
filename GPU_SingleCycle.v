module GPU_SingleCycle (
    input wire clk,
    input wire reset,
    // Memory interface
    output wire [31:0] mem_addr,
    output wire mem_write,
    output wire [31:0] mem_writedata,
    input wire [31:0] mem_readdata,
    
    // Control interface
    input wire [31:0] instruction,
    input wire start,
    output wire done
);

    // Number of Processing Elements (PEs)
    parameter NUM_PES = 4;
    
    // Internal registers and wires
    reg [31:0] pe_registers [0:NUM_PES-1];
    reg [31:0] shared_registers [0:7]; // Shared registers between PEs
    
    // State machine
    reg [1:0] state;
    localparam IDLE = 2'b00;
    localparam RUNNING = 2'b01;
    localparam COMPLETE = 2'b10;
    
    // Control signals
    wire [5:0] opcode;
    wire [4:0] rd, rs, rt;
    wire [15:0] immediate;
    
    // Instruction decode
    assign opcode = instruction[31:26];
    assign rd = instruction[25:21];
    assign rs = instruction[20:16];
    assign rt = instruction[15:11];
    assign immediate = instruction[15:0];
    
    // Main state machine
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            // Reset all PE registers
            for (int i = 0; i < NUM_PES; i = i + 1) begin
                pe_registers[i] <= 32'b0;
            end
            // Reset shared registers
            for (int i = 0; i < 8; i = i + 1) begin
                shared_registers[i] <= 32'b0;
            end
        end
        else begin
            case (state)
                IDLE: begin
                    if (start) state <= RUNNING;
                end
                
                RUNNING: begin
                    // Implement PE execution logic here
                    // Each PE will execute the same instruction on different data
                    
                    // TODO: Add instruction execution logic
                    
                    // For now, just transition to COMPLETE
                    state <= COMPLETE;
                end
                
                COMPLETE: begin
                    state <= IDLE;
                end
            endcase
        end
    end
    
    // Output assignments
    assign done = (state == COMPLETE);
    
    // TODO: Implement memory interface logic
    assign mem_write = 1'b0;  // For now, no memory writes
    assign mem_addr = 32'b0;  // For now, no memory access
    assign mem_writedata = 32'b0;

endmodule 