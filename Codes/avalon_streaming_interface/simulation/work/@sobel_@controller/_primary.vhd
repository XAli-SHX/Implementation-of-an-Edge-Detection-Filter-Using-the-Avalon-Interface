library verilog;
use verilog.vl_types.all;
entity Sobel_Controller is
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        start_i         : in     vl_logic;
        inputRecieved_i : in     vl_logic;
        kernelResReady_i: in     vl_logic;
        imageProcessed_i: in     vl_logic;
        outputSent_i    : in     vl_logic;
        cntrInputClear_o: out    vl_logic;
        cntrKernelClear_o: out    vl_logic;
        cntrMemGclear_o : out    vl_logic;
        memGclear_o     : out    vl_logic;
        memImgWr_o      : out    vl_logic;
        cntrInputInc_o  : out    vl_logic;
        saveImgOrCalculate_o: out    vl_logic;
        cntrKernelInc_o : out    vl_logic;
        memGwr_o        : out    vl_logic;
        cntrMemGinc_o   : out    vl_logic;
        dataAvailable_o : out    vl_logic;
        valid_o         : out    vl_logic
    );
end Sobel_Controller;
