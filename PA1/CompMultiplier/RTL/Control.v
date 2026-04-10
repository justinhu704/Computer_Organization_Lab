module Control (
    input         clk,
    input         rst_n,
    input         preload,
    input         start,
    input         lsb,
    output reg [5:0] count,
    output reg       busy,
    output           wr_ctrl,
    output           srl_ctrl,
    output           funct,
    output reg       valid
);

assign wr_ctrl  = busy & lsb;
assign srl_ctrl = busy;
assign funct    = busy & lsb;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 6'd0;
        busy  <= 1'b0;
        valid <= 1'b0;
    end
    else begin
        valid <= 1'b0;

        if (preload) begin
            count <= 6'd0;
            busy  <= 1'b0;
        end
        else if (start && !busy) begin
            count <= 6'd0;
            busy  <= 1'b1;
        end
        else if (busy) begin
            count <= count + 1'b1;

            if (count == 6'd31) begin
                valid <= 1'b1;
                busy  <= 1'b0;
            end
        end
    end
end

endmodule