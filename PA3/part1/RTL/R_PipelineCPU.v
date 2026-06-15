module R_PipelineCPU (
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
input wire mem_sel // 0: IM, 1: RF
);

// Interface Instantiation
wire [31:0] ext_addr_out, ext_data_out;
wire test_normal_out, ext_we_out, mem_sel_out;
wire [31:0] mem_out_interface;

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

// IM
wire [31:0] Instr_addr;
assign Instr_addr = test_normal_out ? ext_addr_out : pc;
wire [31:0] Instruction;

// RF
wire [31:0] Rs_data;
wire [31:0] Rt_data;
//assign mem_out_interface = test_normal_out ? Rt_data : 32'b0;
reg [31:0] mem_out_reg1;
reg [31:0] mem_out_reg2;
always @(posedge clk) begin
    if (!rst_n) begin
        mem_out_reg1 <= 32'b0;
        mem_out_reg2 <= 32'b0;
    end
    else begin
        mem_out_reg1 <= test_normal_out ? Rt_data : 32'b0;
        mem_out_reg2 <= mem_out_reg1;
    end
end
assign mem_out_interface = mem_out_reg2;

// Control
wire MemtoReg, Reg_w, MemRead, MemWrite, branch;
wire [1:0] ALU_Op;
wire ALUSrc, RegDst;

// ALU_Control
wire [5:0] Funct;

// ALU
wire [31:0] ALU_out;

//==========
// IF/ID
//==========
reg [31:0] IFID_mem;
always@(posedge clk)begin
    if(!rst_n) begin
        IFID_mem <= 32'b0;
    end
    else if (!test_normal_out) begin
        IFID_mem <= Instruction;
    end
    else begin
        IFID_mem <= 32'b0;
    end
end
//==========
// ID/EX
//==========
reg [31:0] IDEX_mem_Rs_data;
reg [31:0] IDEX_mem_Rt_data;
reg [4:0] IDEX_mem_Rd_addr;
reg [10:0] IDEX_mem_Funct; // {5'b Shamt, 6'b Funct_ctrl}
reg [1:0] IDEX_mem_WB;
reg [2:0] IDEX_mem_M;
reg [3:0] IDEX_mem_EX;

always@(posedge clk)begin
    if(!rst_n)begin
        IDEX_mem_Rs_data <= 32'b0;
        IDEX_mem_Rt_data <= 32'b0;
        IDEX_mem_Rd_addr <= 5'b0;
        IDEX_mem_Funct  <= 11'b0;
        IDEX_mem_WB <= 2'b0;
        IDEX_mem_M <= 3'b0;
        IDEX_mem_EX <= 4'b0;
    end
    else if (!test_normal_out) begin
        IDEX_mem_Rs_data <= Rs_data;
        IDEX_mem_Rt_data <= Rt_data;
        IDEX_mem_Rd_addr <= IFID_mem[15:11];
        IDEX_mem_Funct <= {IFID_mem[10:6], IFID_mem[5:0]};
        IDEX_mem_WB <= {MemtoReg, Reg_w};
        IDEX_mem_M <= {MemRead, MemWrite, branch};
        IDEX_mem_EX <= {ALU_Op, ALUSrc, RegDst};
    end
    else begin
        IDEX_mem_Rs_data <= 32'b0;
        IDEX_mem_Rt_data <= 32'b0;
        IDEX_mem_Rd_addr <= 5'b0;
        IDEX_mem_Funct  <= 11'b0;
        IDEX_mem_WB <= 2'b0;
        IDEX_mem_M <= 3'b0;
        IDEX_mem_EX <= 4'b0;
    end
end

