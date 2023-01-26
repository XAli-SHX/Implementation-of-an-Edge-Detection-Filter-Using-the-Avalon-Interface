module CounterDualPort #(
    parameter WIDTH = 100, 
              X_END = 3,
              Y_END = 3
) (
    clk_i,
    rst_i,
    inc_i,
    clear_i,
    X_o,
    Y_o,
    finished_o
);

    input clk_i, rst_i, inc_i, clear_i;
    output reg [WIDTH-1:0] X_o, Y_o;
    output reg finished_o;

    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            X_o <= 0;
            Y_o <= 0;
        end else begin
            if (clear_i) begin
                X_o <= 0;
                Y_o <= 0;
            end else begin
                if (inc_i) begin
                    if (Y_o == Y_END) begin
                        Y_o <= 0;
                        if (X_o == X_END) begin
                            X_o <= 0;
                        end else begin
                            X_o <= X_o + 1;
                        end
                    end else begin
                        Y_o <= Y_o + 1;
                    end
                end
            end
        end
    end

    always @(X_o, Y_o) begin
        if (X_o == X_END && Y_o == Y_END) begin
            finished_o = 1;
        end else begin
            finished_o = 0;
        end
    end

endmodule
