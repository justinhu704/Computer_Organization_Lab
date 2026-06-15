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

always@(*) begin
    case(opcode)
    6'b000000: begin// R-type
        // WB
        MemtoReg = 1'b0;
        Reg_w = 1'b1;
        // M
        MemRead = 1'b0;
        MemWrite = 1'b0;
        branch = 1'b0;
        // EX
        ALU_Op = 2'b10;
        ALUSrc = 1'b0;
        RegDst = 1'b0;
    end
    default: begin
        // WB
        MemtoReg = 1'b0;
        Reg_w = 1'b0;
        // M
        MemRead = 1'b0;
        MemWrite = 1'b0;
        branch = 1'b0;
        // EX
        ALU_Op = 2'b10;
        ALUSrc = 1'b0;
        RegDst = 1'b0;
        end
    endcase
end

endmodule