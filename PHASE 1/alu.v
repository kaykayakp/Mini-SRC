module alu(
    input [31:0]A=Y,
    input [31:0]B=BusMuxOut,
    input [4:0] select,
    output [63:0] Z
);
 
    reg [31:0] C;
    reg [63:0] C_wide;
    assign Z = {32'b0, C};   // for now


always @(*) begin
    C=32'd0;
    C_wide=63'd0;
        case(select)
            5'b00000: C = A + B; // ADD
            5'b00001: C = A - B; // SUB
            5'b00010: C = A & B; // AND
            5'b00011: C = A | B; // OR
            5'b00100: C = A >> B; // SHIFT RIGHT
            5'b00101: C = A >>> B; // ARITHMETIC SHIFT RIGHT
            5'b00110: C = A << B; // SHIFT LEFT
            5'b00111: C = A >>> B; // ROTATE RIGHT
            5'b01000: C = A << B; // ROTATE LEFT
            5'b01111: C = ~A;    // NOT
            5'b01110: C = -A; // NEGATE
            default: C = 32'd0;
        endcase
end

endmodule