`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/12 14:25:19
// Design Name: 
// Module Name: CompALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CompALU(
    input [31:0] Instruction,
    output [31:0] CompALU_out,
    output CompALU_zero,
    output CompALU_carry
    );
wire [31:0] Src_1, Src_2;
wire [4:0] Rs = Instruction[25:21];
wire [4:0] Rt = Instruction[20:16];
wire [5:0] Func = Instruction[5:0];
wire [4:0] Shamt = Instruction[10:6];
RF Register_File(
    .Rs_addr(Rs),
    .Rt_addr(Rt),
    .Src_1(Src_1),
    .Src_2(Src_2)
);
ALU ALU_File(
    .Src_1(Src_1),
    .Src_2(Src_2),
    .Shamt(Shamt),
    .Funct(Func),
    .ALU_result(CompALU_out),
    .Zero(CompALU_zero),
    .Carry(CompALU_carry)
);

endmodule
