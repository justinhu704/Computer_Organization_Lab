module IM (
    input wire [31:0] Instr_addr,
    input wire [31:0] instr_w_data,
    output wire [31:0] Instruction,
    input wire we,
    input wire clk,
    input wire rst_n
);

    reg [7:0] instruction_memory [0:127];
    wire [6:0] addr = {Instr_addr[6:2], 2'b00};
    assign Instruction = {instruction_memory[addr], 
                          instruction_memory[addr + 1], 
                          instruction_memory[addr + 2], 
                          instruction_memory[addr + 3]};

    integer i;
    always @(posedge clk) begin
        if (!rst_n) begin
            for (i = 0; i < 128; i = i + 1) begin
                instruction_memory[i] <= 8'd0;
            end
        end 
        else if (we) begin
            instruction_memory[addr]     <= instr_w_data[31:24];
            instruction_memory[addr + 1] <= instr_w_data[23:16];
            instruction_memory[addr + 2] <= instr_w_data[15:8];
            instruction_memory[addr + 3] <= instr_w_data[7:0];
        end
    end

endmodule