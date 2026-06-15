module Adder(
    input wire [31:0]  input_addr,
    output wire [31:0] output_addr
);

assign output_addr = input_addr + 3'b100;

endmodule
