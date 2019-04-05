`timescale 1ns / 1ps
`include "global.v"
module ID_EX(
    input clk,
    input rst,
    input[`FunctBus] funct_in,
    input[`DataBus] operand_1_in ,
    input[`DataBus] operand_2_in ,
    input[`ShamtBus] shamt_in,
    input write_reg_en_in,
    input[`RegAddrBus] write_reg_addr_in,
    
    input mem_read_flag_in,
    input mem_write_flag_in,
    input[`AddrBus] mem_addr_in,
    input[`DataBus] mem_write_data_in,
    
    input stall_id,
    input stall_ex,
     
    output [`FunctBus] funct_out,
    output [`DataBus] operand_1_out ,
    output [`DataBus] operand_2_out ,
    output [`ShamtBus] shamt_out,
    output  write_reg_en_out,
    output [`RegAddrBus] write_reg_addr_out,
    
    output  mem_read_flag_out,
    output  mem_write_flag_out,
    output [`AddrBus] mem_addr_out,
    output [`DataBus] mem_write_data_out
           
);

// TODO
PiplineDeliver#(`FunctBusWidth)   funct         (clk, rst, stall_id, stall_ex, funct_in,          funct_out);
PiplineDeliver#(`DataBusWidth)    oper1         (clk, rst, stall_id, stall_ex, operand_1_in,      operand_1_out);
PiplineDeliver#(`DataBusWidth)    oper2         (clk, rst, stall_id, stall_ex, operand_2_in,      operand_2_out);
PiplineDeliver#(`ShamtBusWidth)   shamt         (clk, rst, stall_id, stall_ex, shamt_in,          shamt_out);

PiplineDeliver#(1)                write_reg_en  (clk, rst, stall_id, stall_ex, write_reg_en_in,   write_reg_en_out);
PiplineDeliver#(`RegAddrBusWidth) write_reg_addr(clk, rst, stall_id, stall_ex, write_reg_addr_in, write_reg_addr_out);

PiplineDeliver#(1)                mem_read_flag (clk, rst, stall_id, stall_ex, mem_read_flag_in,  mem_read_flag_out);
PiplineDeliver#(1)                mem_write_flag(clk, rst, stall_id, stall_ex, mem_write_flag_in, mem_write_flag_out);
PiplineDeliver#(`AddrBusWidth)    mem_addr      (clk, rst, stall_id, stall_ex, mem_addr_in,       mem_addr_out);
PiplineDeliver#(`DataBusWidth)    mem_write_data(clk, rst, stall_id, stall_ex, mem_write_data_in, mem_write_data_out);

endmodule
