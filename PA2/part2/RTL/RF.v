module RF(
    input wire [4:0] Rs_addr,
    input wire [4:0] Rt_addr,
    input wire [4:0] Rd_addr,
    input we,
    input rst_n,
    input clk,
    output wire [31:0] Rt_data,
    output wire [31:0] Rs_data,
    input wire [31:0] Rd_data
);
reg [31:0] reg_file [0:31];
assign Rs_data = reg_file[Rs_addr];
assign Rt_data = reg_file[Rt_addr];
integer i;

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0; i <32; i=i+1) begin
            reg_file[i] <= 32'b0;
        end
    end
    else begin
        if(we) begin
            reg_file[Rd_addr] <= Rd_data;
        end
    end
end

endmodule
