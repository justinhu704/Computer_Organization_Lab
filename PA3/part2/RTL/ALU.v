module ALU(
    input [31:0] Rs_data,
    input [31:0] Rt_data,
    input [4:0] Shamt,
    input [5:0] Funct,
    output reg [31:0] ALU_out
);

always @(*) begin
    case(Funct)
        6'b001001: ALU_out = Rs_data + Rt_data; 
        6'b001010: ALU_out = Rs_data - Rt_data;
        6'b100001: ALU_out = Rt_data << Shamt;
        6'b100101: ALU_out = Rs_data | Rt_data;
        default: ALU_out = 32'b0;
    endcase
end

endmodule