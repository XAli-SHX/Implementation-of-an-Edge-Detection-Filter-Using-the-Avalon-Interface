library verilog;
use verilog.vl_types.all;
entity CounterDualPort is
    generic(
        X_END           : integer := 3;
        Y_END           : integer := 3;
        X_WIDTH         : integer := 2;
        Y_WIDTH         : integer := 2
    );
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        inc_i           : in     vl_logic;
        clear_i         : in     vl_logic;
        X_o             : out    vl_logic_vector;
        Y_o             : out    vl_logic_vector;
        finished_o      : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of X_END : constant is 1;
    attribute mti_svvh_generic_type of Y_END : constant is 1;
    attribute mti_svvh_generic_type of X_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of Y_WIDTH : constant is 1;
end CounterDualPort;
