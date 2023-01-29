module Sobel #(
    parameter KX_SIZE = 3,
              KY_SIZE = 3,
              IMG_X_SIZE = 100,
              IMG_Y_SIZE = 100
) (
    clk_i, 
    rst_i,
    GrayImage_i,
    start_i,
    dataAvailable_o,
    valid_o,
    ProcessedImagePixel_o
);

    input clk_i, rst_i, start_i;
    input [7:0] GrayImage_i;
    output valid_o, dataAvailable_o;
    output [7:0] ProcessedImagePixel_o;

    wire cntrInputClear_w, cntrKernelClear_w, cntrMemGclear_w, memGclear_w,
        memImgWr_w, cntrInputInc_w, saveImgOrCalculate_w, cntrKernelInc_w, 
        memGwr_w, cntrMemGinc_w, dataAvailable_w, inputRecieved_o, 
        kernelResReady_o, imageProcessed_o, outputSent_o;

    Sobel_Datapath #(
        .KX_SIZE(KX_SIZE),
        .KY_SIZE(KY_SIZE),
        .IMG_X_SIZE(IMG_X_SIZE),
        .IMG_Y_SIZE(IMG_Y_SIZE)
    ) Sobel_DP (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .GrayImg_i(GrayImage_i),
        .cntrInputClear_i(cntrInputClear_w),
        .cntrKernelClear_i(cntrKernelClear_w),
        .cntrMemGclear_i(cntrMemGclear_w),
        .memGclear_i(memGclear_w),
        .memImgWr_i(memImgWr_w),
        .cntrInputInc_i(cntrInputInc_w),
        .saveImgOrCalculate_i(saveImgOrCalculate_w),
        .cntrKernelInc_i(cntrKernelInc_w),
        .memGwr_i(memGwr_w),
        .cntrMemGinc_i(cntrMemGinc_w),
        .dataAvailable_i(dataAvailable_w),
        .inputRecieved_o(inputRecieved_w),
        .kernelResReady_o(kernelResReady_w),
        .imageProcessed_o(imageProcessed_w),
        .outputSent_o(outputSent_w),
        .ProcessedImagePixel_o(ProcessedImagePixel_o)
    );

    Sobel_Controller Sobel_CU (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .start_i(start_i),
        .inputRecieved_i(inputRecieved_w),
        .kernelResReady_i(kernelResReady_w),
        .imageProcessed_i(imageProcessed_w),
        .outputSent_i(outputSent_w),
        .cntrInputClear_o(cntrInputClear_w),
        .cntrKernelClear_o(cntrKernelClear_w),
        .cntrMemGclear_o(cntrMemGclear_w),
        .memGclear_o(memGclear_w),
        .memImgWr_o(memImgWr_w),
        .cntrInputInc_o(cntrInputInc_w),
        .saveImgOrCalculate_o(saveImgOrCalculate_w),
        .cntrKernelInc_o(cntrKernelInc_w),
        .memGwr_o(memGwr_w),
        .cntrMemGinc_o(cntrMemGinc_w),
        .dataAvailable_o(dataAvailable_w),
        .valid_o(valid_o)
    );

    assign dataAvailable_o = dataAvailable_w;

endmodule
