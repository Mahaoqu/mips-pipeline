`timescale 1ns / 1ps
`include "global.v"
module RAM(input clk,                      //时钟信号
           input rst,                      //重置信号
           input read_en,                  //读使能信号
           input write_en,                 //写使能信号
           input [3:0]write_sel,           //要写入哪些字节的标志
           input [`AddrBus]addr,           //输入地址，严格按照4字节对齐
           input [`DataBus]data_in,        //要写入的数据
           output reg [`DataBus]data_out);
           
    reg[7:0] data_mem0[0:65535];
    reg[7:0] data_mem1[0:65535];
    reg[7:0] data_mem2[0:65535];
    reg[7:0] data_mem3[0:65535];
    //写操作
    always@(posedge clk)
    begin
        if (rst == 1)
            for(integer i = 0;i<65536;i = i+1)
            begin
                data_mem0[i] = 0;
                data_mem1[i] = 0;
                data_mem2[i] = 0;
                data_mem3[i] = 0;
            end
        else
        begin
            if (write_en)
            begin
                if (write_sel[0] == 1)
                    data_mem0[addr[31:2]] <= data_in[7:0];
                
                if (write_sel[1] == 1)
                    data_mem1[addr[31:2]] <= data_in[15:8];
                
                if (write_sel[2] == 1)
                    data_mem2[addr[31:2]] <= data_in[23:16];
                
                if (write_sel[3] == 1)
                    data_mem3[addr[31:2]] <= data_in[31:24];
                
            end
        end
    end
    
    //读操作
    always@*
    begin
        if (read_en)
        begin
            data_out[7: 0]  <= data_mem0[addr[31:2]];
            data_out[15: 8] <= data_mem1[addr[31:2]];
            data_out[23:16] <= data_mem2[addr[31:2]];
            data_out[31:24] <= data_mem3[addr[31:2]];
        end
    end
endmodule
