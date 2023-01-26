module CounterDualPort_tb();
    
    reg clk_r = 0, rst_r = 0, inc_r = 0, clear_r = 0;
    wire [1:0] X_w, Y_w;
    wire finished_w;

    CounterDualPort #(.X_END(3), .Y_END(3)) 
    CounterDualPort_DUT (
        .clk_i(clk_r),
        .rst_i(rst_r),
        .inc_i(inc_r),
        .clear_i(clear_r),
        .X_o(X_w),
        .Y_o(Y_w),
        .finished_o(finished_w)
    );

    always #3 clk_r = ~clk_r;

    initial begin
        #10 rst_r = 1;
        #10 rst_r = 0;
        #20 inc_r = 1;
        #10 clear_r = 1;
        #10 clear_r = 0;
        #100 $stop();
    end

endmodule
