module Rgb2Gray_AvalonStreaming
(
    // clock and reset
    input wire csi_clock_reset_clk,
    input wire csi_clock_reset_reset_n,

    //sink
    input   wire    [23:0]  asi_sink1_data,
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

    wire [7:0] Red_r, Green_r, Blue_r;
    assign Red_r = asi_sink1_data[7:0];
    assign Green_r = asi_sink1_data[15:8];
    assign Blue_r = asi_sink1_data[23:16];
    assign aso_source1_data = (Red_r + Green_r + Blue_r) / 3;

    assign asi_sink1_ready = aso_source1_ready;
    assign aso_source1_startofpacket = asi_sink1_startofpacket;
    assign aso_source1_endofpacket = asi_sink1_endofpacket;
    assign aso_source1_valid = asi_sink1_valid;

endmodule
