module ALU (
    input  [31:0] src_1,  // remainder[63:32]
    input  [31:0] src_2,  // divisor
    input         funct,
    output [31:0] result,
    output        carry
);

reg [32:0] temp_sum;
assign carry = temp_sum[32];
assign result = temp_sum[31:0];
always @(*) begin
    if(funct) begin
        temp_sum = {1'b0, src_1} - {1'b0, src_2};
    end else begin
        temp_sum = {1'b0, src_1};
    end
end

endmodule