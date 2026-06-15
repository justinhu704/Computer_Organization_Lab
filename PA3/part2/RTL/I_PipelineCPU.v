module I_PipelineCPU (
// Outputs
output wire [31:0] mem_out,
// Inputs
input wire clk,
input wire rst_n,
// Test mode signal
input wire test_normal, // 0: normal operation, 1: test operation
input wire [31:0] ext_addr,
input wire [31:0] ext_data,
input wire ext_we,
input wire mem_sel // 0: IM, 1: DM
);

// Interface
wire [31:0] ext_addr_out;
wire [31:0] ext_data_out;
wire test_normal_out;
wire ext_we_out;
wire mem_sel_out;
wire [31:0] mem_out_input;

// PC/Adder
wire [31:0] next_pc, pc;
reg [31:0] pc_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        pc_reg <= 32'b0;
    else if (test_normal_out)
        pc_reg <= 32'b0;
    else
        pc_reg <= next_pc;
end
assign pc = pc_reg;

Adder u_Adder(
    .pc(pc),
    .next_pc(next_pc)
);

// IM
wire [31:0] Instruction;

// Control
wire MemtoReg, Reg_w, MemRead, MemWrite, branch;
wire [1:0] ALU_Op;
wire ALUSrc, RegDst;

// RF
// sign extension
wire [31:0] signext_imm;
assign signext_imm = (ALU_Op == 2'b11) ? {16'b0, IFID_mem_Instruction[15:0]} : {{16{IFID_mem_Instruction[15]}}, IFID_mem_Instruction[15:0]};
wire [31:0] Rs_data, Rt_data;

// ALU
wire [31:0] ALU_out;

// ALU_Control
wire [5:0] Funct;

// DM
wire [31:0] Mem_r_data;
//assign mem_out_input = test_normal_out ? MEMWB_mem_DM_data : 32'b0;
reg [31:0] dm_reg1;
reg [31:0] dm_reg2;
always@(posedge clk)begin
    if (!rst_n) begin
        dm_reg1 <= 32'b0;
        dm_reg2 <= 32'b0;
    end
    else begin
        dm_reg1 <= test_normal_out ? Mem_r_data : 32'b0;
        dm_reg2 <= dm_reg1;
    end
end
assign mem_out_input = dm_reg2;


// ----------------------------------------
// IF/ID
// ----------------------------------------
reg [31:0] IFID_mem_Instruction;

always@(posedge clk) begin
    if(!rst_n) begin
        IFID_mem_Instruction <= 32'b0;
    end
    else begin
        if(!test_normal_out) begin
            IFID_mem_Instruction <= Instruction;
        end
        else begin
            IFID_mem_Instruction <= 32'b0;
        end
    end
end

// ----------------------------------------
// ID/EX
// ----------------------------------------
reg [31:0] IDEX_mem_Rs_data, IDEX_mem_Rt_data;
reg [4:0] IDEX_mem_Rd_addr, IDEX_mem_Rt_addr;
reg [31:0] IDEX_mem_signext;
reg [1:0] IDEX_mem_WB; // {MemtoReg, Reg_w}
reg [2:0] IDEX_mem_M; // {MemRead, MemWrite, branch}
reg [3:0] IDEX_mem_EX; // {ALU_Op, ALUSrc, RegDst}

always@(posedge clk)begin
    if(!rst_n)begin
        IDEX_mem_Rs_data <= 32'b0;
        IDEX_mem_Rt_data <= 32'b0;
        IDEX_mem_Rd_addr <= 5'b0;
        IDEX_mem_Rt_addr <= 5'b0;
        IDEX_mem_signext <= 32'b0;
        IDEX_mem_WB <= 2'b0;
        IDEX_mem_M <= 3'b0;
        IDEX_mem_EX <= 4'b0;
    end
    else if (!test_normal_out) begin
        IDEX_mem_Rs_data <= Rs_data;
        IDEX_mem_Rt_data <= Rt_data;
        IDEX_mem_Rd_addr <= IFID_mem_Instruction[15:11];
        IDEX_mem_Rt_addr <= IFID_mem_Instruction[20:16];
        IDEX_mem_signext <= signext_imm;
        IDEX_mem_WB <= {MemtoReg, Reg_w};
        IDEX_mem_M <= {MemRead, MemWrite, branch};
        IDEX_mem_EX <= {ALU_Op, ALUSrc, RegDst};
    end
    else begin
        IDEX_mem_Rs_data <= 32'b0;
        IDEX_mem_Rt_data <= 32'b0;
        IDEX_mem_Rd_addr <= 5'b0;
        IDEX_mem_Rt_addr <= 5'b0;
        IDEX_mem_signext <= 32'b0;
        IDEX_mem_WB <= 2'b0;
        IDEX_mem_M <= 3'b0;
        IDEX_mem_EX <= 4'b0;
    end
end

// ----------------------------------------
// EX/MEM
// ----------------------------------------
reg [31:0] EXMEM_mem_ALU_out, EXMEM_mem_Rt_data;
reg [4:0] EXMEM_mem_RdRtaddr;
reg [1:0] EXMEM_mem_WB; // {MemtoReg, Reg_w}
reg [2:0] EXMEM_mem_M; // {MemRead, MemWrite, branch}

