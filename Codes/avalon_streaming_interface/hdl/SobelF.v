module SobelF #(
    parameter 
    IMG_X_SIZE = 100,
    IMG_Y_SIZE = 100
) (
    // clock and reset
    input wire csi_clkrst_clk,
    input wire csi_clkrst_reset_n,

    //sink
    input   wire    [7:0]  asi_sink1_data,
    input   wire            asi_sink1_startofpacket,
    input   wire            asi_sink1_endofpacket,
    input   wire            asi_sink1_valid,
    output  wire            asi_sink1_ready,

    // source
    input   wire            aso_source1_ready,
    output  wire    [7:0]   aso_source1_data,
    output  wire            aso_source1_startofpacket,
    output  wire            aso_source1_endofpacket,
    output  wire            aso_source1_valid
);
    assign aso_source1_data = asi_sink1_data;

    assign asi_sink1_ready = aso_source1_ready;
    assign aso_source1_startofpacket = asi_sink1_startofpacket;
    assign aso_source1_endofpacket = asi_sink1_endofpacket;
    assign aso_source1_valid = asi_sink1_valid;

endmodule
