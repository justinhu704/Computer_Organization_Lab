module Product (
    input         clk,
    input         rst_n,
    input         preload,
    input  signed [31:0] multiplier,
    input         busy,
    input  [1:0]  funct,
    input  signed [31:0] alu_result,
    input         alu_carry,
    output signed [64:0] product_out,
    output q0,
    output q_1
);

reg signed [64:0] product_reg;   // {A[31:0], Q[31:0], Q_1}
reg signed [64:0] temp_reg;

assign product_out = product_reg;
assign q0  = product_reg[1];
assign q_1 = product_reg[0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        product_reg <= 65'sd0;
    end
    else begin
        if (preload) begin
            product_reg <= {32'sd0, multiplier, 1'b0};
        end
        else if (busy) begin
            temp_reg = product_reg;

            case (funct)
                2'b01: temp_reg[64:33] = alu_result;   // A = A + M
                2'b10: temp_reg[64:33] = alu_result;   // A = A - M
                default: temp_reg[64:33] = product_reg[64:33];
            endcase
                temp_reg = {temp_reg[64], temp_reg[64:1]};  // right shift keep the first letter
                
            product_reg <= temp_reg;
        end
    end
end

endmodule