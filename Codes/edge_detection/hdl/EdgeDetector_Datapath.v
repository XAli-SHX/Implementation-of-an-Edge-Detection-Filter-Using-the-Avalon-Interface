module EdgeDetector_Datapath #(
    parameter KX_SIZE = 3,
              KY_SIZE = 3,
              IMG_X_SIZE = 100,
              IMG_Y_SIZE = 100
)(
    clk_i,
    rst_i,
    GrayImg_i,
    cntrInputClear_i,
    cntrKernelClear_i,
    cntrMemGclear_i,
    memGclear_i,
    memImgWr_i,
    cntrInputInc_i,
    saveImgOrCalculate_i,
    cntrKernelInc_i,
    memGwr_i,
    cntrMemGinc_i,
    dataAvailable_i,
    inputRecieved_o,
    kernelResReady_o,
    imageProcessed_o,
    outputSent_o,
    ProcessedImagePixel_o
);

    localparam KX_BITS = KX_SIZE;
    localparam KY_BITS = KY_SIZE;
    localparam IMG_X_BITS = $clog2(IMG_X_SIZE);
    localparam IMG_Y_BITS = $clog2(IMG_Y_SIZE);
    localparam IMG_ADR_BITS = $clog2(IMG_X_SIZE * IMG_Y_SIZE);
    localparam G_ADR_BITS = $clog2((IMG_X_SIZE-2) * (IMG_Y_SIZE-2));

    input clk_i, rst_i;
    input cntrInputClear_i, cntrKernelClear_i, cntrMemGclear_i, memGclear_i, 
          memImgWr_i, cntrInputInc_i, saveImgOrCalculate_i, cntrKernelInc_i, 
          memGwr_i, cntrMemGinc_i, dataAvailable_i;
    input [7:0] GrayImg_i;
    output inputRecieved_o, kernelResReady_o, imageProcessed_o, outputSent_o;
    output [7:0] ProcessedImagePixel_o;

    wire [$clog2(KX_BITS)-1:0] KxIndex_w;
    wire [$clog2(KY_BITS)-1:0] KyIndex_w;
    wire [IMG_X_BITS-1:0] ImgxIndex_w;
    wire [IMG_Y_BITS-1:0] ImgyIndex_w;
    
    wire [IMG_X_BITS-1:0] GxIndex_w;
    wire [IMG_Y_BITS-1:0] GyIndex_w;


    wire [IMG_X_BITS-1:0] KxImgxIndex_w;
    wire [IMG_Y_BITS-1:0] KyImgyIndex_w;
    wire [IMG_X_BITS-1:0] MemImgxAdr_w;
    wire [IMG_Y_BITS-1:0] MemImgyAdr_w;
    wire [IMG_ADR_BITS-1:0] MemImgAdr_w;
    wire [G_ADR_BITS-1:0] MemGxyAdr_w;
    wire signed [7:0] ImgPixel_w;
    wire signed [2:0] Kx_w, Ky_w;
    wire signed [11:0] DataWrMemGx_w, DataWrMemGy_w;
    wire [11:0] GxPixel_w; // TODO: parameterize
    wire [11:0] GyPixel_w; // TODO: parameterize
    wire [11:0] GxPixelAbs_w, GyPixelAbs_w;
    

    CounterDualPort #(.X_END(KX_SIZE-1), .Y_END(KY_SIZE-1))
      CntrKernel (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .inc_i(cntrKernelInc_i),
        .clear_i(cntrKernelClear_i),
        .X_o(KxIndex_w),
        .Y_o(KyIndex_w),
        .finished_o(kernelResReady_o)
    );
    
    CounterDualPort #(.X_END(IMG_X_SIZE-1), .Y_END(IMG_Y_SIZE-1))
      CntrInput (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .inc_i(cntrInputInc_i),
        .clear_i(cntrInputClear_i),
        .X_o(ImgxIndex_w),
        .Y_o(ImgyIndex_w),
        .finished_o(inputRecieved_o)
    );
    
    CounterDualPort #(.X_END(IMG_X_SIZE-3), .Y_END(IMG_Y_SIZE-3))
      CntrMemG (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .inc_i(cntrMemGinc_i),
        .clear_i(cntrMemGclear_i),
        .X_o(GxIndex_w),
        .Y_o(GyIndex_w),
        .finished_o(imageProcessed_o)
    );
    assign outputSent_o = imageProcessed_o;

    // KernelxIndex + MemGxIndex
    assign KxImgxIndex_w = KxIndex_w + GxIndex_w;

    // KernelyIndex + MemGyIndex
    assign KyImgyIndex_w = KyIndex_w + GyIndex_w;

    Mux2 #(.WIDTH(IMG_X_BITS))
      MuxSaveImgxOrCalculateX (
        .Data0_i(ImgxIndex_w), 
        .Data1_i(KxImgxIndex_w),
        .select_i(saveImgOrCalculate_i),
        .DataOut_o(MemImgxAdr_w)
    );
    
    Mux2 #(.WIDTH(IMG_Y_BITS))
      MuxSaveImgyOrCalculateY (
        .Data0_i(ImgyIndex_w), 
        .Data1_i(KyImgyIndex_w),
        .select_i(saveImgOrCalculate_i),
        .DataOut_o(MemImgyAdr_w)
    );

    EdgeDetector_MemImgAdrGen #(.X_SIZE(IMG_X_SIZE), .Y_SIZE(IMG_Y_SIZE))
      MemImgAdrGen (
        .X_i(MemImgxAdr_w), 
        .Y_i(MemImgyAdr_w),
        .MemImgAdr_o(MemImgAdr_w)
    );

    Memory #(.WORD(8), .SIZE(IMG_X_SIZE * IMG_Y_SIZE))
      MemImg (
        .clk_i(clk_i),
        .wr_i(memImgWr_i),
        .clear_i(1'b0),
        .Adr_i(MemImgAdr_w),
        .DataWr_i(GrayImg_i),
        .DataRd_o(ImgPixel_w)
    );

    EdgeDetector_Kernel KernelXY (
        .Xindex_i(KxIndex_w), 
        .Yindex_i(KyIndex_w),
        .Kx_o(Kx_w),
        .Ky_o(Ky_w)
    );

    EdgeDetector_MemImgAdrGen #(.X_SIZE(IMG_X_SIZE-2), .Y_SIZE(IMG_Y_SIZE-2))
      MemGxyAdrGen (
        .X_i(GxIndex_w), 
        .Y_i(GyIndex_w),
        .MemImgAdr_o(MemGxyAdr_w)
    );

    Mac #(.MULT_SIZE(8), .ACCUM_SIZE(12))
      MacGx(  
        .Mult1_i(ImgPixel_w),
        .Mult2_i({{5{ Kx_w[2] }}, Kx_w}),
        .Accum_i(GxPixel_w),
        .Result_o(DataWrMemGx_w)
    );
    
    Mac #(.MULT_SIZE(8), .ACCUM_SIZE(12))
      MacGy(  
        .Mult1_i(ImgPixel_w),
        .Mult2_i({{5{ Ky_w[2] }}, Ky_w}),
        .Accum_i(GyPixel_w),
        .Result_o(DataWrMemGy_w)
    );

    Memory #(.WORD(12), .SIZE((IMG_X_SIZE-2) * (IMG_Y_SIZE-2)))
      MemGx (
        .clk_i(clk_i),
        .wr_i(memGwr_i),
        .clear_i(memGclear_i),
        .Adr_i(MemGxyAdr_w),
        .DataWr_i(DataWrMemGx_w),
        .DataRd_o(GxPixel_w)
    );
    
    Memory #(.WORD(12), .SIZE((IMG_X_SIZE-2) * (IMG_Y_SIZE-2)))
      MemGy (
        .clk_i(clk_i),
        .wr_i(memGwr_i),
        .clear_i(memGclear_i),
        .Adr_i(MemGxyAdr_w),
        .DataWr_i(DataWrMemGy_w),
        .DataRd_o(GyPixel_w)
    );

    Abs #(.WIDTH(12))
      AbsMemGx (
        .DataIn_i(GxPixel_w), 
        .DataOut_o(GxPixelAbs_w)
    );
    
    Abs #(.WIDTH(12))
      AbsMemGy (
        .DataIn_i(GyPixel_w), 
        .DataOut_o(GyPixelAbs_w)
    );

    // G = (Gx + Gy) / 2
    assign ProcessedImagePixel_o = (GxPixelAbs_w + GyPixelAbs_w) >> 1;
    
endmodule