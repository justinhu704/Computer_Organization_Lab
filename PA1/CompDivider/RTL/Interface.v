module Interface(
    input [31:0]   divisor,
    input [31:0]   dividend,
    input [63:0]   remainder,
    input          valid_in,
    output [31:0]  divisor_out,
    output [31:0]  dividend_out,
    output [63:0]  remainder_out,
    output         valid
);

assign divisor_out = divisor;
assign dividend_out = dividend;

assign remainder_out = remainder;
assign valid = valid_in;

endmodule