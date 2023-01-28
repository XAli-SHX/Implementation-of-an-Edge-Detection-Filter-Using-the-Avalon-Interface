module Rgb2Gray (
    RedColor_i,
    GreenColor_i,
    BlueColor_i,
    GrayColor_o
);

    input [7:0] RedColor_i, GreenColor_i, BlueColor_i;
    output [7:0] GrayColor_o;

    wire [9:0] SumResult_w;
    assign SumResult_w = RedColor_i + GreenColor_i + BlueColor_i;

    // Divide by 3
    assign GrayColor_o = (SumResult_w >> 2) + 
                         (SumResult_w >> 4) + 
                         (SumResult_w >> 6) +
                         (SumResult_w >> 7) ;
    
endmodule
