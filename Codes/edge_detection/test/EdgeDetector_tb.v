module EdgeDetector_tb ();
    
    reg clk_r, rst_r, start_r;
    reg [7:0] GrayImage_r;
    wire valid_w, dataAvailable_w;
    wire [7:0] ProcessedImagePixel_w;

    EdgeDetector #(
        .KX_SIZE(3),
        .KY_SIZE(3),
        .IMG_X_SIZE(3),
        .IMG_Y_SIZE(3)
    ) EdgeDetector_DUT (
        .clk_i(clk_r), 
        .rst_i(rst_r),
        .GrayImage_i(GrayImage_r),
        .start_i(start_r),
        .dataAvailable_o(dataAvailable_w),
        .valid_o(valid_w),
        .ProcessedImagePixel_o(ProcessedImagePixel_w)
    );

    always #3 clk_r = ~clk_r;

    initial begin
        #10 rst_r = 1;
        #10 rst_r = 0;
        #10 start_r = 1;
        #10 start_r = 0;
        @(posedge clk_r);
        GrayImage_r = 8'd10;
        @(posedge clk_r);
        GrayImage_r = 8'd20;
        @(posedge clk_r);
        GrayImage_r = 8'd30;
        @(posedge clk_r);
        GrayImage_r = 8'd40;
        @(posedge clk_r);
        GrayImage_r = 8'd50;
        @(posedge clk_r);
        GrayImage_r = 8'd60;
        @(posedge clk_r);
        GrayImage_r = 8'd70;
        @(posedge clk_r);
        GrayImage_r = 8'd80;
        @(posedge clk_r);
        GrayImage_r = 8'd90;
        @(posedge dataAvailable_w);
        @(posedge valid_w);
        #100 $stop();
    end

endmodule
