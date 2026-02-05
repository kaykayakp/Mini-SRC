`timescale 1ns/1ps
`default_nettype none

module adder (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire        sub,
    output reg  [31:0] Result,
    output reg         Cout
);

    reg  [32:0] LocalCarry;
    reg  [31:0] B_eff;
    integer i;

    always @(*) begin
        // If subtracting, invert B and set carry-in = 1
        B_eff = B ^ {32{sub}};
        LocalCarry = 33'd0;
        LocalCarry[0] = sub;

        for (i = 0; i < 32; i = i + 1) begin
            Result[i] = A[i] ^ B_eff[i] ^ LocalCarry[i];
            LocalCarry[i+1] = (A[i] & B_eff[i]) |
                              (LocalCarry[i] & (A[i] ^ B_eff[i]));
        end

        Cout = LocalCarry[32];
    end

endmodule

`default_nettype wire