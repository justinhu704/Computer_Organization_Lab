module RF(
    input [4:0] Rs_addr,
    input [4:0] Rt_addr,
    input [4:0] Rd_addr,
    input [31:0] Rd_data,
    input clk,
    input rst_n,
    input we,
    output [31:0] Rs_data,
    output [31:0] Rt_data
);

reg [31:0] reg_file [0:31];
assign Rs_data = (Rs_addr == 5'b0) ? 32'b0 : reg_file[Rs_addr];
assign Rt_data = (Rt_addr == 5'b0) ? 32'b0 : reg_file[Rt_addr];
integer i;

always @(posedge clk) begin
    if(!rst_n) begin
        for(i = 0; i < 32; i = i + 1) begin
            reg_file[i] <= 32'b0;
        end
    end
    else begin
        if(we && (Rd_addr != 5'b0)) begin
            reg_file[Rd_addr] <= Rd_data;
        end
    end
end

endmodule