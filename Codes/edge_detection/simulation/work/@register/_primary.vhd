library verilog;
use verilog.vl_types.all;
entity \Register\ is
    generic(
        SIZE            : integer := 10
    );
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        ld_i            : in     vl_logic;
        clear_i         : in     vl_logic;
        DataIn_i        : in     vl_logic_vector;
        DataOut_o       : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of SIZE : constant is 1;
end \Register\;
