module Rgb2Gray_tb ();
    
    reg clk_r = 0, rst_r = 0, start_r = 0;
    reg [7:0] RgbColor_r = 10'd0;
    wire valid_w;
    wire [7:0] GrayColor_w;

    Rgb2Gray Rgb2Gray_DUT (
        .clk_i(clk_r), 
        .rst_i(rst_r),
        .start_i(start_r),
        .RgbColor_i(RgbColor_r),
        .valid_o(valid_w),
        .GrayColor_o(GrayColor_w)
    );

    // clk gen
    always #3 clk_r = ~clk_r;

    initial begin
        #10 rst_r = 1;
        #10 rst_r = 0;
        @(posedge clk_r)
        start_r = 1;
        @(posedge clk_r)
        start_r = 0;
        @(posedge clk_r)
        RgbColor_r = 10'd238; // EE
        @(posedge clk_r)
        RgbColor_r = 10'd238; // EE
        @(posedge clk_r)
        RgbColor_r = 10'd238; // EE
        #100 $stop();
    end

endmodule
