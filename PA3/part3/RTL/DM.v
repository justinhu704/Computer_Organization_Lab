module DM(
    input [31:0] Mem_addr,
    input [31:0] Mem_w_data,
    input we,
    input re,
    input clk,
    input rst_n,
    output [31:0] Mem_r_data
);

reg [7:0] dm_mem [0:127];
wire [6:0] addr = {Mem_addr[6:2], 2'b00};
integer i;

assign Mem_r_data = re ? {dm_mem[addr],
                          dm_mem[addr + 1],
                          dm_mem[addr + 2],
                          dm_mem[addr + 3]} : 32'b0;

always @(posedge clk) begin
    if (!rst_n) begin
        for (i = 0; i < 128; i = i + 1) begin
            dm_mem[i] <= 8'd0;
        end
    end
    else if (we) begin
        dm_mem[addr]     <= Mem_w_data[31:24];
        dm_mem[addr + 1] <= Mem_w_data[23:16];
        dm_mem[addr + 2] <= Mem_w_data[15:8];
        dm_mem[addr + 3] <= Mem_w_data[7:0];
    end
end

endmodule