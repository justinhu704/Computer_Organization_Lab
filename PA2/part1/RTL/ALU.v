module ALU(
    input wire [5:0] Funct,
    input wire [4:0] Shamt,
    input wire [31:0] Rs_data,
    input wire [31:0] Rt_data,
    output reg [31:0] result
);

always@(*) begin
    result = 32'd0;
    case(Funct)
        6'b001001: result = Rs_data + Rt_data;
        6'b001010: result = Rs_data - Rt_data;
        6'b100001: result = Rt_data << Shamt;
        6'b100101: result = Rs_data | Rt_data;
        default:   result = 32'd0;     
    endcase
end

endmodule