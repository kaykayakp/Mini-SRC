`timescale 1ns/1ps
`default_nettype none

module div(
    input  wire signed [31:0] dividend,
    input  wire signed [31:0] divisor,
    output reg  signed [31:0] quotient,
    output reg  signed [31:0] remainder
);
    integer i;

    reg sign_q, sign_r;
    reg [31:0] u_dividend, u_divisor;
    reg [63:0] rem;
    reg [31:0] quot;

    always @(*) begin
        if (divisor == 0) begin
            quotient  = 32'sd0;
            remainder = dividend;
        end else begin
            sign_q = dividend[31] ^ divisor[31];
            sign_r = dividend[31];

            u_dividend = dividend[31] ? (~dividend + 1'b1) : dividend;
            u_divisor  = divisor[31]  ? (~divisor  + 1'b1) : divisor;

            rem  = 64'd0;
            quot = 32'd0;

            for (i = 31; i >= 0; i = i - 1) begin
                rem = (rem << 1);
                rem[0] = u_dividend[i];

                if (rem[31:0] >= u_divisor) begin
                    rem[31:0] = rem[31:0] - u_divisor;
                    quot[i] = 1'b1;
                end
            end

            quotient  = sign_q ? -$signed(quot) : $signed(quot);
            remainder = sign_r ? -$signed(rem[31:0]) : $signed(rem[31:0]);
        end
    end
endmodule

`default_nettype wire