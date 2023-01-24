module Rgb2Gray_Datapath (
    clk_i, 
    rst_i,
    ld_i,
    clear_i,
    RgbColor_i,
    GrayColor_o
);

    localparam COLOR_SIZE = 8;
    input clk_i, rst_i, ld_i, clear_i;
    input [(COLOR_SIZE+2)-1:0] RgbColor_i;
    output [COLOR_SIZE-1:0] GrayColor_o;

    wire [(COLOR_SIZE+2)-1:0] SumResult_w;

    // Adder
    assign SumResult_w = RgbColor_i + GrayColor_o;

    Register reg_result (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .ld_i(ld_i),
        .clear_i(clear_i),
        .DataIn_i(SumResult_w),
        .DataOut_o(GrayColor_o)
    );
    
endmodule