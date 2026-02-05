`timescale 1ns/1ps
`default_nettype none

module adder(
  input  [31:0] A, B,
  input sub,        // 0 = add, 1 = subtract
  output reg [31:0] Result,
  output reg Cout
);

  reg [32:0] c;
  reg [31:0] Bx;
  integer i;

  always @(*) begin
    c  = 33'd0;
    c[0] = sub;

    for (i = 0; i < 32; i = i + 1) begin
      Result[i] = A[i] ^ Bx[i] ^ c[i];
      c[i+1] = (A[i] & Bx[i]) | (c[i] & (A[i] | Bx[i]));
    end

    Cout = c[32];
  end
endmodule
