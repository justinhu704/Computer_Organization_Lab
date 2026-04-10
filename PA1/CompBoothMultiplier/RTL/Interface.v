module Interface (
    input [31:0] multiplicand_in,
    input [31:0] multiplier_in,
    input [64:0] product_in,
    input valid_in,
    output [31:0] multiplicand_out,
    output [31:0] multiplier_out,
    output [63:0] product_out,
    output valid_out
);

assign multiplicand_out = multiplicand_in;
assign multiplier_out = multiplier_in;
assign valid_out = valid_in;
assign product_out = product_in[64:1];

endmodule