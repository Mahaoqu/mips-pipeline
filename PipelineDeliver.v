module PiplineDeliver #(parameter width = 1)
                       (input clk,
                        input rst,
                        input pause_current_stage,
                        input pause_next_stage,
                        input[width-1: 0] value,
                        output reg[width-1: 0] out);
                        
    always@(posedge clk)
    begin
        if (rst)
            out <= 0;
        else if (pause_current_stage && !pause_next_stage)
            out <= 0;
        else if (!pause_current_stage)
            out <= value;
    end
endmodule
