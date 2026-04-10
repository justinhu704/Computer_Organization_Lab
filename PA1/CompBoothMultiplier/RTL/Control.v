module Control (
    input  clk,
    input  rst_n,
    input  preload,
    input  start,
    input  q0,
    input  q_1,
    output reg busy,
    output [1:0] funct,
    output reg valid
);

reg [5:0] count;

assign funct = (busy) ? (
                 ({q0, q_1} == 2'b01) ? 2'b01 :  // funct = 01
                 ({q0, q_1} == 2'b10) ? 2'b10 :  // funct = 10
                                        2'b00    // default
               ) : 2'b00;                        // busy = 0, default


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
            count <= count + 6'd1;

            if (count == 6'd31) begin
                busy  <= 1'b0;
                valid <= 1'b1;
            end
        end
    end
end

endmodule