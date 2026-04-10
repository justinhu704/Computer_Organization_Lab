module ALU (
    input  [31:0] src_1,
    input  [31:0] src_2,
    input         funct,
    output reg [32:0] result,
    output reg        carry
);

reg [32:0] temp_sum;

always @(*) begin
    if (funct) begin
        temp_sum = {1'b0, src_1} + {1'b0, src_2};
        result   = temp_sum[31:0];
        carry    = temp_sum[32];
    end
    else begin
        result   = src_1;
        carry    = 1'b0;
    end
end

endmodule