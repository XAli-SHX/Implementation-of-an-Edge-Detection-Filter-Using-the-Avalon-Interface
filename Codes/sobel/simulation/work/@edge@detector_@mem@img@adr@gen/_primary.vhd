library verilog;
use verilog.vl_types.all;
entity EdgeDetector_MemImgAdrGen is
    generic(
        X_SIZE          : integer := 100;
        Y_SIZE          : integer := 100
    );
    port(
        X_i             : in     vl_logic_vector;
        Y_i             : in     vl_logic_vector;
        MemImgAdr_o     : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of X_SIZE : constant is 1;
    attribute mti_svvh_generic_type of Y_SIZE : constant is 1;
end EdgeDetector_MemImgAdrGen;
