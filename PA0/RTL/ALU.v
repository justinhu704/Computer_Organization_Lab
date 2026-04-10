`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/12 14:22:31
// Design Name: 
// Module Name: ALU
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


module ALU(
 input [31:0] Src_1,
 input [31:0] Src_2,
 input [4:0] Shamt,
 input [5:0] Funct,
 output [31:0] ALU_result,
 output Zero,
 output Carry
 );
 reg [32:0] alu_out;

always@(*)begin
    case(Funct)
        6'b100001: begin 
            alu_out = {1'b0, Src_1} + {1'b0, Src_2};
        end
        6'b100011: begin
            alu_out = {1'b0, Src_1} - {1'b0, Src_2};
        end
        6'b100111: alu_out = {1'b0, ~(Src_1 | Src_2)};
        6'b000010: alu_out =  Src_2 >> Shamt;
        6'b000000: alu_out = Src_2 << Shamt;
        default: alu_out = 33'b0;
	endcase
end
assign ALU_result = alu_out[31:0];
assign Carry = alu_out[32];
assign Zero = (alu_out[31:0]==32'b0);
endmodule
