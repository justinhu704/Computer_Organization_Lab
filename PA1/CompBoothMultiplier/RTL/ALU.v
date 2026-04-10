module ALU (
    input  signed [31:0] src_1,   // A
    input  signed [31:0] src_2,   // M
    input  [1:0] funct,           // 01: add, 10: sub
    output reg signed [31:0] result,
    output reg carry
);

reg signed [32:0] temp_sum;

always @(*) begin
    case (funct)
        2'b01: begin
            temp_sum = {src_1[31], src_1} + {src_2[31], src_2};
            result   = temp_sum[31:0];
            carry    = temp_sum[32];
        end
        2'b10: begin
            temp_sum = {src_1[31], src_1} - {src_2[31], src_2};
            result   = temp_sum[31:0];
            carry    = temp_sum[32];
        end
        default: begin
            temp_sum = {src_1[31], src_1};
            result   = src_1;
            carry    = temp_sum[32];
        end
    endcase
end

endmodule