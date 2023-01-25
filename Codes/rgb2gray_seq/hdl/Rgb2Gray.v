module Rgb2Gray (
    clk_i, 
    rst_i,
    start_i,
    RgbColor_i,
    valid_o,
    GrayColor_o
);

    input clk_i, rst_i, start_i;
    input [7:0] RgbColor_i;
    output valid_o;
    output [7:0] GrayColor_o;

    wire ld_w, clear_w;

    Rgb2Gray_Datapath Rgb2Gray_DP (
        .clk_i(clk_i), 
        .rst_i(rst_i),
        .ld_i(ld_w),
        .clear_i(clear_w),
        .RgbColor_i({2'b0, RgbColor_i}),
        .GrayColor_o(GrayColor_o)
    );

    Rgb2Gray_Controller Rgb2Gray_CU (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .start_i(start_i),
        .clear_o(clear_w),
        .ld_o(ld_w),
        .valid_o(valid_o)
    );
    
endmodule
