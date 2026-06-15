module ALU_Control(
    input [5:0] Funct_ctrl,
    input [1:0] ALU_Op,
    output reg [5:0] Funct
);

always @(*) begin
    case(ALU_Op)
        2'b10: // R_type
            case(Funct_ctrl)
                6'b100001: Funct = 6'b001001;
                6'b100011: Funct = 6'b001010;
                6'b000000: Funct = 6'b100001;
                6'b100101: Funct = 6'b100101;
                default: Funct = 6'b000000;
            endcase
        default:
            Funct = 6'b0;
    endcase
end

endmodule