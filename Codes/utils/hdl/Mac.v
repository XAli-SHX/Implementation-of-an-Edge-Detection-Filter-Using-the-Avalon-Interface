module Mac (
    Mult1_i,
    Mult2_i,
    Accum_i,
    Result_o
);

    input [7:0] Mult1_i, Mult2_i, Accum_i;
    output [7:0] Result_o;

    wire [7:0] Product;
    wire [7:0] Sum;

    assign Product = Mult1_i * Mult2_i;
    assign Sum = Product + Accum_i;
    assign Result_o = Sum;
    
endmodule