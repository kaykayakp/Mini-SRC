module alu(
    input wire[31:0]A, B,
    input wire[4:0] select,
    output reg[31:0]C,
    output reg[63:0]C_wide
);

always @(*) begin
    C=32'd0;
    C_wide=63'd0;
        case(select)
            5'b00000: C = A + B; // ADD
            5'b00001: C = A - B; // SUB
            5'b00010: C = A & B; // AND
            5'b00011: C = A | B; // OR
            5'b00100: C = A << B; // SHIFT LEFT
            5'b00111: C = A >> B; // SHIFT RIGHT
            5'b00101: C = ~A;    // NOT
           default: C = 32'd0;
        endcase
end

endmodule