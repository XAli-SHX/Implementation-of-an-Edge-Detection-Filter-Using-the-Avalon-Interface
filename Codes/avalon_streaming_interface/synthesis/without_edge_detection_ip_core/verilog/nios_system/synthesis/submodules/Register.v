module Register #(
    parameter SIZE = 10
) (
    clk_i,
    rst_i,
    ld_i,
    clear_i,
    DataIn_i,
    DataOut_o
);

    input clk_i, rst_i, ld_i, clear_i;
    input [SIZE-1:0] DataIn_i;
    output reg [SIZE-1:0] DataOut_o;

    always @(posedge clk_i, posedge rst_i) begin
        if (rst_i) begin
            DataOut_o <= 0;
        end else if (clear_i) begin
            DataOut_o <= 0;
        end else if (ld_i) begin
            DataOut_o <= DataIn_i;
        end
    end
    
endmodule
