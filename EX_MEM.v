`timescale 1ns / 1ps
`include "global.v"
module EX_MEM(input clk,
              input rst,
              input[`DataBus] data_in,
              input reg_write_en_in,
              input[`RegAddrBus]reg_addr_in,
              input mem_read_flag_in,
              input mem_write_flag_in,
              input[`AddrBus] mem_addr_in,
              input[`DataBus] mem_write_data_in,
              input hilo_write_en_in,
              input [`DataBus]hi_in,
              input [`DataBus]lo_in,
              input stall_ex,
              input stall_mem,
              output [`DataBus] data_out,
              output reg_write_en_out,
              output[`RegAddrBus] reg_addr_out,
              output mem_read_flag_out,
              output mem_write_flag_out,
              output [`AddrBus] mem_addr_out,
              output [`DataBus] mem_write_data_out,
              output hilo_write_en_out,
              output [`DataBus]hi_out,
              output [`DataBus]lo_out);
    
    PiplineDeliver#(`DataBusWidth)    data          (clk, rst, stall_ex, stall_mem, data_in,           data_out);
    PiplineDeliver#(1)                reg_write_en  (clk, rst, stall_ex, stall_mem, reg_write_en_in,   reg_write_en_out);
    PiplineDeliver#(`RegAddrBusWidth) reg_addr      (clk, rst, stall_ex, stall_mem, reg_addr_in,       reg_addr_out);
    
    PiplineDeliver#(1)                mem_read_flag (clk, rst, stall_ex, stall_mem, mem_read_flag_in,  mem_read_flag_out);
    PiplineDeliver#(1)                mem_write_flag(clk, rst, stall_ex, stall_mem, mem_write_flag_in, mem_write_flag_out);
    PiplineDeliver#(`AddrBusWidth)    mem_addr      (clk, rst, stall_ex, stall_mem, mem_addr_in,       mem_addr_out);
    PiplineDeliver#(`DataBusWidth)    mem_write_data(clk, rst, stall_ex, stall_mem, mem_write_data_in, mem_write_data_out);
    
    PiplineDeliver#(1)                hilo_write_en (clk, rst, stall_ex, stall_mem, hilo_write_en_in,  hilo_write_en_out);
    PiplineDeliver#(`DataBusWidth)    hi            (clk, rst, stall_ex, stall_mem, hi_in,             hi_out);
    PiplineDeliver#(`DataBusWidth)    lo            (clk, rst, stall_ex, stall_mem, lo_in,             lo_out);
    
    
    
endmodule
