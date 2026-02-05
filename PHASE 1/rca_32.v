`timescale 1ns/1ps
`default_nettype none

module rca32(
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire        Cin,
    output wire [31:0] Sum,
    output wire        Cout
);
    wire [32:0] c;
    assign c[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : FA_CHAIN
            full_adder fa(
                .a   (A[i]),
                .b   (B[i]),
                .cin (c[i]),
                .sum (Sum[i]),
                .cout(c[i+1])
            );
        end
    endgenerate

    assign Cout = c[32];

endmodule

`default_nettype wire
