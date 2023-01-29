library verilog;
use verilog.vl_types.all;
entity Sobel_Datapath is
    generic(
        KX_SIZE         : integer := 3;
        KY_SIZE         : integer := 3;
        IMG_X_SIZE      : integer := 100;
        IMG_Y_SIZE      : integer := 100
    );
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        GrayImg_i       : in     vl_logic_vector(7 downto 0);
        cntrInputClear_i: in     vl_logic;
        cntrKernelClear_i: in     vl_logic;
        cntrMemGclear_i : in     vl_logic;
        memGclear_i     : in     vl_logic;
        memImgWr_i      : in     vl_logic;
        cntrInputInc_i  : in     vl_logic;
        saveImgOrCalculate_i: in     vl_logic;
        cntrKernelInc_i : in     vl_logic;
        memGwr_i        : in     vl_logic;
        cntrMemGinc_i   : in     vl_logic;
        dataAvailable_i : in     vl_logic;
        inputRecieved_o : out    vl_logic;
        kernelResReady_o: out    vl_logic;
        imageProcessed_o: out    vl_logic;
        outputSent_o    : out    vl_logic;
        ProcessedImagePixel_o: out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of KX_SIZE : constant is 1;
    attribute mti_svvh_generic_type of KY_SIZE : constant is 1;
    attribute mti_svvh_generic_type of IMG_X_SIZE : constant is 1;
    attribute mti_svvh_generic_type of IMG_Y_SIZE : constant is 1;
end Sobel_Datapath;
