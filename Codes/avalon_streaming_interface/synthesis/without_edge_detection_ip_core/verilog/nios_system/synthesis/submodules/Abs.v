module Abs #(parameter WIDTH = 8) (
    DataIn_i, 
    DataOut_o
);

    input [WIDTH-1:0] DataIn_i;
    output [WIDTH-1:0] DataOut_o;

    assign DataOut_o = DataIn_i[WIDTH-1] ? -DataIn_i : DataIn_i;
    
endmodule