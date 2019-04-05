`timescale 1ns / 1ps
`timescale 1ns / 1ps
`include "global.v"

`define DivFree 2'b00
`define DivByZero 2'b01
`define DivOn 2'b10
`define DivEnd 2'b11

module Divider(input clk,
               input rst,
               input is_signed,
               input start,
               input cancel,
               input[`DataBus] operand1,
               input[`DataBus] operand2,
               output reg ready,
               output reg[`DoubleDataBus] result);
    
    reg[5:0] count;
    reg[64:0] dividend;
    reg[1:0] state;
    reg[31:0] divisor;
    wire[32:0] div_temp = {1'b0, dividend[63:32]} - {1'b0, divisor};
    
    always@(posedge clk)
    begin
        if (rst)
        begin
            state  <= 0;
            ready  <= 0;
            result <= 0;
        end
        else
            case(state)
                `DivFree:
                begin
                    if (start && !cancel)
                    begin
                        if (operand2 == 0)
                        begin
                            state <= `DivByZero;
                        end
                        else
                        begin
                            state    <= `DivOn;
                            count    <= 0;
                            dividend <= 0;
                            dividend[32:1]  < = (is_signed && operand1[31] == 1'b1 ? (~operand1+1): operand1);
                            divisor         < = (is_signed && operand2[31] == 1'b1 ? (~operand2+1): operand2);
                        end
                    end
                    else
                    begin
                        ready  <= 0;
                        result <= 0;
                    end
                end
                `DivByZero:
                begin
                    dividend <= 0;
                    state    <= `DivEnd;
                end
                `DivOn:
                begin
                    if (!cancel)
                    begin
                        if (count ! = 6'b100000)
                        begin
                            if (div_temp[32] == 1'b1)
                            begin
                                dividend <= {dividend[63:0], 1'b0};
                            end
                            else
                            begin
                                dividend <= {div_temp[31:0],
                                dividend[31:0], 1'b1};
                            end
                            count <= count + 1;
                        end
                        else
                        begin // count == 32
                            if (is_signed)
                            begin
                                if ((operand1[31] ^ operand2[31]) == 1'b1) dividend[31:0] < = (~dividend[31:0] + 1);
                                if ((operand1[31] ^ dividend[64]) == 1'b1) dividend[64:33] < = (~dividend[64:33] + 1);
                            end
                            state <= `DivEnd;
                            count <= 0;
                        end
                    end
                    else
                    begin
                        state <= `DivFree;
                    end
                end
                `DivEnd:
                begin
                    result <= {dividend[64:33], dividend[31:0]}; ready <= 1;
                    if (!start)
                    begin
                        state  <= `DivFree;
                        ready  <= 0;
                        result <= 0;
                    end
                end
            endcase
    end
endmodule
