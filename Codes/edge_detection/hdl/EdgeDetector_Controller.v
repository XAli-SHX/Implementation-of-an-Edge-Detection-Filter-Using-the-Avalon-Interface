module EdgeDetector_Controller (
    clk_i,
    rst_i,
    start_i,
    inputRecieved_i,
    calcDone_i,
    outputSent_i,
    // add other controll signals
    valid_o
);

    input clk_i, rst_i, start_i, inputRecieved_i, calcDone_i, outputSent_i;
    output valid_o;

    localparam Idle_s = 0, 
               Wait4Pulse_s = 1,
               GetInput_s = 2,
               Calc_s = 3,
               GiveOutput_s = 4;
    reg [2:0] ps_r, ns_r;

    always @(posedge clk_i or negedge rst_i) begin
        if (rst_i) begin
            ps_r <= Idle_s;
        end else begin
            ps_r <= ns_r;
        end
    end

    always @(ps_r, start_i, inputRecieved_i, calcDone_i, outputSent_i) begin
        case (ps_r)
            Idle_s: ns_r <= start_i ? Wait4Pulse_s : Idle_s;
            Wait4Pulse_s: ns_r <= ~start_i ? GetInput_s : Wait4Pulse_s;
            GetInput_s: ns_r <= inputRecieved_i ? Calc_s : GetInput_s;
            Calc_s: ns_r <= calcDone_i ? GiveOutput_s : Calc_s;
            GiveOutput_s: ns_r <= outputSent_i ? Idle_s : GiveOutput_s;
        endcase
    end
    
endmodule