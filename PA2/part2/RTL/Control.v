module Control(
    input wire [5:0] OpCode,
    output reg Reg_dst,
    output reg Reg_w,
    output reg [1:0] output_ALU_op,
    output reg ALU_src,
    output reg Mem_w,
    output reg Mem_r,
    output reg Mem_to_reg
);

always@(*) begin
    Reg_dst = 1'b0;
    Reg_w = 1'b0;
    output_ALU_op = 2'b00;
    ALU_src = 1'b0;
    Mem_w = 1'b0;
    Mem_r = 1'b0;
    Mem_to_reg = 1'b0;
    case(OpCode)
        6'b000000: begin // R_Format
            Reg_dst = 1'b1;
            Reg_w = 1'b1;
            output_ALU_op = 2'b10;
            ALU_src = 1'b0;
            Mem_w = 1'b0;
            Mem_r = 1'b0;
            Mem_to_reg = 1'b0;
        end
        6'b100011: begin // lw
            Reg_dst = 1'b0;
            Reg_w = 1'b1;
            output_ALU_op = 2'b00;
            ALU_src = 1'b1;
            Mem_w = 1'b0;
            Mem_r = 1'b1;
            Mem_to_reg = 1'b1;
        end
        6'b101011: begin // sw
            Reg_dst = 1'b0;
            Reg_w = 1'b0;
            output_ALU_op = 2'b00;
            ALU_src = 1'b1;
            Mem_w = 1'b1;
            Mem_r = 1'b0;
            Mem_to_reg = 1'b0;
        end
        6'b001001: begin // addi
            Reg_dst = 1'b0;
            Reg_w = 1'b1;
            output_ALU_op = 2'b00;
            ALU_src = 1'b1;
            Mem_w = 1'b0;
            Mem_r = 1'b0;
            Mem_to_reg = 1'b0;
        end
        6'b001010: begin // subi
            Reg_dst = 1'b0;
            Reg_w = 1'b1;
            output_ALU_op = 2'b01;
            ALU_src = 1'b1;
            Mem_w = 1'b0;
            Mem_r = 1'b0;
            Mem_to_reg = 1'b0;
        end
        6'b001101: begin // ori
            Reg_dst = 1'b0;
            Reg_w = 1'b1;
            output_ALU_op = 2'b11;
            ALU_src = 1'b1;
            Mem_w = 1'b0;
            Mem_r = 1'b0;
            Mem_to_reg = 1'b0;
        end
    endcase
end

endmodule