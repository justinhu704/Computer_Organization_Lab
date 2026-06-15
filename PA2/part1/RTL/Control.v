module Control(
    input wire [5:0] OpCode,
    output wire [1:0] output_ALU_op,
    output wire output_Reg_w
);

// R_Format
assign output_Reg_w = 1'b1;
assign output_ALU_op = 2'b10;

endmodule