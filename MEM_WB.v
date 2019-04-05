`timescale 1ns / 1ps
`include "global.v"
module MEM_WB(
    input clk,
    input rst,
    
    input[`DataBus] data_in,
    input reg_write_en_in,
    input[`RegAddrBus]reg_addr_in,
    
    input hilo_write_en_in,
    input [`DataBus]hi_in,
    input [`DataBus]lo_in,
    
    input stall_mem,
    input stall_wb,
    
    output[`DataBus]  data_out,
    output reg_write_en_out,
    output[`RegAddrBus] reg_addr_out,
    
    output  hilo_write_en_out,
    output [`DataBus]hi_out,
    output [`DataBus]lo_out
);

PiplineDeliver#(`DataBusWidth)    data         (clk, rst, stall_mem, stall_wb, data_in,          data_out);
PiplineDeliver#(1)                reg_write_en (clk, rst, stall_mem, stall_wb, reg_write_en_in,  reg_write_en_out);
PiplineDeliver#(`RegAddrBusWidth) reg_addr     (clk, rst, stall_mem, stall_wb, reg_addr_in,      reg_addr_out);

PiplineDeliver#(1)                hilo_write_en(clk, rst, stall_mem, stall_wb, hilo_write_en_in, hilo_write_en_out);
PiplineDeliver#(`DataBusWidth)    hi           (clk, rst, stall_mem, stall_wb, hi_in,            hi_out);
PiplineDeliver#(`DataBusWidth)    lo           (clk, rst, stall_mem, stall_wb, lo_in,            lo_out);

endmodule