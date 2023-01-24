module Rgb2Gray_Controller (
    clk_i,
    rst_i,
    start_i,
    clear_o,
    ld_o,
    valid_o
);

    input clk_i, rst_i, start_i;
    output reg clear_o, ld_o, valid_o;

    reg [2:0] ns_r, ps_r;
    localparam Idle_s = 3'd0,
               Wait4Pulse_s = 3'd1, 
               GetRed_s = 3'd2, 
               GetGreen_s = 3'd3, 
               GetBlue_s = 3'd4;

    always @(posedge clk_i or negedge rst_i) begin
        if (rst_i) 
            ps_r <= Idle_s;
        else
            ps_r <= ns_r;
    end

    always @(ps_r, start_i) begin
        case (ps_r)
            Idle_s: ns_r = start_i ? Wait4Pulse_s : Idle_s;
            Wait4Pulse_s: ns_r = ~start_i ? GetRed_s : Wait4Pulse_s;
            GetRed_s: ns_r = GetGreen_s;
            GetGreen_s: ns_r = GetBlue_s;
            GetBlue_s: ns_r = Idle_s;
        endcase
    end

    always @(ps_r) begin
        valid_o = 1'b0;
        clear_o = 1'b0;
        ld_o = 1'b0;
        case (ps_r)
            Idle_s: valid_o = 1'b1;
            Wait4Pulse_s: clear_o = 1'b0;
            GetRed_s: ld_o = 1'b1;
            GetGreen_s: ld_o = 1'b1;
            GetBlue_s: ld_o = 1'b1;
        endcase
    end
    
endmodule
