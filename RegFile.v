`timescale 1ns / 1ps
`include "global.v"
module RegFile(input clk,                    //时钟信号
               input rst,                    //重置信号
               input read_en_1,              //读使能信号1
               input [4:0]read_addr_1,       //要读取的寄存器编号1
               output reg [31:0]read_data_1, //输出数据1
               input read_en_2,              //读使能信号2
               input [4:0]read_addr_2,       //要读取的寄存器编号2
               output reg [31:0]read_data_2, //输出数据2
               input write_en,               //写使能信号
               input [4:0]write_addr,        //要写入的寄存器编号
               input [31:0]write_data);
    
    reg [31:0]file[31:0];
    integer i;
    
    initial
    begin
        for(i = 0;i<32;i = i+1) file[i] = 32'b0;
    end

    //读数据
    always@*
    begin
        if (read_en_1)
            read_data_1 = file[read_addr_1];
        
        if (read_en_2)
            read_data_2 = file[read_addr_2];

    end
    
    //写数据
    always@(posedge clk)
    begin
        if (rst == 1)
            file[write_addr] = 0;
            
        else
        begin
            if (write_en&&write_addr! = 0)
                file[write_addr] = write_data;
            
        end
    end
endmodule
