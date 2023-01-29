library verilog;
use verilog.vl_types.all;
entity Mux2 is
    generic(
        WIDTH           : integer := 8
    );
    port(
        Data0_i         : in     vl_logic_vector;
        Data1_i         : in     vl_logic_vector;
        select_i        : in     vl_logic;
        DataOut_o       : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
end Mux2;
