module ram(
    input wire clk, 
    input wire read, 
    input wire write, 
    input wire[8:0] address, 
    input wire[31:0] data_in,
    output reg[31:0] data_out
);
    reg[31:0] memory[0:511]; // 512 x 32-bit memory
    always @(posedge clk) begin
        if (write) begin
            memory[address] <= data_in;
        end
        if (read) begin
            data_out <= memory[address];
        end
    end
endmodule