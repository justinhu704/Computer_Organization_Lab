module DM(
    input wire [31:0] Mem_addr,
    input wire [31:0] Mem_w_data,
    input wire we,
    input re,
    input clk,
    input rst_n,
    output wire [31:0] Mem_r_data
);
reg [7:0] data_mem [0:127];
integer i;

assign Mem_r_data = re ? {
    data_mem[Mem_addr],
    data_mem[Mem_addr+1],
    data_mem[Mem_addr+2],
    data_mem[Mem_addr+3]
} : 32'b0;

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0; i<128; i=i+1)begin
            data_mem[i] <= 8'b0;
        end
    end
    else if(we) begin
        data_mem[Mem_addr]    <= Mem_w_data[31:24];
        data_mem[Mem_addr+1]  <= Mem_w_data[23:16];
        data_mem[Mem_addr+2]  <= Mem_w_data[15:8];
        data_mem[Mem_addr+3]  <= Mem_w_data[7:0];
    end
end

endmodule
