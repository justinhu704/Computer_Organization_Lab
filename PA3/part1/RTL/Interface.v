module Interface(
    input [31:0] ext_addr,
    input [31:0] ext_data,
    input test_normal,
    input ext_we,
    input mem_sel,
    input [31:0] mem_out_input,
    output [31:0] mem_out,
    output [31:0] ext_addr_output,
    output [31:0] ext_data_output,
    output test_normal_output,
    output ext_we_output,
    output mem_sel_output,
    input clk
);

assign ext_addr_output = ext_addr;
assign ext_data_output = ext_data;
assign test_normal_output = test_normal;
assign ext_we_output = ext_we;
assign mem_sel_output = mem_sel;
assign mem_out = mem_out_input;

endmodule