module Remainder (
    input   clk,
    input   preload,
    input   rst_n,
    input [31:0]  dividend,
    input   carry,
    input [31:0]  result,
    input   busy,
    input   sll_ctrl,
    input   srl_ctrl,
    input   wr_ctrl,
    output [63:0] remainder_out
);

reg [63:0] remainder_reg;

assign remainder_out = remainder_reg;

always@(posedge clk or negedge rst_n) begin 
    if(!rst_n) begin
        remainder_reg <= 64'd0;
    end
    else begin
        if(preload) begin
            remainder_reg <= {32'd0, dividend};
        end
        else if(busy && wr_ctrl) begin
            if(sll_ctrl && srl_ctrl) begin
                remainder_reg <= {remainder_reg[62:0], 1'b0};  // initially left shift
            end
            else if(sll_ctrl) begin 
                if(carry) begin  // negative
                   remainder_reg <= {remainder_reg[62:0], 1'b0};  // not use alu_result
                end
                else begin  // positive
                    remainder_reg <= {result[30:0], remainder_reg[31:0], 1'b1};
                end
            end
            else if (srl_ctrl) begin  // remainder right shift
                remainder_reg[63:32] <= {1'b0, remainder_reg[63:33]};
            end
        end
    end
end
endmodule