module booth(
    input  wire signed [31:0] multiplicand,
    input  wire signed [31:0] multiplier,
    output reg  signed [63:0] product
);
    integer i;
    reg signed [63:0] A;
    reg signed [63:0] M;
    reg        [32:0] Q;   // multiplier plus Q(-1)

    always @(*) begin
        A = 64'sd0;
        M = {{32{multiplicand[31]}}, multiplicand};
        Q = {multiplier, 1'b0};

        for (i = 0; i < 32; i = i + 1) begin
            case (Q[1:0])
                2'b01: A = A + M;
                2'b10: A = A - M;
                default: ;
            endcase
            {A, Q} = $signed({A, Q}) >>> 1;
        end

        product = {A[63:32], Q[32:1]};
    end
endmodule

`default_nettype wire
