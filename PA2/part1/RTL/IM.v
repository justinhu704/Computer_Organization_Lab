module IM(
    input wire [31:0]  instr_addr,
    input wire [31:0]  instr_w_data,
    input we,
    input rst_n,
    input clk,
    output wire [31:0] instruction
);

reg [7:0] ins_mem [0:127];
integer i;
assign instruction = {ins_mem[instr_addr], ins_mem[instr_addr+1], ins_mem[instr_addr+2], ins_mem[instr_addr+3]};

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0; i<128; i=i+1) begin
            ins_mem[i] <= 8'd0;
        end
    end
    else if(we) begin
        ins_mem[instr_addr]   <= instr_w_data[31:24];
        ins_mem[instr_addr+1] <= instr_w_data[23:16];
        ins_mem[instr_addr+2] <= instr_w_data[15:8];
        ins_mem[instr_addr+3] <= instr_w_data[7:0];
    end
end

endmodule