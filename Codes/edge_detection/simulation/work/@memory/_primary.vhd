library verilog;
use verilog.vl_types.all;
entity Memory is
    generic(
        WORD            : integer := 8;
        SIZE            : integer := 256
    );
    port(
        clk_i           : in     vl_logic;
        wr_i            : in     vl_logic;
        Adr_i           : in     vl_logic_vector;
        DataWr_i        : in     vl_logic_vector;
        DataRd_o        : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WORD : constant is 1;
    attribute mti_svvh_generic_type of SIZE : constant is 1;
end Memory;
