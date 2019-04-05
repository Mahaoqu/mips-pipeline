`timescale 1ns / 1ps
`include "global.v"

module HILO(
    input clk,
    input rst,
    input write_en,
    input[`DataBus] hi_in,
    input[`DataBus] lo_in,
    output reg[`DataBus] hi,
    output reg[`DataBus] lo
);

always@(posedge clk) 
begin
    if (rst) 
    begin
        hi <= 0;
        lo <= 0; 
    end
    else if (write_en) 
    begin 
        hi <= hi_in;
        lo <= lo_in;
    end
end
endmodule