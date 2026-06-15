module R_FormatCPU(
// Outputs
output wire [31:0] Output_Addr,
output wire [31:0] mem_out,
// Inputs
input wire [31:0] Input_Addr,
input wire clk,
input wire rst_n,
// Test mode signal
input wire test_normal, // 0: normal operation, 1: test operation
input wire [31:0] ext_addr,
input wire [31:0] ext_data,
input wire ext_we,
input wire mem_sel // 0: IM, 1: RF
);
// IM
wire [31:0] mux_input_addr;
assign mux_input_addr = test_normal?ext_addr:Input_Addr;
wire we;
assign we = test_normal & ext_we & (~mem_sel);
wire [31:0] Instruction;
// Control
wire [1:0] ALU_op;
wire Reg_w;
// ALU_Control
wire [5:0] Funct;
// RF
wire input_we;
assign input_we = test_normal ? (ext_we & mem_sel) : Reg_w;
wire [4:0] input_Rs_addr;
assign input_Rs_addr = Instruction[25:21];
wire [4:0] input_Rt_addr;
assign input_Rt_addr = test_normal ? ext_addr[4:0] : Instruction[20:16];
wire [4:0] input_Rd_addr;
assign input_Rd_addr = test_normal ? ext_addr[4:0] : Instruction[15:11];
wire [31:0] input_Rd_data;
wire [31:0] output_Rt_data;
wire [31:0] output_Rs_data;
assign mem_out = test_normal ? output_Rt_data : 32'b0;
// ALU
wire [31:0] result;
assign input_Rd_data = test_normal ? ext_data : result;

Adder u_Adder(
    .input_addr     (mux_input_addr),
    .output_addr    (Output_Addr)
);

IM u_IM(
    .instr_addr     (mux_input_addr),
    .instr_w_data   (ext_data),
    .we             (we),
    .rst_n          (rst_n),
    .clk            (clk),
    .instruction    (Instruction)
);

Control u_Control(
    .OpCode         (Instruction[31:26]),
    .output_ALU_op  (ALU_op),
    .output_Reg_w   (Reg_w)
);

ALU_Control u_ALU_Control(
    .ALU_op         (ALU_op),
    .Funct_ctrl     (Instruction[5:0]),
    .Funct          (Funct)
 );  

RF u_RF(
    .Rs_addr    (input_Rs_addr),
    .Rt_addr    (input_Rt_addr),
    .Rd_addr    (input_Rd_addr),
    .we         (input_we),
    .rst_n      (rst_n),
    .clk        (clk),
    .Rt_data    (output_Rt_data),
    .Rs_data    (output_Rs_data),
    .Rd_data    (input_Rd_data)
);
 
ALU u_ALU(
    .Funct          (Funct),
    .Shamt          (Instruction[10:6]),
    .Rs_data        (output_Rs_data),
    .Rt_data        (output_Rt_data),
    .result         (result)
);

endmodule