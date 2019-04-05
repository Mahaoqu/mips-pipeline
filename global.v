//32
`define AddrBus 31:0
`define AddrBusWidth 32
//32
`define InstBus 31:0
`define InstBusWidth 32
//32
`define DataBus 31:0
`define DataBusWidth 32
//64
`define DoubleDataBus 63:0
`define DoubleDataBusWidth 64
//6
`define OpBus 5:0
`define OpBusWidth 6
//6
`define FunctBus 5:0
`define FunctBusWidth 6
//5
`define ShamtBus 4:0
`define ShamtBusWidth 5
//5
`define RegAddrBus 4:0
`define RegAddrBusWidth 5

// OPRATION
// R-type
`define OP_SPECIAL      6'b000000 
// I-type
`define OP_REGIMM       6'b000001
`define OP_BEQ          6'b000100 
`define OP_BNE          6'b000101 
`define OP_BLEZ         6'b000110 
`define OP_BGTZ         6'b000111

`define OP_ADDI         6'b001000
`define OP_ADDIU        6'b001001
`define OP_SLTI         6'b001010
`define OP_SLTIU        6'b001011
`define OP_ANDI         6'b001100
`define OP_ORI          6'b001101
`define OP_XORI         6'b001110
`define OP_LUI          6'b001111


`define OP_LW           6'b100011
`define OP_SW           6'b101011

// J-type
`define OP_J            6'b000010 
`define OP_JAL          6'b000011
 
// Func(For R-type, OP_SPECIAL)
`define FUNCT_ADD       6'b100000
`define FUNCT_ADDU      6'b100001
`define FUNCT_SUB       6'b100010
`define FUNCT_SUBU      6'b100011
`define FUNCT_AND       6'b100100
`define FUNCT_OR        6'b100101
`define FUNCT_XOR       6'b100110
`define FUNCT_NOR       6'b100111
`define FUNCT_SLT       6'b101010
`define FUNCT_SLTU      6'b101000

`define FUNCT_SLL       6'b000000
`define FUNCT_SRL       6'b000010
`define FUNCT_SRA       6'b000011
`define FUNCT_SLLV      6'b000100
`define FUNCT_SRLV      6'b000110
`define FUNCT_SRAV      6'b000111
`define FUNCT_JR        6'b001000

`define FUNCT_MULT      6'b011000
`define FUNCT_MULTU     6'b011001
`define FUNCT_DIV       6'b011010
`define FUNCT_DIVU      6'b011011
 
`define FUNCT_MFHI      6'b001010
`define FUNCT_MTHI      6'b001011
`define FUNCT_MFLO      6'b001100
`define FUNCT_MTLO      6'b001101

`define FUNCT_NOP       6'b111111
 