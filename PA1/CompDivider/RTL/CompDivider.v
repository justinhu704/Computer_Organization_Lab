module CompDivider (
    input clk,
    input rst_n,
    input preload,
    input start,
    input [31:0] divisor,
    input [31:0] dividend,
    output [31:0] remainder,
    output [31:0] quotient,
    output valid
);
// Interface
wire [31:0] if_divisor;
wire [31:0] if_dividend;
wire [63:0] if_remainder;
wire [63:0] remainder_out_all;
wire if_valid;
// Divisor
wire [31:0] divisor_out;
// ALU
wire [31:0] alu_result;
wire alu_carry;
wire funct;
// Control
wire sll_ctrl, srl_ctrl, wr_ctrl;
wire busy;
// Remainder


Interface u_Interface (
    .divisor        (divisor),
    .dividend       (dividend),
    .remainder      (if_remainder),
    .valid_in       (if_valid),
    .divisor_out    (if_divisor),
    .dividend_out   (if_dividend),
    .remainder_out  (remainder_out_all),
    .valid          (valid)
);
Divisor u_Divisor (
    .divisor_in     (if_divisor),
    .preload        (preload),
    .rst_n          (rst_n),
    .clk            (clk),
    .divisor_out    (divisor_out)
);
ALU u_ALU (
    .src_1      (if_remainder[63:32]),
    .src_2      (divisor_out),
    .funct      (funct),
    .result     (alu_result),
    .carry      (alu_carry)
);
Control u_Control (
    .clk        (clk),
    .rst_n      (rst_n),
    .start      (start),
    .preload    (preload),
    .carry      (carry),
    .sll_ctrl   (sll_ctrl),
    .srl_ctrl   (srl_ctrl),
    .wr_ctrl    (wr_ctrl),
    .funct      (funct),
    .busy       (busy),
    .valid      (if_valid)
);
Remainder u_Remainder (
    .clk        (clk),
    .preload    (preload),
    .rst_n      (rst_n),
    .dividend   (if_dividend),
    .carry      (alu_carry),
    .result     (alu_result),
    .busy       (busy),
    .sll_ctrl   (sll_ctrl),
    .srl_ctrl   (srl_ctrl),
    .wr_ctrl    (wr_ctrl),
    .remainder_out(if_remainder)
);
assign quotient = remainder_out_all[31:0];
assign remainder = remainder_out_all[63:32];
endmodule
