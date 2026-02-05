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

    
    reg [31:0] C;

    always @(*) begin
        C = 32'd0;
        case (select)
            5'b00000: C = add_sum;                 // ADD (RCA)
            5'b00001: C = sub_sum;                 // SUB (RCA)
            5'b00010: C = A & B;                   // AND
            5'b00011: C = A | B;                   // OR
            5'b00100: C = A >> shamt;              // SHR logical
            5'b00101: C = $signed(A) >>> shamt;    // SHR arithmetic
            5'b00110: C = A << shamt;              // SHL
            5'b00111: C = ror;                     // ROTATE RIGHT  
            5'b01000: C = rol;                     // ROTATE LEFT   (
            5'b01111: C = ~A;                      // NOT
            5'b01110: C = sub_sum;                 // NEGATE 
            default:  C = 32'd0;
        endcase
    end

    assign Zlow  = C;
    assign Zwide = {32'b0, C};   

endmodule

`default_nettype wire

