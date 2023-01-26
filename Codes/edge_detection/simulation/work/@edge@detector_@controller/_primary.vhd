library verilog;
use verilog.vl_types.all;
entity EdgeDetector_Controller is
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        start_i         : in     vl_logic;
        inputRecieved_i : in     vl_logic;
        calcDone_i      : in     vl_logic;
        outputSent_i    : in     vl_logic;
        valid_o         : out    vl_logic
    );
end EdgeDetector_Controller;
