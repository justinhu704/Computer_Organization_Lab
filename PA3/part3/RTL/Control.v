module Control(
    input [5:0] opcode,
    // Control Signal
    output reg [8:0] Control_sig
);

// Control_sig {MemtoReg, Reg_w, MemRead, MemWrite, branch, ALU_Op[1], ALU_Op[0], ALUSrc, RegDst}
always@(*)begin
    case(opcode)
        6'b000000: begin// R_type
            Control_sig = 9'b010001001;
        end
        6'b001001: begin// addi
            Control_sig = 9'b010000010;
        end
        6'b101011: begin// sw
            Control_sig = 9'b000100010;
        end
        6'b100011: begin// lw
            Control_sig = 9'b111000010;
        end
        6'b001101: begin// ori
            Control_sig = 9'b010001110;
        end
        default: begin
            Control_sig = 9'b000000000;
        end
    endcase
end

endmodule