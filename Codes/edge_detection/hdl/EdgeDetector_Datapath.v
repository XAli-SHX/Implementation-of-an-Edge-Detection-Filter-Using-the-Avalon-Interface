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
    output [8:0] ProcessedImagePixel_o;

    reg [KX_BITS-1:0] KxIndex_r;
    reg [KY_BITS-1:0] KyIndex_r;
    reg [IMG_X_BITS-1:0] ImgxIndex_r;
    reg [IMG_Y_BITS-1:0] ImgyIndex_r;

    wire [KX_BITS+IMG_X_BITS:0] KxImgxIndex_w;
    wire [KY_BITS+IMG_Y_BITS:0] KyImgyIndex_w;
    wire [KX_BITS+IMG_X_BITS:0] MemImgxAdr_w;
    wire [KY_BITS+IMG_Y_BITS:0] MemImgyAdr_w;
    wire [IMG_ADR_BITS-1:0] MemImgAdr_w;
    wire [G_ADR_BITS-1:0] MemGxyAdr_w;
    wire [IMG_ADR_BITS-1:0] ImgPixel_w;
    wire [2:0] Kx_w, Ky_w;
    wire [14:0] DataWrMemGx_w, DataWrMemGy_w;
    wire [14:0] GxPixel_w; // TODO: parameterize
    wire [14:0] GyPixel_w; // TODO: parameterize
    wire [7:0] GxPixelAbs_w, GyPixelAbs_w;
    

    CounterDualPort #(.X_END(KX_SIZE), .Y_END(KY_SIZE))
      CntrKernel (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .inc_i(cntrKernelInc_i),
        .clear_i(cntrKernelClear_i),
        .X_o(KxIndex_r),
        .Y_o(KyIndex_r),
        .finished_o(kernelResReady_o)
    );
    
    CounterDualPort #(.X_END(IMG_X_SIZE), .Y_END(IMG_Y_SIZE))
      CntrInput (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .inc_i(cntrInputInc_i),
        .clear_i(cntrInputClear_i),
        .X_o(ImgxIndex_r),
        .Y_o(ImgyIndex_r),
        .finished_o(inputRecieved_o)
    );
    
    CounterDualPort #(.X_END(IMG_X_SIZE-2), .Y_END(IMG_Y_SIZE-2))
      CntrMemG (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .inc_i(cntrMemGinc_i),
        .clear_i(cntrMemGclear_i),
        .X_o(ImgxIndex_r),
        .Y_o(ImgyIndex_r),
        .finished_o(imageProcessed_o)
    );
    assign outputSent_o = imageProcessed_o;

    // KernelxIndex + MemGxIndex
    assign KxImgxIndex_w = KxIndex_r + ImgxIndex_r;

    // KernelyIndex + MemGyIndex
    assign KyImgyIndex_w = KyIndex_r + ImgyIndex_r;

    Mux2 #(.WIDTH(KX_BITS+IMG_X_BITS))
      MuxSaveImgxOrCalculateX (
        .Data0_i(ImgxIndex_r), 
        .Data1_i(KxImgxIndex_w),
        .select_i(saveImgOrCalculate_i),
        .DataOut_o(MemImgxAdr_w)
    );
    
    Mux2 #(.WIDTH(KY_BITS+IMG_Y_BITS))
      MuxSaveImgyOrCalculateY (
        .Data0_i(ImgyIndex_r), 
        .Data1_i(KyImgyIndex_w),
        .select_i(saveImgOrCalculate_i),
        .DataOut_o(MemImgyAdr_w)
    );

    EdgeDetector_MemImgAdrGen #(.X_SIZE(IMG_X_BITS), .Y_SIZE(IMG_Y_BITS))
      MemImgAdrGen (
        .X_i(MemImgxAdr_w), 
        .Y_i(MemImgyAdr_w),
        .MemImgAdr_o(MemImgAdr_w)
    );

    Memory #(.WORD(8), .SIZE(IMG_X_SIZE * IMG_Y_SIZE))
      MemImg (
        .clk_i(clk_i),
        .wr_i(memImgWr_i),
        .Adr_i(MemImgAdr_w),
        .DataWr_i(GrayImg_i),
        .DataRd_o(ImgPixel_w)
    );

    EdgeDetector_Kernel KernelXY (
        .Xindex_i(KxIndex_r), 
        .Yindex_i(KyIndex_r),
        .Kx_o(Kx_w),
        .Ky_o(Ky_w)
    );

    EdgeDetector_MemImgAdrGen #(.X_SIZE(IMG_X_SIZE), .Y_SIZE(IMG_Y_SIZE))
      MemGxyAdrGen (
        .X_i(ImgxIndex_r), 
        .Y_i(ImgyIndex_r),
        .MemImgAdr_o(MemGxyAdr_w)
    );

    Mac #(.MULT_SIZE(8), .ACCUM_SIZE(15))
      MacGx(  
        .Mult1_i(ImgPixel_w),
        .Mult2_i(Kx_w),
        .Accum_i(GxPixel_w),
        .Result_o(DataWrMemGx_w)
    );
    
    Mac #(.MULT_SIZE(8), .ACCUM_SIZE(15))
      MacGy(  
        .Mult1_i(ImgPixel_w),
        .Mult2_i(Ky_w),
        .Accum_i(GyPixel_w),
        .Result_o(DataWrMemGy_w)
    );

    Memory #(.WORD(8), .SIZE((IMG_X_SIZE-2) * (IMG_Y_SIZE-2)))
      MemGx (
        .clk_i(clk_i),
        .wr_i(memGwr_i),
        .Adr_i(MemImgAdr_w),
        .DataWr_i(DataWrMemGx_w),
        .DataRd_o(GxPixel_w)
    );
    
    Memory #(.WORD(8), .SIZE((IMG_X_SIZE-2) * (IMG_Y_SIZE-2)))
      MemGy (
        .clk_i(clk_i),
        .wr_i(memGwr_i),
        .Adr_i(MemImgAdr_w),
        .DataWr_i(DataWrMemGy_w),
        .DataRd_o(GyPixel_w)
    );

    Abs #(.WIDTH(8))
      AbsMemGx (
        .DataIn_i(GxPixel_w), 
        .DataOut_o(GxPixelAbs_w)
    );
    
    Abs #(.WIDTH(8))
      AbsMemGy (
        .DataIn_i(GyPixel_w), 
        .DataOut_o(GyPixelAbs_w)
    );

    // G = (Gx + Gy) / 2
    assign ProcessedImagePixel_o = (GxPixelAbs_w + GyPixelAbs_w) >> 1;
    
endmodule