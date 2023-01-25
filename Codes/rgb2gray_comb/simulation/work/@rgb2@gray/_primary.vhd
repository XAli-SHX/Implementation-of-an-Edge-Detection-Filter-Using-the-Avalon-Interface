library verilog;
use verilog.vl_types.all;
entity Rgb2Gray is
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        start_i         : in     vl_logic;
        RgbColor_i      : in     vl_logic_vector(7 downto 0);
        valid_o         : out    vl_logic;
        GrayColor_o     : out    vl_logic_vector(7 downto 0)
    );
end Rgb2Gray;
