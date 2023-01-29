library verilog;
use verilog.vl_types.all;
entity Mac is
    generic(
        MULT_SIZE       : integer := 8;
        ACCUM_SIZE      : integer := 8
    );
    port(
        Mult1_i         : in     vl_logic_vector;
        Mult2_i         : in     vl_logic_vector;
        Accum_i         : in     vl_logic_vector;
        Result_o        : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of MULT_SIZE : constant is 1;
    attribute mti_svvh_generic_type of ACCUM_SIZE : constant is 1;
end Mac;
