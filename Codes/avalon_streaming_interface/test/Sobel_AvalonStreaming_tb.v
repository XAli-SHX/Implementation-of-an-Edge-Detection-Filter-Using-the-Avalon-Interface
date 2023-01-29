module Sobel_AvalonStreaming_tb ();
    
    reg clk_r = 0, rst_nr = 1, startofpacketSink_r = 0, endofpacketSink_r = 0, validSink_r = 0, readySource_r = 0;
    wire startofpacketSource_w, endofpacketSource_w, validSource_w, readySink_w;
    reg [7:0] dataSink_r = 8'd0;
    wire [7:0] dataSource_w;

    Sobel_AvalonStreaming #(.IMG_X_SIZE(5), .IMG_Y_SIZE(5))
      Sobel_AvalonStreaming_DUT(
        // clock and reset
        .csi_clkrst_clk(clk_r),
        .csi_clkrst_reset_n(rst_nr),

        //sink
        .asi_sink1_data(dataSink_r),
        .asi_sink1_startofpacket(startofpacketSink_r),
        .asi_sink1_endofpacket(endofpacketSink_r),
        .asi_sink1_valid(validSink_r),
        .asi_sink1_ready(readySink_w),

        // source
        .aso_source1_ready(readySource_r),
        .aso_source1_data(dataSource_w),
        .aso_source1_startofpacket(startofpacketSource_w),
        .aso_source1_endofpacket(endofpacketSource_w),
        .aso_source1_valid(validSource_w)
    );

    always #3 clk_r = ~clk_r;
    initial begin
        #10 
        rst_nr = 0;
        #10
        rst_nr = 1;
        #10 
        readySource_r = 1;
        startofpacketSink_r = 1;
        validSink_r = 1;
        dataSink_r = 8'd1;

        @(posedge clk_r);
        startofpacketSink_r =  0;
        dataSink_r = 8'd2;
        @(posedge clk_r);
        dataSink_r = 8'd3;
        @(posedge clk_r);
        dataSink_r = 8'd4;
        @(posedge clk_r);
        dataSink_r = 8'd5;
        @(posedge clk_r);
        dataSink_r = 8'd6;
        @(posedge clk_r);
        dataSink_r = 8'd7;
        @(posedge clk_r);
        dataSink_r = 8'd8;
        @(posedge clk_r);
        dataSink_r = 8'd9;
        @(posedge clk_r);
        dataSink_r = 8'd10;
        @(posedge clk_r);
        dataSink_r = 8'd11;
        @(posedge clk_r);
        dataSink_r = 8'd12;
        @(posedge clk_r);
        dataSink_r = 8'd13;
        @(posedge clk_r);
        dataSink_r = 8'd14;
        @(posedge clk_r);
        dataSink_r = 8'd15;
        @(posedge clk_r);
        dataSink_r = 8'd16;
        @(posedge clk_r);
        dataSink_r = 8'd17;
        @(posedge clk_r);
        dataSink_r = 8'd18;
        @(posedge clk_r);
        dataSink_r = 8'd19;
        @(posedge clk_r);
        dataSink_r = 8'd20;
        @(posedge clk_r);
        dataSink_r = 8'd21;
        @(posedge clk_r);
        dataSink_r = 8'd22;
        @(posedge clk_r);
        dataSink_r = 8'd23;
        @(posedge clk_r);
        dataSink_r = 8'd24;
        @(posedge clk_r);

        dataSink_r = 8'd25;
        endofpacketSink_r = 1;
        @(posedge clk_r);
        validSink_r = 0;
        endofpacketSink_r = 0;

        @(negedge endofpacketSource_w);
        #100 $stop();
    end

endmodule
