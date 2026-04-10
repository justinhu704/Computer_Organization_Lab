module CompBoothMultiplier (
    input  signed [31:0] multiplier,
    input  signed [31:0] multiplicand,
    input  clk,
    input  rst_n,
    input  preload,
    input  start,
    output signed [63:0] product,
    output valid
);
// Interface
wire signed [31:0] if_multiplicand;
wire signed [31:0] if_multiplier;
wire signed [64:0] product_out_all;
// Multiplicand
wire signed [31:0] multiplicand_out;
// Product
wire signed [64:0] product_out;
wire q0;
wire q_1;
// Control
wire busy;
wire [1:0] funct;      // 00: nop, 01: add, 10: sub
wire shift_ctrl;
// ALU
wire signed [31:0] alu_result;
wire alu_carry;


Interface u_Interface(
    .multiplicand_in    (multiplicand),
    .multiplier_in      (multiplier),
    .product_in         (product_out),
    .multiplicand_out   (if_multiplicand),
    .multiplier_out     (if_multiplier),
    .product_out        (product)
);
Multiplicand u_Multiplicand (
    .clk              (clk),
    .rst_n            (rst_n),
    .preload          (preload),
    .multiplicand     (if_multiplicand),
    .multiplicand_out (multiplicand_out)
);

ALU u_ALU (
    .src_1   (product_out[64:33]),   // A
    .src_2   (multiplicand_out),     // M
    .funct   (funct),
    .result  (alu_result),
    .carry   (alu_carry)
);

Control u_Control (
    .clk        (clk),
    .rst_n      (rst_n),
    .preload    (preload),
    .start      (start),
    .q0         (q0),
    .q_1        (q_1),
    .busy       (busy),
    .funct      (funct),
    .valid      (valid)
);

Product u_Product (
    .clk         (clk),
    .rst_n       (rst_n),
    .preload     (preload),
    .multiplier  (if_multiplier),
    .busy        (busy),
    .funct       (funct),
    .alu_result  (alu_result),
    .alu_carry   (alu_carry),
    .product_out (product_out),
    .q0          (q0),
    .q_1         (q_1)
); 

endmodule