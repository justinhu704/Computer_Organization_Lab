module ALU(
    input wire [5:0] Funct,
    input wire [4:0] Shamt,
    input wire [31:0] Rs_data,
    input wire [31:0] Rt_data,
    output reg [31:0] result,
    output reg zero
);

always@(*) begin
    case(Funct)
        6'b001001: begin // add
            result = Rs_data + Rt_data;
            zero = (result == 32'b0);
        end
        6'b001010: begin // sub
            result = Rs_data - Rt_data;
            zero = (result == 32'b0);
        end
        6'b100001: begin // sll
            result = Rt_data << Shamt;
            zero = (result == 32'b0);
        end
        6'b100101: begin // or
            result = Rs_data | Rt_data;
            zero = (result == 32'b0);
        end
        default: begin
            result = 32'd0;  
            zero = (result == 32'b0);
        end
    endcase
end

endmodule