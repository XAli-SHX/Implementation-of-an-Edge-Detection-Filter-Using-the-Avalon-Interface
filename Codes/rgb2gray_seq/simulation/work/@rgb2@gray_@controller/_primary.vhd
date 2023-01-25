library verilog;
use verilog.vl_types.all;
entity Rgb2Gray_Controller is
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        start_i         : in     vl_logic;
        clear_o         : out    vl_logic;
        ld_o            : out    vl_logic;
        valid_o         : out    vl_logic
    );
end Rgb2Gray_Controller;
