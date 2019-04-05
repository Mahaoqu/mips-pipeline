module Control(input rst,             //重置信号
               input request_from_id, //从 ID 模块发出的暂停请求
               input request_from_ex, //从 EX 模块发出的暂停请求
               output pause_pc,       //暂停 PC 的信号
               output pause_if,       //暂停 IF 的信号
               output pause_id,       //暂停 ID 的信号
               output pause_ex,       //暂停 EX 的信号
               output pause_mem,      //暂停 MEM 的信号
               output pause_wb);      //暂停 WB 的信号
    
    assign pause_pc = rst ? 0 :
    request_from_id ? 1 :
    request_from_ex ? 1 :
    0;
    
    assign pause_if = rst ? 0 :
    request_from_id ? 1 :
    request_from_ex ? 1 :
    0;
    
    assign pause_id = rst ? 0 :
    request_from_id ? 1 :
    request_from_ex ? 1 :
    0;
    
    assign pause_ex = rst ? 0 :
    request_from_ex ? 1 :
    0;
    
    assign pause_mem = 0;
    assign pause_wb  = 0;
    
endmodule // Control
