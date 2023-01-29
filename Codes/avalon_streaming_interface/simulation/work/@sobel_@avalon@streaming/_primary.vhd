library verilog;
use verilog.vl_types.all;
entity Sobel_AvalonStreaming is
    generic(
        IMG_X_SIZE      : integer := 320;
        IMG_Y_SIZE      : integer := 240
    );
    port(
        csi_clkrst_clk  : in     vl_logic;
        csi_clkrst_reset_n: in     vl_logic;
        asi_sink1_data  : in     vl_logic_vector(7 downto 0);
        asi_sink1_startofpacket: in     vl_logic;
        asi_sink1_endofpacket: in     vl_logic;
        asi_sink1_valid : in     vl_logic;
        asi_sink1_ready : out    vl_logic;
        aso_source1_ready: in     vl_logic;
        aso_source1_data: out    vl_logic_vector(7 downto 0);
        aso_source1_startofpacket: out    vl_logic;
        aso_source1_endofpacket: out    vl_logic;
        aso_source1_valid: out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IMG_X_SIZE : constant is 1;
    attribute mti_svvh_generic_type of IMG_Y_SIZE : constant is 1;
end Sobel_AvalonStreaming;
