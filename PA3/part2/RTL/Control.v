module Control(
    input [5:0] opcode,
    // WB
    output reg MemtoReg,
    output reg Reg_w,
    // M
    output reg MemRead,
    output reg MemWrite,
    output reg branch,
    // EX
    output reg [1:0] ALU_Op,
    output reg ALUSrc,
    output reg RegDst
);

always@(*)begin
    case(opcode)
        6'b000000: begin// R_type
            MemtoReg = 1'b0;
            Reg_w = 1'b1;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            branch = 1'b0;
            ALU_Op = 2'b10;
            ALUSrc = 1'b0;
            RegDst = 1'b1;
        end
        6'b001001: begin// addi
            MemtoReg = 1'b0;
            Reg_w = 1'b1;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            branch = 1'b0;
            ALU_Op = 2'b00;
            ALUSrc = 1'b1;
            RegDst = 1'b0;
        end
        6'b101011: begin// sw
            MemtoReg = 1'b0;
            Reg_w = 1'b0;
            MemRead = 1'b0;
            MemWrite = 1'b1;
            branch = 1'b0;
            ALU_Op = 2'b00;
            ALUSrc = 1'b1;
            RegDst = 1'b0;
        end
        6'b100011: begin// lw
            MemtoReg = 1'b1;
            Reg_w = 1'b1;
            MemRead = 1'b1;
            MemWrite = 1'b0;
            branch = 1'b0;
            ALU_Op = 2'b00;
            ALUSrc = 1'b1;
            RegDst = 1'b0;
        end
        6'b001101: begin// ori
            MemtoReg = 1'b0;
            Reg_w = 1'b1;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            branch = 1'b0;
            ALU_Op = 2'b11;
            ALUSrc = 1'b1;
            RegDst = 1'b0;
        end
        default: begin
            MemtoReg = 1'b0;
            Reg_w = 1'b0;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            branch = 1'b0;
            ALU_Op = 2'b10;
            ALUSrc = 1'b0;
            RegDst = 1'b0;
        end
    endcase
end

endmodule