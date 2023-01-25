library verilog;
use verilog.vl_types.all;
entity Rgb2Gray_Datapath is
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        ld_i            : in     vl_logic;
        clear_i         : in     vl_logic;
        RgbColor_i      : in     vl_logic_vector(9 downto 0);
        GrayColor_o     : out    vl_logic_vector(7 downto 0)
    );
end Rgb2Gray_Datapath;
