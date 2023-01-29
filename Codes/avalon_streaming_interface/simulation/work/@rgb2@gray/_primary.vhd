library verilog;
use verilog.vl_types.all;
entity Rgb2Gray is
    port(
        RedColor_i      : in     vl_logic_vector(7 downto 0);
        GreenColor_i    : in     vl_logic_vector(7 downto 0);
        BlueColor_i     : in     vl_logic_vector(7 downto 0);
        GrayColor_o     : out    vl_logic_vector(7 downto 0)
    );
end Rgb2Gray;
