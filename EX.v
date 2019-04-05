`timescale 1ns / 1ps
`include "global.v"

module EX(input rst,
          input[`FunctBus] funct,
          input[`DataBus] operand_1,
          input[`DataBus] operand_2,
          input[`ShamtBus] shamt,
          input write_reg_en_in,
          input[`RegAddrBus] write_reg_addr_in,
          input mem_read_flag_in,
          input mem_write_flag_in,
          input[`AddrBus] mem_addr_in,
          input[`DataBus] mem_write_data_in,
          input [`DataBus]hi_in,
          input [`DataBus]lo_in,
          input ready,
          input [`DoubleDataBus]div_res,
          output[`DataBus] result_out,
          output write_reg_en_out,
          output[`RegAddrBus] write_reg_addr_out,
          output mem_read_flag_out,
          output mem_write_flag_out,
          output[`AddrBus] mem_addr_out,
          output[`DataBus] mem_write_data_out,
          output reg hilo_write_en,
          output reg[`DataBus] hi_out,
          output reg[`DataBus] lo_out,
          output reg pause_req_ex,
          output is_signed,
          output reg start,
          output reg cancel,
          output reg[`DataBus] operand_out_1,
          output reg[`DataBus] operand_out_2);

    assign write_reg_addr_out = rst ? 0 : write_reg_addr_in;
    assign write_reg_en_out   = rst ? 0: write_reg_en_in;
    assign mem_read_flag_out  = rst ? 0 : mem_read_flag_in;
    assign mem_write_flag_out = rst ? 0 : mem_write_flag_in;
    assign mem_addr_out       = rst ? 0 : mem_addr_in;
    assign mem_write_data_out = rst ? 0 : mem_write_data_in;
    
    reg[`DataBus] result;
    assign result_out = (rst ? 0 : result);
    
    // ALU
    always@*
    begin
        case (funct)
            `FUNCT_ADD: result  <= (operand_1 + operand_2);
            `FUNCT_ADDU: result <= (operand_1 + operand_2);
            `FUNCT_SUB: result  <= (operand_1 - operand_2);
            `FUNCT_SUBU: result <= (operand_1 - operand_2);
            
            `FUNCT_AND: result <= (operand_1 & operand_2);
            `FUNCT_OR: result  <= (operand_1 | operand_2);
            `FUNCT_XOR: result <= (operand_1 ^ operand_2);
            `FUNCT_NOR: result <= ~(operand_1 | operand_2);
            
            `FUNCT_SLT: result  <= (operand_1<operand_2)?1:0;
            `FUNCT_SLTU: result <= (operand_1<operand_2)?1:0;
            
            `FUNCT_SLL: result <= (operand_2<<shamt);
            `FUNCT_SRL: result <= (operand_2>>shamt);
            `FUNCT_SRA: result <= ({{31{operand_2[31]}},1'b0}<<(~shamt)|(operand_2>>shamt));
            
            `FUNCT_SLLV: result <= (operand_2<<operand_1);
            `FUNCT_SRLV: result <= (operand_2>>operand_1);
            `FUNCT_SRAV: result <= ({{31{operand_2[31]}},1'b0}<<(~operand_1)|(operand_2>>operand_1));
            
            `FUNCT_MFLO: result <= lo_in;
            `FUNCT_MFHI: result <= hi_in;
            default:
            begin
                result <= 0;
            end
        endcase
    end
    
    // LO-HI
    wire[63:0]mul_res;
    assign mul_res = operand_1 * operand_2;
    
    always@*
    begin
    case (funct)
        `FUNCT_MULT, `FUNCT_MULTU:
        begin
            hi_out        = mul_res[63:32];
            lo_out        = mul_res[31: 0];
            hilo_write_en = 1;
        end
        `FUNCT_DIV, `FUNCT_DIVU :
        begin
            if (ready)
            begin
                hi_out        = div_res[63:32];
                lo_out        = div_res[31:0];
                hilo_write_en = 1;
            end
            else begin
                hi_out        = hi_in;
                lo_out        = lo_in;
                hilo_write_en = 0;
            end
        end
        
        `FUNCT_MTHI:
        begin
            hi_out        = operand_1;
            hilo_write_en = 1;
        end
        `FUNCT_MTLO:
        begin
            lo_out        = operand_1;
            hilo_write_en = 1;
        end
        
        default:
        begin
            hi_out        = hi_in;
            lo_out        = lo_in;
            hilo_write_en = 0;
        end
    endcase
    end
    
    //Divider
    assign is_signed = funct == `FUNCT_DIV  ? 1 :
    funct == `FUNCT_DIVU ? 0 : 1'bz;
    
    always@*
    begin
        if (rst)
        begin
            operand_out_1 = 0;
            operand_out_2 = 0;
            start         = 0 ;
            pause_req_ex  = 0;
        end
        else if (ready == 0)
        begin
            operand_out_1 = operand_1;
            operand_out_2 = operand_2;
            start         = 1;
            pause_req_ex  = 1;
        end
        else
        begin
            operand_out_1 = operand_1;
            operand_out_2 = operand_2;
            start         = 0 ;
            pause_req_ex  = 0;
        end
    end
    
    
endmodule
    
