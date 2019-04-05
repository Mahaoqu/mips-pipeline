`timescale 1ns / 1ps
`include "global.v"
module MEM(
    input clk,
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
    
    output[`DataBus]  data_out,
    output reg_write_en_out,
    output[`RegAddrBus] reg_addr_out,
    
    output hilo_write_en,
    output [`DataBus]hi_out,
    output [`DataBus]lo_out
);

wire [`DataBus]mem_data;

RAM RAM0(clk, rst, mem_read_flag_in, mem_write_flag_in, 4'b1111, 
    mem_addr_in, mem_write_data_in, mem_data
);

assign data_out = mem_read_flag_in ? mem_data:data_in;
assign reg_write_en_out = reg_write_en_in;
assign reg_addr_out = reg_addr_in;

assign hilo_write_en = hilo_write_en_in;
assign hi_out = hi_in;
assign lo_out = lo_in;


endmodule
