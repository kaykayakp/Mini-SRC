`timescale 1ns/1ps
`default_nettype none

module alu(
    input  wire [31:0] A,          // BusMuxIn_Y
    input  wire [31:0] B,          // BusMuxOut
    input  wire [4:0]  select,     // ALU_Control
    output wire [31:0] Zlow,        
    output wire [63:0] Zwide        
);

    wire [4:0] shamt = B[4:0];
    //rotate helpers 
    wire [31:0] rol = (shamt == 0) ? A : ((A << shamt) | (A >> (32 - shamt)));
    wire [31:0] ror = (shamt == 0) ? A : ((A >> shamt) | (A << (32 - shamt)));

    //RCA add
    wire [31:0] add_sum;
    wire add_cout;
    rca32 u_add(
        .A(A),
        .B(B),
        .Cin(1'b0),
        .Sum(add_sum),
        .Cout(add_cout)
    );

    //RCA sub
    wire [31:0] sub_sum;
    wire sub_cout;
    rca32 u_sub(
        .A(A),
        .B(~B),
        .Cin(1'b1),
        .Sum(sub_sum),
        .Cout(sub_cout)
    );
	 
	     // MUL / DIV units
    wire [63:0] mul_prod;
    wire [31:0] div_quot, div_rem;

    booth u_mul(
        .multiplicand(A),
        .multiplier(B),
        .product(mul_prod)
    );

    div u_div(
        .dividend(A),
        .divisor(B),
        .quotient(div_quot),
        .remainder(div_rem)
    );

    
    reg [31:0] C;
    reg [63:0] W;

    always @(*) begin
        C = 32'd0;
        W = 64'd0;

        case (select)
            5'b00000: begin C = add_sum; W = {32'd0, add_sum}; end  // ADD
            5'b00001: begin C = sub_sum; W = {32'd0, sub_sum}; end  // SUB
            5'b00010: begin C = A & B;   W = {32'd0, (A & B)}; end  // AND
            5'b00011: begin C = A | B;   W = {32'd0, (A | B)}; end  // OR
            5'b00100: begin C = A >> shamt;           W = {32'd0, C}; end
            5'b00101: begin C = $signed(A) >>> shamt; W = {32'd0, C}; end
            5'b00110: begin C = A << shamt;           W = {32'd0, C}; end
            5'b00111: begin C = ror;                  W = {32'd0, C}; end
            5'b01000: begin C = rol;                  W = {32'd0, C}; end
            5'b01110: begin C = sub_sum; W = {32'd0, C}; end


            // NEW OPCODES:
            5'b01001: begin
                W = mul_prod;           // full 64-bit product
                C = mul_prod[31:0];     // Zlow
            end

            5'b01010: begin
                W = {div_rem, div_quot}; // Zhigh=remainder, Zlow=quotient
                C = div_quot;
            end

            5'b01111: begin C = ~A; W = {32'd0, C}; end           // NOT
            5'b01110: begin C = -A; W = {32'd0, C}; end           // NEG

            default:  begin C = 32'd0; W = 64'd0; end
        endcase
    end

    assign Zlow  = C;
    assign Zwide = W;


endmodule

`default_nettype wire