always@(posedge clk)begin
    if(!rst_n)begin
        EXMEM_mem_ALU_out <= 32'b0;
        EXMEM_mem_Rt_data <= 32'b0;
        EXMEM_mem_RdRtaddr <= 5'b0;
        EXMEM_mem_WB <= 2'b0;
        EXMEM_mem_M <= 3'b0;
    end
    else if (!test_normal_out) begin
        EXMEM_mem_ALU_out <= ALU_out;
        EXMEM_mem_Rt_data <= IDEX_mem_Rt_data;
        EXMEM_mem_RdRtaddr <= (IDEX_mem_EX[0] ? IDEX_mem_Rd_addr : IDEX_mem_Rt_addr);
        EXMEM_mem_WB <= IDEX_mem_WB;
        EXMEM_mem_M <= IDEX_mem_M;
    end
    else begin
        EXMEM_mem_ALU_out <= 32'b0;
        EXMEM_mem_Rt_data <= 32'b0;
        EXMEM_mem_RdRtaddr <= 5'b0;
        EXMEM_mem_WB <= 2'b0;
        EXMEM_mem_M <= 3'b0;
    end
end

// ----------------------------------------
// MEM/WB
// ----------------------------------------
reg [31:0] MEMWB_mem_ALU_out, MEMWB_mem_DM_data;
reg [4:0] MEMWB_mem_RdRtaddr;
reg [1:0] MEMWB_mem_WB; // {MemtoReg, Reg_w}

always@(posedge clk) begin
    if(!rst_n) begin
        MEMWB_mem_ALU_out <= 32'b0;
        MEMWB_mem_DM_data <= 32'b0;
        MEMWB_mem_RdRtaddr <= 5'b0;
        MEMWB_mem_WB <= 2'b0;
    end
    else if (!test_normal_out) begin
        MEMWB_mem_ALU_out <= EXMEM_mem_ALU_out;
        MEMWB_mem_DM_data <= Mem_r_data;
        MEMWB_mem_RdRtaddr <= EXMEM_mem_RdRtaddr;
        MEMWB_mem_WB <= EXMEM_mem_WB;
    end
    else begin
        MEMWB_mem_ALU_out <= 32'b0;
        MEMWB_mem_DM_data <= 32'b0;
        MEMWB_mem_RdRtaddr <= 5'b0;
        MEMWB_mem_WB <= 2'b0;
    end
end

// *******************************************************

Interface u_Interface(
    .ext_addr(ext_addr),
    .ext_data(ext_data),
    .test_normal(test_normal),
    .ext_we(ext_we),
    .mem_sel(mem_sel),
    .mem_out_input(mem_out_input),
    .mem_out(mem_out),
    .ext_addr_output(ext_addr_out),
    .ext_data_output(ext_data_out),
    .test_normal_output(test_normal_out),
    .ext_we_output(ext_we_out),
    .mem_sel_output(mem_sel_out),
    .clk(clk)
);

IM u_IM(
    .Instr_addr(test_normal_out ? ext_addr_out : pc),
    .instr_w_data(ext_data_out),
    .Instruction(Instruction),
    .we(test_normal_out & ext_we_out & (!mem_sel_out)),
    .clk(clk),
    .rst_n(rst_n)
);

Control u_Control(
    .opcode(IFID_mem_Instruction[31:26]),
    .MemtoReg(MemtoReg),
    .Reg_w(Reg_w),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .branch(branch),
    .ALU_Op(ALU_Op),
    .ALUSrc(ALUSrc),
    .RegDst(RegDst)
);

RF u_RF(
    .Rs_addr(IFID_mem_Instruction[25:21]),
    .Rt_addr(IFID_mem_Instruction[20:16]),
    .Rd_addr(MEMWB_mem_RdRtaddr),
    .Rd_data(MEMWB_mem_WB[1] ? MEMWB_mem_DM_data : MEMWB_mem_ALU_out),
    .clk(clk),
    .rst_n(rst_n),
    .we(MEMWB_mem_WB[0]),
    .Rs_data(Rs_data),
    .Rt_data(Rt_data)
);

ALU u_ALU(
    .Rs_data(IDEX_mem_Rs_data),
    .Rt_data(IDEX_mem_EX[1] ? IDEX_mem_signext : IDEX_mem_Rt_data),
    .Shamt(IDEX_mem_signext[10:6]),
    .Funct(Funct),
    .ALU_out(ALU_out)
);

ALU_Control u_ALU_Control(
    .Funct_ctrl(IDEX_mem_signext[5:0]),
    .ALU_Op(IDEX_mem_EX[3:2]),
    .Funct(Funct)
);

DM u_DM(
    .Mem_addr(test_normal_out ? ext_addr_out : EXMEM_mem_ALU_out),
    .Mem_w_data(test_normal_out ? ext_data_out : EXMEM_mem_Rt_data),
    .we(test_normal_out ? (ext_we_out & mem_sel_out) : EXMEM_mem_M[1]),
    .re(test_normal_out ? 1'b1: EXMEM_mem_M[2]),
    .clk(clk),
    .rst_n(rst_n),
    .Mem_r_data(Mem_r_data)
);



endmodule
