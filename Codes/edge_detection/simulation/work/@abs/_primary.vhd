library verilog;
use verilog.vl_types.all;
entity \Abs\ is
    generic(
        WIDTH           : integer := 8
    );
    port(
        DataIn_i        : in     vl_logic_vector;
        DataOut_o       : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
end \Abs\;
