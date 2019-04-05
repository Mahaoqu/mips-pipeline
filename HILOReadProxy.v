`include "global.v"

module HILOReadProxy(
    input[`DataBus] lo_in,
    input[`DataBus] hi_in,

    input wb_hilo_write_en,
    input[`DataBus] wb_lo_in,
    input[`DataBus] wb_hi_in,

    input mem_hilo_write_en,
    input[`DataBus] mem_lo_in,
    input[`DataBus] mem_hi_in,

    output reg[`DataBus] lo_out,
    output reg[`DataBus] hi_out
);

//TODO

always@*
begin
    if(mem_hilo_write_en)
        lo_out = mem_lo_in;
    else if(wb_hilo_write_en)
        lo_out = wb_lo_in;
    else 
        lo_out = lo_in;
end

always@*
begin
    if(mem_hilo_write_en)
        hi_out = mem_hi_in;
    else if(wb_hilo_write_en)
        hi_out = wb_hi_in;
    else 
        hi_out = hi_in;
end

endmodule // 