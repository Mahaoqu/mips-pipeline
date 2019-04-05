`timescale 1ns / 1ps
`include "global.v"

module ROM(
    input en,
    input[`AddrBus] addr,
    output[`InstBus] inst2
);
    reg[7:0] rom[0:511];

    initial $readmemh("D:/cp-design/inst_rom.bin", rom);
    //TODO!
    assign inst2[ 7: 0] = (en ? rom[addr + 3] : 8'b0);
    assign inst2[15: 8] = (en ? rom[addr + 2] : 8'b0);
    assign inst2[23:16] = (en ? rom[addr + 1] : 8'b0);
    assign inst2[31:24] = (en ? rom[addr + 0] : 8'b0);
endmodule