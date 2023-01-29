library verilog;
use verilog.vl_types.all;
entity EdgeDetector is
    generic(
        KX_SIZE         : integer := 3;
        KY_SIZE         : integer := 3;
        IMG_X_SIZE      : integer := 100;
        IMG_Y_SIZE      : integer := 100
    );
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        GrayImage_i     : in     vl_logic_vector(7 downto 0);
        start_i         : in     vl_logic;
        dataAvailable_o : out    vl_logic;
        valid_o         : out    vl_logic;
        ProcessedImagePixel_o: out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of KX_SIZE : constant is 1;
    attribute mti_svvh_generic_type of KY_SIZE : constant is 1;
    attribute mti_svvh_generic_type of IMG_X_SIZE : constant is 1;
    attribute mti_svvh_generic_type of IMG_Y_SIZE : constant is 1;
end EdgeDetector;
