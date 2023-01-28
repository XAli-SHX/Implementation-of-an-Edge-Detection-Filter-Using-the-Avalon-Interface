module Mux2 #(
    parameter WIDTH = 8
)(
    Data0_i, 
    Data1_i,
    select_i,
    DataOut_o
);

    input [WIDTH-1:0] Data0_i, Data1_i;
    input select_i;
    output [WIDTH-1:0] DataOut_o;

    assign DataOut_o = select_i ? Data1_i : Data0_i;
    
endmodule
