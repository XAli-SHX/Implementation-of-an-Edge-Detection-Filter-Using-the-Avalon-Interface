module EdgeDetector_MemImgAdrGen #(
    parameter X_SIZE = 100, 
              Y_SIZE = 100
)(
    X_i, 
    Y_i,
    MemImgAdr_o
);

    localparam X_BITS = $clog2(X_SIZE);
    localparam Y_BITS = $clog2(Y_SIZE);
    localparam ADR_BITS = $clog2(X_SIZE*Y_SIZE);

    input [X_BITS-1:0] X_i;
    input [Y_BITS-1:0] Y_i;
    output [ADR_BITS-1:0] MemImgAdr_o;

    assign MemImgAdr_o = (X_i * Y_SIZE) + Y_i;
    
endmodule