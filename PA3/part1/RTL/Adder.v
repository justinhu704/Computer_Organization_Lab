module Adder(
    input [31:0] pc,
    output [31:0] next_pc
);

assign next_pc = pc + 4'd4;

endmodule