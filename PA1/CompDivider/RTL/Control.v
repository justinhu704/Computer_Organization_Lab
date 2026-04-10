module Control (
    input clk,
    input rst_n,
    input start,
    input preload,
    input carry,
    output reg sll_ctrl,
    output reg srl_ctrl,
    output reg wr_ctrl,
    output  funct,
    output reg busy,
    output reg valid
);

reg [5:0] count;
assign funct = (busy) ? 1'b1 : 1'b0;  // default sub

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        busy <= 1'd0;
        count <= 6'd0;
        valid <= 1'd0;
        {sll_ctrl, srl_ctrl, wr_ctrl} <= 3'b000;
    end
    else begin
        valid <= 1'd0;
        
        if(preload) begin
            count <= 6'd0;
            busy <= 1'd0;
            {sll_ctrl, srl_ctrl, wr_ctrl} <= 3'b000;
        end
        else if(start && !busy) begin
            busy <= 1'b1;
            count <= 6'd0;
            
            sll_ctrl <= 1'b1;
            srl_ctrl <= 1'b1; // initial left shift
            wr_ctrl <= 1'b1;
        end
        else if(busy) begin  // start loop
            if(count < 6'd32) begin
                count <= count + 1'b1;
                
                sll_ctrl <= 1'b1;  // left shift
                srl_ctrl <= 1'b0;  // avoid trigger initial left shift
                wr_ctrl <= 1'b1;
            end
            else if(count == 6'd32) begin
                count <= count + 1'b1;
                sll_ctrl <= 1'b0;
                srl_ctrl <= 1'b1;  // final right shift
                wr_ctrl <= 1'b1;
            end
            else begin
                count <= 6'd0;
                busy <= 1'd0;
                valid <= 1'd1;
                {sll_ctrl, srl_ctrl, wr_ctrl} <= 3'b000;
            end
        end
        else begin
            {sll_ctrl, srl_ctrl, wr_ctrl} <= 3'b000;
        end
    end
end

endmodule