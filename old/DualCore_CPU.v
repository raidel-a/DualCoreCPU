module DualCore_CPU (
    input clock,
    input reset,
    output [31:0] shared_addr,
    output shared_write,
    output [31:0] shared_writedata,
    input [31:0] shared_readdata
);
