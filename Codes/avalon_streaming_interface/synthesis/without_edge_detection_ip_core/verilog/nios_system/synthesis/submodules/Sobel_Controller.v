module Sobel_Controller (
    clk_i,
    rst_i,
    start_i,
    inputRecieved_i,
    kernelResReady_i,
    imageProcessed_i,
    outputSent_i,
    cntrInputClear_o,
    cntrKernelClear_o,
    cntrMemGclear_o,
    memGclear_o,
    memImgWr_o,
    cntrInputInc_o,
    saveImgOrCalculate_o,
    cntrKernelInc_o,
    memGwr_o,
    cntrMemGinc_o,
    dataAvailable_o,
    valid_o
);

    input clk_i, rst_i, start_i, inputRecieved_i, kernelResReady_i, imageProcessed_i, outputSent_i;
    output reg cntrInputClear_o, cntrKernelClear_o, cntrMemGclear_o, memGclear_o, memImgWr_o, 
           cntrInputInc_o, saveImgOrCalculate_o, cntrKernelInc_o, memGwr_o, cntrMemGinc_o, 
           dataAvailable_o, valid_o;

    localparam Idle_s = 0, 
               Wait4Pulse_s = 1,
               GetInput_s = 2,
               CalculateKernel_s = 3,
               NextKernel_s = 4,
               DataAvailable_s = 5,
               GiveOutput_s = 6;
    reg [2:0] ps_r, ns_r;

    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i) ps_r <= Idle_s;
        else ps_r <= ns_r;
    end

    always @(ps_r, start_i, inputRecieved_i, kernelResReady_i, imageProcessed_i, outputSent_i) begin
        ns_r = Idle_s;
        case (ps_r)
            Idle_s: ns_r = start_i ? Wait4Pulse_s : Idle_s;
            Wait4Pulse_s: ns_r = ~start_i ? GetInput_s : Wait4Pulse_s;
            GetInput_s: ns_r = inputRecieved_i ? CalculateKernel_s : GetInput_s;
            CalculateKernel_s: ns_r = kernelResReady_i ? NextKernel_s : CalculateKernel_s;
            NextKernel_s: ns_r = imageProcessed_i ? DataAvailable_s : CalculateKernel_s;
            DataAvailable_s: ns_r = GiveOutput_s;
            GiveOutput_s: ns_r = outputSent_i ? Idle_s : GiveOutput_s;
        endcase
    end

    always @(ps_r) begin
        valid_o = 0;
        cntrInputClear_o = 0;
        cntrKernelClear_o = 0;
        cntrMemGclear_o = 0;
        memGclear_o = 0;
        memImgWr_o = 0;
        cntrInputInc_o = 0;
        saveImgOrCalculate_o = 0;
        cntrKernelInc_o = 0;
        memGwr_o = 0;
        cntrMemGinc_o = 0;
        dataAvailable_o = 0;
        case (ps_r)
            Idle_s: valid_o = 1;
            Wait4Pulse_s: begin
                cntrInputClear_o = 1;
                cntrKernelClear_o = 1;
                cntrMemGclear_o = 1;
                memGclear_o = 1;
            end
            GetInput_s: begin
                memImgWr_o = 1;
                cntrInputInc_o = 1;
            end
            CalculateKernel_s: begin
                saveImgOrCalculate_o = 1;
                cntrKernelInc_o = 1;
                memGwr_o = 1;
            end
            NextKernel_s: cntrMemGinc_o = 1;
            DataAvailable_s: dataAvailable_o = 1;
            GiveOutput_s: begin
                cntrMemGinc_o = 1;
                dataAvailable_o = 1;
            end
        endcase
    end
    
endmodule
