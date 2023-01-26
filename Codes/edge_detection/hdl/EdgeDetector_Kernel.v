module EdgeDetector_Kernel (
    Xindex_i, 
    Yindex_i,
    Kx_o,
    Ky_o
);

    input [2:0] Xindex_i;
    input [2:0] Yindex_i;
    output [2:0] Kx_o;
    output [2:0] Ky_o;

    /**
    *   kx = [ [-1  0  1],
    *          [-2  0  2],
    *          [-1  0  1], ]
    *
    *   ky = [ [ 1  2  1],
    *          [ 0  0  0],
    *          [-1 -2 -1], ]
    **/

    reg [2:0] KxMem_m [0:8] = {
        3'b111, 3'b000, 3'b001,
        3'b110, 3'b000, 3'b010,
        3'b111, 3'b000, 3'b001
    };
    
    reg [2:0] KyMem_m [0:8] = {
        3'b001, 3'b010, 3'b001,
        3'b000, 3'b000, 3'b000,
        3'b111, 3'b110, 3'b111
    };

    assign Kx_o = KxMem_m[Xindex_i*3 + Yindex_i];
    assign Ky_o = KyMem_m[Xindex_i*3 + Yindex_i];
    
endmodule