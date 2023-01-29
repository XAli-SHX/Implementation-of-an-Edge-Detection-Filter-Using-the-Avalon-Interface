library verilog;
use verilog.vl_types.all;
entity Rgb2Gray_AvalonStreaming is
    port(
        csi_clock_reset_clk: in     vl_logic;
        csi_clock_reset_reset_n: in     vl_logic;
        asi_sink1_data  : in     vl_logic_vector(23 downto 0);
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
end Rgb2Gray_AvalonStreaming;
