module Product (
    input         clk,
    input         rst_n,
    input         preload,
    input  [31:0] multiplier,
    input         busy,
    input         wr_ctrl,
    input         srl_ctrl,
    input  [31:0] alu_result,
    input         alu_carry,
    output [63:0] product_out
);

reg [63:0] product_reg;
reg [64:0] temp_reg;

assign product_out = product_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        product_reg <= 64'd0;
    end
    else begin
        if (preload) begin
            product_reg <= {32'd0, multiplier};
        end
        else if (busy) begin
            temp_reg = {1'b0, product_reg};

            if (wr_ctrl) begin
                temp_reg[64:32] = {alu_carry, alu_result};
            end

            if (srl_ctrl) begin
                temp_reg = temp_reg >> 1;
            end

            product_reg <= temp_reg[63:0];
        end
    end
end

endmodule