module EdgeDetector_MemImgAdrGen #(
    parameter X_SIZE = 100, 
              Y_SIZE = 100
)(
    X_i, 
    Y_i,
    MemImgAdr_o
);

    input [X_SIZE-1:0] X_i;
    input [Y_SIZE-1:0] Y_i;
    output [X_SIZE+Y_SIZE-1:0] MemImgAdr_o;

    assign MemImgAdr_o = (X_i * X_SIZE) + Y_i;
    
endmodule