module Multiplicand (
    input         clk,
    input         rst_n,
    input         preload,
    input  [31:0] multiplicand_in,
    output [31:0] multiplicand_out
);

reg [31:0] multiplicand_reg;

assign multiplicand_out = multiplicand_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        multiplicand_reg <= 32'd0;
    end
    else begin
        if (preload) begin
            multiplicand_reg <= multiplicand_in;
        end
    end
end

endmodule