//==========
// EX/MEM
//==========
reg [31:0] EXMEM_mem_ALU_out;
reg [4:0] EXMEM_mem_Rd_addr;
reg [1:0] EXMEM_mem_WB;
reg [2:0] EXMEM_mem_M;
always@(posedge clk)begin
    if(!rst_n)begin
        EXMEM_mem_ALU_out <= 32'b0;
        EXMEM_mem_Rd_addr <= 5'b0;
        EXMEM_mem_WB <= 2'b0;
        EXMEM_mem_M <= 3'b0;
    end
    else if (!test_normal_out) begin
        EXMEM_mem_ALU_out <= ALU_out;
        EXMEM_mem_Rd_addr <= IDEX_mem_Rd_addr;
        EXMEM_mem_WB <= IDEX_mem_WB;
        EXMEM_mem_M <= IDEX_mem_M;
    end
    else begin
        EXMEM_mem_ALU_out <= 32'b0;
        EXMEM_mem_Rd_addr <= 5'b0;
        EXMEM_mem_WB <= 2'b0;
        EXMEM_mem_M <= 3'b0;
    end
end

//==========
// MEM/WB
//==========
reg [31:0] MEMWB_mem_ALU_out;
reg [4:0] MEMWB_mem_Rd_addr;
reg [1:0] MEMWB_mem_WB;
always@(posedge clk)begin
    if(!rst_n)begin
        MEMWB_mem_ALU_out <= 32'b0;
        MEMWB_mem_Rd_addr <= 5'b0;
        MEMWB_mem_WB <= 2'b0;
    end
    else if (!test_normal_out) begin
        MEMWB_mem_ALU_out <= EXMEM_mem_ALU_out;
        MEMWB_mem_Rd_addr <= EXMEM_mem_Rd_addr;
        MEMWB_mem_WB <= EXMEM_mem_WB;
    end
    else begin
        MEMWB_mem_ALU_out <= 32'b0;
        MEMWB_mem_Rd_addr <= 5'b0;
        MEMWB_mem_WB <= 2'b0;
    end
end

//============================================================

Interface u_Interface(
    .ext_addr(ext_addr),
    .ext_data(ext_data),
    .test_normal(test_normal),
    .ext_we(ext_we),
    .mem_sel(mem_sel),
    .mem_out_input(mem_out_interface),
    .mem_out(mem_out),
    .ext_addr_output(ext_addr_out),
    .ext_data_output(ext_data_out),
    .test_normal_output(test_normal_out),
    .ext_we_output(ext_we_out),
    .mem_sel_output(mem_sel_out),
    .clk(clk)
);

Adder u_Adder(
    .pc(pc),
    .next_pc(next_pc)
);

IM u_IM(
    .Instr_addr(Instr_addr),
    .instr_w_data(ext_data_out),
    .Instruction(Instruction),
    .we(test_normal_out & ext_we_out & (!mem_sel_out)),
    .clk(clk),
    .rst_n(rst_n)
);

Control u_Control(
    .opcode(IFID_mem[31:26]),
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
    .Rs_addr(IFID_mem[25:21]),
    .Rt_addr(test_normal_out ? ext_addr_out[4:0] : IFID_mem[20:16]),
    .Rd_addr(test_normal_out ? ext_addr_out[4:0] : MEMWB_mem_Rd_addr),
    .Rd_data(test_normal_out ? ext_data_out[31:0] : MEMWB_mem_ALU_out),
    .clk(clk),
    .rst_n(rst_n),
    .we(test_normal_out ? (mem_sel_out & ext_we_out) : MEMWB_mem_WB[0]),
    .Rs_data(Rs_data),
    .Rt_data(Rt_data)
);

ALU_Control u_ALU_Control(
    .Funct_ctrl(IDEX_mem_Funct[5:0]),
    .ALU_Op(IDEX_mem_EX[3:2]),
    .Funct(Funct)
);

ALU u_ALU(
    .Rs_data(IDEX_mem_Rs_data),
    .Rt_data(IDEX_mem_Rt_data),
    .Shamt(IDEX_mem_Funct[10:6]),
    .Funct(Funct),
    .ALU_out(ALU_out)
);

endmodule