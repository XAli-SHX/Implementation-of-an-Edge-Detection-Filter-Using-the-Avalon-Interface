module Memory #(
    parameter WORD = 8,
              SIZE = 256
)(
    clk_i,
    wr_i,
    clear_i,
    Adr_i,
    DataWr_i,
    DataRd_o
);

    localparam ADR_SIZE = $clog2(SIZE);
    input clk_i, wr_i, clear_i;
    input [WORD-1:0] DataWr_i;
    input [ADR_SIZE-1:0] Adr_i;
    output [WORD-1:0] DataRd_o;

    reg [WORD-1:0] mem_m [0:SIZE-1];

    // integer i;
    always @(posedge clk_i) begin
        if (clear_i) begin
            /* for (i = 0; i < SIZE; i = i + 1) begin
                mem_m[i] = {WORD{ 1'b0 }};
            end */
        end
        if (wr_i) begin
            mem_m[Adr_i] <= DataWr_i;
        end
    end

    assign DataRd_o = mem_m[Adr_i];

    
endmodule
