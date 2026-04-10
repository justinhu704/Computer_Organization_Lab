module Multiplicand (
    input  clk,
    input  rst_n,
    input  preload,
    input  signed [31:0] multiplicand,
    output signed [31:0] multiplicand_out
);

reg signed [31:0] multiplicand_reg;

assign multiplicand_out = multiplicand_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        multiplicand_reg <= 32'sd0;
    else if (preload)
        multiplicand_reg <= multiplicand;
end

endmodule