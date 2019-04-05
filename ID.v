`include "global.v"

module ID(input rst,
          input[`DataBus] reg_data_1,
          input[`DataBus] reg_data_2,
          input[`AddrBus] addr,
          input[`InstBus] inst_2,
          output reg reg_read_en_1,
          output reg reg_read_en_2,
          output reg[`RegAddrBus] reg_addr_1,
          output reg[`RegAddrBus] reg_addr_2,
          output reg[`FunctBus] funct,
          output reg[`DataBus] operand_1,
          output reg[`DataBus] operand_2,
          output [`ShamtBus] shamt,
          output reg write_reg_en,
          output reg[`RegAddrBus] write_reg_addr,
          output reg mem_read_flag,
          output reg mem_write_flag,
          output reg[`AddrBus] mem_addr,
          output reg[`DataBus] mem_write_data,
          output reg branch_flag,
          output reg[`AddrBus] branch_addr,
          output reg pause_req_id);
    
    wire[`OpBus] inst_2_op      = inst_2[31:26];
    wire[`RegAddrBus] inst_2_rs = inst_2[25:21];
    wire[`RegAddrBus] inst_2_rt = inst_2[20:16];
    assign shamt                = inst_2[10:6];
    
    // For Read from Register
    always@(*)
    begin
        if (rst)
        begin
            reg_read_en_1 <= 0;
            reg_read_en_2 <= 0;
            reg_addr_1    <= 0;
            reg_addr_2    <= 0;
        end
        else
            case(inst_2_op)
                `OP_ADDI, `OP_ADDIU, `OP_SLTI, `OP_SLTIU, `OP_ANDI, `OP_ORI, `OP_XORI, `OP_BLEZ, `OP_BGTZ, `OP_LW, `OP_LUI: // Only Read one reg
                begin
                    reg_read_en_1 <= 1;
                    reg_read_en_2 <= 0;
                    reg_addr_1    <= inst_2_rs;
                    reg_addr_2    <= 0;
                end
                `OP_SPECIAL,`OP_BEQ,`OP_BNE,`OP_SW: // Read both reg
                begin
                    reg_read_en_1 <= 1;
                    reg_read_en_2 <= 1;
                    reg_addr_1    <= inst_2_rs;
                    reg_addr_2    <= inst_2_rt;
                end
                default:                            // Not Read
                begin
                    reg_read_en_1 <= 0;
                    reg_read_en_2 <= 0;
                    reg_addr_1    <= 0;
                    reg_addr_2    <= 0;
                end
            endcase
    end
    
    wire[`FunctBus] inst_2_funct = inst_2[5:0];
    
    // For ALU Function
    always@(*)
        case(inst_2_op)
            `OP_SPECIAL: funct                           <= inst_2_funct;
            `OP_ADDI, `OP_ADDIU, `OP_JAL, `OP_LUI: funct <= `FUNCT_ADD;
            `OP_SLTI:    funct                           <= `FUNCT_SLT;
            `OP_SLTIU:   funct                           <= `FUNCT_SLTU;
            `OP_ANDI:    funct                           <= `FUNCT_AND;
            `OP_ORI:     funct                           <= `FUNCT_OR;
            `OP_XORI:    funct                           <= `FUNCT_XOR;
            default:     funct                           <= `FUNCT_NOP;
        endcase
    
    // For Handling Operand_1
    always@(*)
    begin
        if (rst) operand_1 <= 0;
        else
        case(inst_2_op)
            `OP_SPECIAL, `OP_ADDI, `OP_ADDIU, `OP_SLTI, `OP_SLTIU, `OP_ANDI, `OP_ORI, `OP_XORI, `OP_LUI: operand_1 <= reg_data_1;
            `OP_JAL: operand_1                                                                                     <= addr;
            default: operand_1                                                                                     <= 0;
        endcase
    end
    
    // For Handling Operand_2
    wire[15:0] inst_2_imm        = inst_2[15: 0];
    wire[31:0] zero_extended_imm = {16'b0, inst_2_imm};
    always@(*)
    begin
        if (rst) operand_2 <= 0;
        else
        case(inst_2_op)
            `OP_ADDI, `OP_ADDIU, `OP_SLTI, `OP_SLTIU, `OP_ANDI, `OP_ORI, `OP_XORI: operand_2 <= zero_extended_imm;
            `OP_SPECIAL: operand_2                                                           <= reg_data_2;
            `OP_JAL: operand_2                                                               <= 32'h4;
            `OP_LUI: operand_2                                                               <= {inst_2_imm, 16'h0};  // High 16-bit
            default: operand_2                                                               <= 0;
        endcase
    end
    
    // For Write to Register
    always@(*)
    begin
        if (rst) begin write_reg_en <= 0; write_reg_addr <= 0; end
        else
        case(inst_2_op)
            `OP_SPECIAL:              // Write back to rd
            begin
                write_reg_en   <= 1;
                write_reg_addr <= inst_2[15:11];
            end
            `OP_ADDI, `OP_ADDIU, `OP_ANDI, `OP_SLTI, `OP_SLTIU, `OP_ORI, `OP_XORI, `OP_LW, `OP_LUI: // Write back to rt
            begin
                write_reg_en   <= 1;
                write_reg_addr <= inst_2[20:16];
            end
            `OP_JAL:
            begin
                write_reg_en   <= 1;  // Write back to $31
                write_reg_addr <= 32'b11111;
            end
            
            default:
            begin
                write_reg_en   <= 0;
                write_reg_addr <= 0;
            end
        endcase
    end
    
    // For Memory
    wire[31:0] signal_extended_imm = { {16{inst_2_imm[15]}}, inst_2_imm};
    always@(*)
    begin
        if (rst)
        begin
            mem_read_flag  <= 0;
            mem_write_flag <= 0;
            mem_addr       <= 0;
            mem_write_data <= 0;
        end
        else
            case(inst_2_op)
                `OP_LW:
                begin
                    mem_read_flag  <= 1;
                    mem_write_flag <= 0;
                    mem_addr       <= reg_data_1 + signal_extended_imm;
                    mem_write_data <= 0;
                end
                `OP_SW:
                begin
                    mem_write_flag <= 1;
                    mem_read_flag  <= 0;
                    mem_addr       <= reg_data_1 + signal_extended_imm;
                    mem_write_data <= reg_data_2;
                end
                default:
                begin
                    mem_read_flag  <= 0;
                    mem_write_flag <= 0;
                    mem_addr       <= 0;
                    mem_write_data <= 0;
                end
            endcase
    end
    
    // For beq/bne/bgtz/blez branch
    wire[`AddrBus] addr_plus_4        = addr + 32'h4;
    wire[25:0] jump_addr              = inst_2[25:0];
    wire[`DataBus] imm_sll2_signedext = {{14{inst_2[15]}}, inst_2[15:0], 2'b00};
    
    always@(*) begin
        if (rst) begin
            branch_flag <= 1'b0;
            branch_addr <= `AddrBusWidth'b0;
        end
        else
            case(inst_2_op)
                `OP_BEQ:
                begin
                    if (reg_data_1 == reg_data_2)
                    begin
                        branch_flag <= 1'b1;
                        branch_addr <= addr_plus_4 + imm_sll2_signedext;
                    end
                    else begin
                        branch_flag <= 1'b0;
                        branch_addr <= `AddrBusWidth'b0;
                    end
                end
                `OP_BNE:
                begin
                    if (reg_data_1 ! = reg_data_2)
                    begin
                        branch_flag <= 1'b1;
                        branch_addr <= addr_plus_4+imm_sll2_signedext;
                    end
                    else begin
                        branch_flag <= 1'b0;
                        branch_addr <= `AddrBusWidth'b0;
                    end
                end
                `OP_BLEZ:
                begin
                    if (reg_data_1 <= 0)
                    begin
                        branch_flag <= 1'b1;
                        branch_addr <= addr_plus_4+imm_sll2_signedext;
                    end
                    else begin
                        branch_flag <= 1'b0;
                        branch_addr <= `AddrBusWidth'b0;
                    end
                end
                `OP_BGTZ:
                begin
                    if (reg_data_1 <= 0)
                    begin
                        branch_flag <= 1'b1;
                        branch_addr <= addr_plus_4+imm_sll2_signedext;
                    end
                    else begin
                        branch_flag <= 1'b0;
                        branch_addr <= `AddrBusWidth'b0;
                    end
                end
                `OP_J:
                begin
                    branch_flag <= 1'b1;
                    branch_addr <= {4'b0000,inst_2[25:0],2'b00};
                end
                `OP_JAL:
                begin
                    branch_flag <= 1'b1;
                    branch_addr <= {4'b0000,inst_2[25:0],2'b00};
                end
                `OP_SPECIAL:
                begin
                    if (funct == `FUNCT_JR)
                    begin
                        branch_flag <= 1'b1;
                        branch_addr <= reg_data_1;
                    end
                    else
                    begin
                        branch_flag <= 0;
                        branch_addr <= 0;
                    end
                end
                default: begin
                    branch_flag <= 1'b0;
                    branch_addr <= `AddrBusWidth'b0;
                end
                
            endcase
    end
    
    
endmodule
