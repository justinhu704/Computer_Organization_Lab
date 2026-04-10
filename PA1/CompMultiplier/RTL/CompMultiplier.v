module CompMultiplier (
    input         clk,
    input         rst_n,
    input         preload,
    input         start,
    input  [31:0] multiplier,
    input  [31:0] multiplicand,
    output [63:0] product,
    output        valid
);

wire [31:0]  if_multiplier;
wire [31:0]  if_multiplicand;

wire [31:0]  multiplicand_out;
wire [63:0]  product_out;

wire         busy;
wire         wr_ctrl;
wire         srl_ctrl;
wire         funct;
wire [5:0]   count;

wire [31:0]  alu_result;
wire         alu_carry;

InterfaceIn u_interface_in (
    .multiplier_in   (multiplier),
    .multiplicand_in (multiplicand),
    .multiplier_out  (if_multiplier),
    .multiplicand_out(if_multiplicand)
);

Multiplicand u_multiplicand (
    .clk              (clk),
    .rst_n            (rst_n),
    .preload          (preload),
    .multiplicand_in  (if_multiplicand),
    .multiplicand_out (multiplicand_out)
);

ALU u_alu (
    .src_1   (product_out[63:32]),
    .src_2   (multiplicand_out),
    .funct   (funct),
    .result  (alu_result),
    .carry   (alu_carry)
);

Control u_control (
    .clk      (clk),
    .rst_n    (rst_n),
    .preload  (preload),
    .start    (start),
    .lsb      (product_out[0]),
    .count    (count),
    .busy     (busy),
    .wr_ctrl  (wr_ctrl),
    .srl_ctrl (srl_ctrl),
    .funct    (funct),
    .valid    (valid)
);

Product u_product (
    .clk         (clk),
    .rst_n       (rst_n),
    .preload     (preload),
    .multiplier  (if_multiplier),
    .busy        (busy),
    .wr_ctrl     (wr_ctrl),
    .srl_ctrl    (srl_ctrl),
    .alu_result  (alu_result),
    .alu_carry   (alu_carry),
    .product_out (product_out)
);

InterfaceOut u_interface_out (
    .product_in  (product_out),
    .valid_in    (valid),
    .product_out (product),
    .valid_out   ()
);

endmodule