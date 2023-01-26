module Mac #(
    parameter MULT_SIZE = 8,
              ACCUM_SIZE = 8
)(
    Mult1_i,
    Mult2_i,
    Accum_i,
    Result_o
);

    localparam RESULT_SIZE = (MULT_SIZE+MULT_SIZE) > ACCUM_SIZE ? 
                             (MULT_SIZE+MULT_SIZE+1) : (ACCUM_SIZE+1);

    input [MULT_SIZE-1:0] Mult1_i, Mult2_i;
    input [ACCUM_SIZE-1:0] Accum_i;
    output [RESULT_SIZE-1:0] Result_o;

    wire [MULT_SIZE+MULT_SIZE:0] Product;
    wire [RESULT_SIZE-1:0] Sum;

    assign Product = Mult1_i * Mult2_i;
    assign Sum = Product + Accum_i;
    assign Result_o = Sum;
    
endmodule