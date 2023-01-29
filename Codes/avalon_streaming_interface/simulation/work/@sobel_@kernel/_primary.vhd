library verilog;
use verilog.vl_types.all;
entity Sobel_Kernel is
    port(
        Xindex_i        : in     vl_logic_vector(1 downto 0);
        Yindex_i        : in     vl_logic_vector(1 downto 0);
        Kx_o            : out    vl_logic_vector(2 downto 0);
        Ky_o            : out    vl_logic_vector(2 downto 0)
    );
end Sobel_Kernel;
