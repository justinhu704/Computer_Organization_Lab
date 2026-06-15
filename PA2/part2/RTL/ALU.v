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
        6'b001001: begin 
            result = Rs_data + Rt_data;   // add
        end
        6'b001010: begin 
            result = Rs_data - Rt_data;   // sub
        end
        6'b100001: begin 
            result = Rt_data << Shamt;     // sll
        end
        6'b100101: begin 
            result = Rs_data | Rt_data;   // or
        end
        default: begin
            result = 32'd0;     
        end
    endcase
end

endmodule