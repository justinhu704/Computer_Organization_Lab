module Divisor (
    input [31:0] divisor_in,
    input preload,
    input rst_n,
    input clk,
    output [31:0] divisor_out
);

reg [31:0] divisor_reg;
assign divisor_out = divisor_reg;

always@(posedge clk or negedge rst_n) begin
   if(!rst_n) begin
       divisor_reg <= 32'b0;
   end 
   else begin
       if(preload) begin
           divisor_reg <= divisor_in;
       end
   end
end

endmodule