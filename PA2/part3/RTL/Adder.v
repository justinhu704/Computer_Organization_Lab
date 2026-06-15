module Adder(
    input wire [31:0]  input_addr,
    input wire [31:0]  NextPC,
    output wire [31:0] output_addr
);

assign output_addr = input_addr + NextPC;

endmodule
