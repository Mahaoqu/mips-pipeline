`timescale 1ns / 1ps
`include "global.v"

module PC(
    input clk,
    input rst,
    input branch_flag, 
    input[`AddrBus] branch_addr, 
    input stall_pc,
    output reg rom_en, 
    output reg[`AddrBus] addr 
    );

    always@(posedge clk) 
    begin 
        rom_en <= !rst;
    end

    always@(posedge clk) 
    begin
        if (!rom_en)
            addr <= `AddrBusWidth'b0; 
        else if (!stall_pc) 
        begin 
            if(branch_flag) 
                 addr <= branch_addr; 
            else 
                 addr <= addr + 4; 
        end
    end    
endmodule