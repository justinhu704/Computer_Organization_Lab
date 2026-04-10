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

`define REGISTER_SIZE			32	// bit width
`define MAX_REGISTER			32	// index

`define DATA_FILE				"../../../../../TESTBED/test_patterns/RF_in.dat"
`define OUTPUT_FILE				"../../../../../TESTBED/test_patterns/RF_out.dat"

module tb_RF;

	// Inputs
	reg [4:0] Rs_addr;
	reg [4:0] Rt_addr;
	
	// Outputs
	wire [31:0] Rs_data;
	wire [31:0] Rt_data;
	
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
	reg [`REGISTER_SIZE-1:0] register [0:`MAX_REGISTER-1];
	integer input_file;
	integer output_file;
	integer i;
	
	// Instantiate the Unit Under Test (UUT)
	RF UUT(
		// Inputs
		.Rs_addr(Rs_addr),
		.Rt_addr(Rt_addr),
		// Outputs
		.Src_1(Rs_data),
		.Src_2(Rt_data)
	);
	
	initial begin
		// Initialize inputs
		Rs_addr = 32'b0;
		Rt_addr = 32'b0;

		// Initialize testbench files
		$readmemh(`DATA_FILE, register);
		output_file = $fopen(`OUTPUT_FILE);
		if (output_file === 0) begin
			$display("Cannot open output file. Check your directory.");
			$finish;
		end
		// Initialize internal register
		for (i = 0; i < `MAX_REGISTER; i = i + 1) begin
			UUT.R[i] = register[i];
		end

        // Delay
		repeat(3) @(posedge clk);
        
		// Start testing
		for (i = 0; i < `MAX_REGISTER; i = i + 1) begin
			Rs_addr = i[`REGISTER_SIZE-1:0];
			Rt_addr = `REGISTER_SIZE'd`MAX_REGISTER-1 - i[`REGISTER_SIZE-1:0];
			@(posedge clk);	// Wait clock
            #(`PERIOD/2.0); // Delay for half clock cycle
			$display("Rs_addr:%h, Rt_addr:%h", Rs_addr, Rt_addr);
			$display("Src_1:%h, Src_2:%h", Rs_data, Rt_data);
			$fwrite(output_file, "%h,%h\n", Rs_data, Rt_data);
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