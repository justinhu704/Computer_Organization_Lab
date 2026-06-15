module SimpleCPU (
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
input wire mem_sel // 0: IM, 1: DM
);

// IM
wire [31:0] IM_Instr_addr;
assign IM_Instr_addr = test_normal ? ext_addr : Input_Addr;
wire [31:0] IM_Instr_w_data;
assign IM_Instr_w_data = ext_data;
wire IM_we;
assign IM_we = (test_normal & ext_we & (~mem_sel));
wire [31:0] Instruction;

// Control
wire Control_Reg_dst;
wire Control_Branch;
wire Control_Reg_w;
wire [1:0] Control_ALU_op;
wire Control_ALU_src;
wire Control_Mem_w;
wire Control_Mem_r;
wire Control_Mem_to_reg;
wire Control_Jump;

// RF
wire RF_we;
assign RF_we = test_normal ? 1'b0 : Control_Reg_w;

wire [4:0] RF_Rd_addr;
assign RF_Rd_addr = Control_Reg_dst ? Instruction[15:11] : Instruction[20:16];

wire [31:0] RF_Rd_data;
wire [31:0] RF_Rt_data;
wire [31:0] RF_Rs_data;

// ALU
wire [31:0] sign_imm_ext;  // sign extend the immediate(for lw, sw, addi, subi, beq)
wire [31:0] zero_imm_ext;  // zero extend the immediate(for ori)
assign sign_imm_ext = {{16{Instruction[15]}}, Instruction[15:0]};
assign zero_imm_ext = {16'b0, Instruction[15:0]};
wire [31:0] imm_ext = (Control_ALU_op==2'b11) ? zero_imm_ext : sign_imm_ext; // determine sign/zero extension

wire [31:0] ALU_Rt_data;
assign ALU_Rt_data = Control_ALU_src ? imm_ext : RF_Rt_data;
wire [31:0] ALU_result;
wire zero;

// ALU_Control
wire [5:0] Funct;

// DM
wire [31:0] DM_Mem_addr;
assign DM_Mem_addr = test_normal ? ext_addr : ALU_result;
wire [31:0] DM_Mem_w_data;
assign DM_Mem_w_data = test_normal ? ext_data : RF_Rt_data;

wire DM_we;
assign DM_we = test_normal ? (ext_we & mem_sel) : Control_Mem_w;
wire DM_re;
assign DM_re = test_normal ? 1'b1 : Control_Mem_r;
wire [31:0] DM_Mem_r_data;

assign RF_Rd_data = Control_Mem_to_reg ? DM_Mem_r_data : ALU_result;
assign mem_out = test_normal ? DM_Mem_r_data : 32'b0;

// Adder
wire [31:0] NextPC;

wire [31:0] Jump_PC;
assign Jump_PC = {NextPC[31:28], Instruction[25:0], 2'b0};

wire [31:0] Branch_PC;
assign Branch_PC = imm_ext << 2;

wire [31:0] Adder_result_Branch;
wire [31:0] Adder_result;
assign Adder_result = (zero & Control_Branch) ? Adder_result_Branch : NextPC;

// Output
assign Output_Addr = Control_Jump ? Jump_PC : Adder_result;

IM u_IM(
    .instr_addr     (IM_Instr_addr),
    .instr_w_data   (IM_Instr_w_data),
    .we             (IM_we),
    .rst_n          (rst_n),
    .clk            (clk),
    .instruction    (Instruction)
);

Control u_Control(
    .OpCode         (Instruction[31:26]),
    .Reg_dst        (Control_Reg_dst),
    .Branch         (Control_Branch),
    .Reg_w          (Control_Reg_w),
    .output_ALU_op  (Control_ALU_op),
    .ALU_src        (Control_ALU_src),
    .Mem_w          (Control_Mem_w),
    .Mem_r          (Control_Mem_r),
    .Mem_to_reg     (Control_Mem_to_reg),
    .Jump           (Control_Jump)
);

RF u_RF(
    .Rs_addr    (Instruction[25:21]),
    .Rt_addr    (Instruction[20:16]),
    .Rd_addr    (RF_Rd_addr),
    .we         (RF_we),
    .rst_n      (rst_n),
    .clk        (clk),
    .Rt_data    (RF_Rt_data),
    .Rs_data    (RF_Rs_data),
    .Rd_data    (RF_Rd_data)
);

ALU u_ALU(
    .Funct          (Funct),
    .Shamt          (Instruction[10:6]),
    .Rs_data        (RF_Rs_data),
    .Rt_data        (ALU_Rt_data),
    .result         (ALU_result),
    .zero           (zero)
);

ALU_Control u_ALU_Control(
    .ALU_op         (Control_ALU_op),
    .Funct_ctrl     (Instruction[5:0]),
    .Funct          (Funct)
);

DM u_DM(
    .Mem_addr       (DM_Mem_addr),
    .Mem_w_data     (DM_Mem_w_data),
    .we             (DM_we),
    .re             (DM_re),
    .clk            (clk),
    .rst_n          (rst_n),
    .Mem_r_data     (DM_Mem_r_data)
);

Adder u_Adder(
    .input_addr     (Input_Addr),
    .NextPC         (32'd4),
    .output_addr    (NextPC)
);

Adder u_Adder_Branch(
    .input_addr     (NextPC),
    .NextPC         (Branch_PC),
    .output_addr    (Adder_result_Branch)
);



endmodule