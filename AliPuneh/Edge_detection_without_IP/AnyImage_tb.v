`timescale 1ns/1ns
module AnyImage_tb();
	
	localparam IMG_X_SIZE = 564;
	localparam IMG_Y_SIZE = 1221;
	localparam INPUT_PIXELS = IMG_X_SIZE * IMG_Y_SIZE;
	localparam OUTPUT_PIXELS = (IMG_X_SIZE - 2) * (IMG_Y_SIZE - 2);

    reg clk_r = 0, rst_r = 0, start_r = 0;
    reg [7:0] gray;
    wire valid_w, dataAvailable_w;
    wire [7:0] ProcessedImagePixel_w;

	reg [7:0] INPUT [0:INPUT_PIXELS-1];
	reg [7:0] OUTPUT [0:OUTPUT_PIXELS-1];

    EdgeDetector #(
        .KX_SIZE(3),
        .KY_SIZE(3),
        .IMG_X_SIZE(IMG_X_SIZE),
        .IMG_Y_SIZE(IMG_Y_SIZE)
    ) EdgeDetector_DUT (
        .clk_i(clk_r), 
        .rst_i(rst_r),
        .GrayImage_i(gray),
        .start_i(start_r),
        .dataAvailable_o(dataAvailable_w),
        .valid_o(valid_w),
        .ProcessedImagePixel_o(ProcessedImagePixel_w)
    );

    always #3 clk_r = ~clk_r;

	initial $readmemb("input.txt", INPUT);

	integer i;
    initial begin
        #11 rst_r = 1;
        #11 rst_r = 0;
        #11 start_r = 1;
        #11 start_r = 0;
		for (i = 0; i < INPUT_PIXELS; i = i + 1) begin
	        @(posedge clk_r);
	        gray = INPUT[i];
		end
		@(posedge dataAvailable_w);
		for (i = 0; i < OUTPUT_PIXELS; i = i + 1) begin
			@(posedge clk_r);
			OUTPUT[i] = ProcessedImagePixel_w;
		end
		$writememb("output.txt", OUTPUT);
        #100 $stop();
    end
endmodule