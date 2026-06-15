module ALU_Control(
    input wire [1:0] ALU_op,
    input wire [5:0] Funct_ctrl,
    output reg [5:0] Funct
);

always@(*) begin
    Funct = 6'b000000;
    case(ALU_op)
        2'b10: begin
            case(Funct_ctrl)  // only R_Format has to care about funct
                6'b100001: Funct = 6'b001001; // addu
                6'b100011: Funct = 6'b001010; // subu
                6'b000000: Funct = 6'b100001; // sll
                6'b100101: Funct = 6'b100101; // or
                default:   Funct = 6'b000000;
            endcase
        end
        2'b00: begin
            Funct = 6'b001001; // addi
        end
        2'b01: begin
            Funct = 6'b001010; // subi
        end
        2'b11: begin  
            Funct = 6'b100101; // ori
        end
        2'b10: begin
            Funct = 6'b001010; // sub (beq, jump)
        end
        default: begin
            Funct = 6'b000000;
        end
    endcase
end

endmodule