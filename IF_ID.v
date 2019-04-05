`include "global.v"
module IF_ID(
    input clk,
    input rst,
    input[`AddrBus] addr_i,
    input[`InstBus] inst_i,
    input stall_if,
    input stall_id,
    output [`AddrBus] addr_o,
    output [`InstBus] inst_o
);
    PiplineDeliver#(`AddrBusWidth) ff_addr(clk, rst, stall_if, stall_id, addr_i, addr_o);
    PiplineDeliver#(`InstBusWidth) ff_inst(clk, rst, stall_if, stall_id, inst_i, inst_o);
endmodule