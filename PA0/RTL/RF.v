`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/12 14:25:37
// Design Name: 
// Module Name: RF
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


module RF(
    input [4:0] Rs_addr,
    input [4:0] Rt_addr,
    output [31:0] Src_1,
    output [31:0] Src_2
    );
reg [31:0] R [0:31];

assign Src_1 = R[Rs_addr];
assign Src_2 = R[Rt_addr];
    
endmodule
