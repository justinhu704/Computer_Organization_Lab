module InterfaceIn (
    input  [31:0] multiplier_in,
    input  [31:0] multiplicand_in,
    output [31:0] multiplier_out,
    output [31:0] multiplicand_out
);

assign multiplier_out   = multiplier_in;
assign multiplicand_out = multiplicand_in;

endmodule


module InterfaceOut (
    input  [63:0] product_in,
    input         valid_in,
    output [63:0] product_out,
    output        valid_out
);

assign product_out = product_in;
assign valid_out   = valid_in;

endmodule