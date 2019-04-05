`timescale 1ns / 1ps
`include "global.v"
module RegReadProxy(input read_en_1,
                    input read_en_2,
                    input[`RegAddrBus]read_addr_2,
                    input[`RegAddrBus]read_addr_1,
                    input[`DataBus] data_from_ex,
                    input reg_write_en_from_ex,
                    input[`RegAddrBus] reg_write_addr_from_ex,
                    input[`DataBus] data_from_mem,
                    input reg_write_en_from_mem,
                    input[`RegAddrBus] reg_write_addr_from_mem,
                    input[`DataBus] data_1_from_reg,
                    input[`DataBus] data_2_from_reg,
                    output reg [`DataBus] read_data_1,
                    output reg [`DataBus] read_data_2);
    // 两个转发目的
    always @(*)
    begin
        if (read_addr_1 == 0)
            read_data_1 = 0;
        else if (read_addr_1 == reg_write_addr_from_mem && reg_write_en_from_mem)
            read_data_1 = data_from_mem;
        else if (read_addr_1 == reg_write_addr_from_ex && reg_write_en_from_ex)
            read_data_1 = data_from_ex;
        else
            read_data_1 = data_1_from_reg;
    end
    
    always @(*)
    begin
        if (read_addr_2 == 0)
            read_data_2 = 0;
        
        if (read_addr_2 == reg_write_addr_from_mem && reg_write_en_from_mem)
            read_data_2 = data_from_mem;
        
        else if (read_addr_2 == reg_write_addr_from_ex && reg_write_en_from_ex)
            read_data_2 = data_from_ex;
        
        else
            read_data_2 = data_2_from_reg;
    end
    
endmodule // RegReadProxy
