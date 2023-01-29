module Sobel_AvalonStreaming 
#(
    parameter 
    IMG_X_SIZE = 320,
    IMG_Y_SIZE = 240
)
(
    // clock and reset
    input wire csi_clkrst_clk,
    input wire csi_clkrst_reset_n,

    //sink
    input   wire    [7:0]   asi_sink1_data,
    input   wire            asi_sink1_startofpacket,
    input   wire            asi_sink1_endofpacket,
    input   wire            asi_sink1_valid,
    output  reg             asi_sink1_ready,

    // source
    input   wire            aso_source1_ready,
    output  wire    [7:0]   aso_source1_data,
    output  reg             aso_source1_startofpacket,
    output  reg             aso_source1_endofpacket,
    output  wire            aso_source1_valid
);

    localparam GetFirstPacket = 0, 
               GetPackets = 1, 
               CalcSobel = 2,
               SendPackets = 3;
    reg [1:0] ps_r, ns_r;

    reg startCore_r, dataAvailableCore_r, validCore_r;
    reg startCoreSatateMachine_r;

    reg [7:0] GrayImage_m [(IMG_X_SIZE*IMG_Y_SIZE)-1:0];
    reg [7:0] DataCore_r;

    // avalon streaming interface state machine ********************************************
    always @(posedge csi_clkrst_clk or negedge csi_clkrst_reset_n) begin
        if (~csi_clkrst_reset_n) ps_r <= GetFirstPacket;
        else ps_r <= ns_r;
    end

    always @(*) begin
        ns_r = GetFirstPacket;
        case (ps_r) 
            GetFirstPacket: ns_r = asi_sink1_startofpacket ? GetPackets : GetFirstPacket;
            GetPackets: ns_r = asi_sink1_endofpacket ? CalcSobel : GetPackets;
            CalcSobel: ns_r = dataAvailableCore_r ? SendPackets : CalcSobel;
            SendPackets: ns_r = validCore_r ? GetFirstPacket : SendPackets;
        endcase
    end

    always @(*) begin
        
        asi_sink1_ready = 0;
        startCore_r = 1;
        aso_source1_startofpacket = 0;
        aso_source1_endofpacket = 0;

        case (ps_r)
            GetFirstPacket: begin
                asi_sink1_ready = 1;
                aso_source1_endofpacket = 1;
                if (asi_sink1_startofpacket)
                    startCore_r = 0;
            end
            GetPackets: begin
                // no signal issues
            end
            CalcSobel: begin
                // no signal issues
            end
            SendPackets: begin
                aso_source1_startofpacket = 1;
            end
        endcase
    end

    // Sobel Filter Core ********************************************************************
    Sobel #(
        .KX_SIZE(3), 
        .KY_SIZE(3), 
        .IMG_X_SIZE(IMG_X_SIZE), 
        .IMG_Y_SIZE(IMG_Y_SIZE)
    ) Sobel_core (
        .clk_i(csi_clkrst_clk), 
        .rst_i(~csi_clkrst_reset_n),
        .GrayImage_i(asi_sink1_data),
        .start_i(startCore_r),
        .dataAvailable_o(dataAvailableCore_r),
        .valid_o(validCore_r),
        .ProcessedImagePixel_o(DataCore_r)
    );

    assign aso_source1_data = DataCore_r;

endmodule
