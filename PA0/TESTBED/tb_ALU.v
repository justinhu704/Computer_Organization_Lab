/*
 *	Testbench for Homework 1
 *	Copyright (C) 2026 Wei Wen Lin, Hong Ming Kang or any person belong IEESLab.
 *	All Right Reserved.
 *
 *	This program is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 *	along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 *	This file is for people who have taken the cource (1142 Computer
 *	Organizarion) to use.
 *	We (IEESLab) are not responsible for any illegal use.
 *
 */

// Setting timescale
`timescale 1ns / 1ps

// Configuration
`define PERIOD					10.0
`define TERMINATE_CLOCK_CYCLE	1000.0
`define RST_CLOCK_CYLCE 		2.0

`define INPUT_FILE				"../../../../../TESTBED/test_patterns/ALU_in.dat"
`define OUTPUT_FILE				"../../../../../TESTBED/test_patterns/ALU_out.dat"

module tb_ALU;

	// Inputs
	reg [31:0] Src_1;
	reg [31:0] Src_2;
	reg [4:0] Shamt;
	reg [5:0] Funct;
	
	// Outputs
	wire [31:0] ALU_result;
	wire Zero;
	wire Carry;
	
    wire glbl_GSR = glbl.GSR;
	// Clock signal
    wire clk;
    clk_gen U_clk_gen (
        .glbl_GSR(glbl_GSR  ),
        .clk     (clk       ),
        .rst     (          ),
        .rst_n   (          )
    );
	
	// Testbench variables
	reg [74:0] read_data;
	integer input_file;
	integer output_file;
	integer i;
	
	// Instantiate the Unit Under Test (UUT)
	ALU UUT(
		// Inputs
		.Src_1(Src_1),
		.Src_2(Src_2),
		.Shamt(Shamt),
		.Funct(Funct),
		// Outputs
		.ALU_result(ALU_result),
		.Zero(Zero),
		.Carry(Carry)
	);
	
	initial begin
		// Initialize inputs
		Src_1	= 32'b0;
		Src_2	= 32'b0;
		Shamt	= 5'b0;
		Funct	= 6'b0;

		// Initialize testbench files
		input_file	= $fopen(`INPUT_FILE, "r");
        if (input_file === 0) begin
            $display("Cannot open input file. Check your directory.");
			$finish;
        end
		output_file	= $fopen(`OUTPUT_FILE);
        if (output_file === 0) begin
            $display("Cannot open output file. Check your directory.");
			$finish;
        end

        // Delay
		repeat(3) @(posedge clk);

		// Start testing
		while (!$feof(input_file)) begin
			$fscanf(input_file, "%b\n", read_data);
			@(posedge clk);	// Wait clock
			{Src_1, Src_2, Shamt, Funct} = read_data;
			@(negedge clk);	// Wait clock
			$display("Src_1:%b, Src_2:%b, Shamt:%b, Funct:%b", Src_1, Src_2, Shamt, Funct);
			$display("ALU_result:%d, Z:%b, C:%b", ALU_result, Zero, Carry);
			$fdisplay(output_file, "%b,%b,%b", ALU_result, Zero, Carry);
		end

		// Close output file for safety
		$fclose(output_file);

		// Stop the simulation
		$finish;

	end
endmodule

// -------------------------
// DO NOT MODIFY THIS PART
// -------------------------
module clk_gen (
    input      glbl_GSR ,
    output reg clk      ,
    output reg rst      ,
    output reg rst_n
);
    always #(`PERIOD / 2.0) clk = ~clk;

    initial begin
        clk = 1'b0;
        wait (glbl_GSR === 1'b1);
        wait (glbl_GSR === 1'b0);
        @(posedge clk);
        rst = 1'b0; rst_n = 1'b1; #(                    0.5  * `PERIOD);
        rst = 1'b1; rst_n = 1'b0; #((`RST_CLOCK_CYLCE - 0.5) * `PERIOD);
        rst = 1'b0; rst_n = 1'b1; #(  `TERMINATE_CLOCK_CYCLE * `PERIOD);
		$display("Exceed maximum simulation time!");
		// Stop the simulation
		$finish;
    end
endmodule
// -------------------------