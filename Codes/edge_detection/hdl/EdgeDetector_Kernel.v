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

    // kx
    wire [2:0] KxMem_m [0:8];
    assign {KxMem_m[0], KxMem_m[1], KxMem_m[2]} = { 3'b111, 3'b000, 3'b001 };
    assign {KxMem_m[3], KxMem_m[4], KxMem_m[5]} = { 3'b110, 3'b000, 3'b010 };
    assign {KxMem_m[6], KxMem_m[7], KxMem_m[8]} = { 3'b111, 3'b000, 3'b001 };

    // ky
    wire [2:0] KyMem_m [0:8];
    assign {KyMem_m[0], KyMem_m[1], KyMem_m[2]} = { 3'b001, 3'b010, 3'b001 };
    assign {KyMem_m[3], KyMem_m[4], KyMem_m[5]} = { 3'b000, 3'b000, 3'b000 };
    assign {KyMem_m[6], KyMem_m[7], KyMem_m[8]} = { 3'b111, 3'b110, 3'b111 };

    assign Kx_o = KxMem_m[Xindex_i*3 + Yindex_i];
    assign Ky_o = KyMem_m[Xindex_i*3 + Yindex_i];
    
endmodule