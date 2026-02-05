`timescale 1ns/10ps

module Bus(
    //Mux
    input [31:0] BusMuxIn_R0, 
    input [31:0] BusMuxIn_R1, 
    input [31:0] BusMuxIn_R2, 
    input [31:0] BusMuxIn_R3, 
    input [31:0] BusMuxIn_R4, 
    input [31:0] BusMuxIn_R5, 
    input [31:0] BusMuxIn_R6, 
    input [31:0] BusMuxIn_R7, 
    input [31:0] BusMuxIn_R8, 
    input [31:0] BusMuxIn_R9,
    input [31:0] BusMuxIn_R10, 
    input [31:0] BusMuxIn_R11, 
    input [31:0] BusMuxIn_R12, 
    input [31:0] BusMuxIn_R13, 
    input [31:0] BusMuxIn_R14, 
    input [31:0] BusMuxIn_R15, 
    input [31:0] BusMuxIn_HI, 
    input [31:0] BusMuxIn_LO, 
    input [31:0] BusMuxIn_Zhigh, 
    input [31:0] BusMuxIn_Zlow, 
    input [31:0] BusMuxIn_PC, 
    input [31:0] BusMuxIn_MDR, 
    input [31:0] BusMuxIn_In_Port,
    input [31:0] C_sign_extended,  
    //Encoder
    input wire R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out,
    input wire R14out, R15out, HIout, LOout, Zhighout, Zlowout, PCout, MDRout, In_Portout, Cout,

    output wire [31:0] BusMuxOut
);

//32 to 5 encoder 
    reg [4:0]Select; 

    always @ (*) begin
        if (R0out) Select = 5'd0;
        else if (R1out) Select = 5'd1;
        else if (R2out) Select = 5'd2;
        else if (R3out) Select = 5'd3;
        else if (R4out) Select = 5'd4;
        else if (R5out) Select = 5'd5;
        else if (R6out) Select = 5'd6;
        else if (R7out) Select = 5'd7;
        else if (R8out) Select = 5'd8;
        else if (R9out) Select = 5'd9;
        else if (R10out) Select = 5'd10;
        else if (R11out) Select = 5'd11;
        else if (R12out) Select = 5'd12;
        else if (R13out) Select = 5'd13;
        else if (R14out) Select = 5'd14;
        else if (R15out) Select = 5'd15;
        else if (HIout) Select = 5'd16;
        else if (LOout) Select = 5'd17;
        else if (Zhighout) Select = 5'd18;
        else if (Zlowout) Select = 5'd19;
        else if (PCout) Select = 5'd20;
        else if (MDRout) Select = 5'd21;
        else if (In_Portout) Select = 5'd22;
        else if (Cout) Select = 5'd23;
        else Select = 5'd31; //default to 0
    end

//32:1 multiplexer
    reg[31:0] mux_out;
    always @(*) begin
        case(Select)
            5'd0: mux_out = BusMuxIn_R0;
            5'd1: mux_out = BusMuxIn_R1;
            5'd2: mux_out = BusMuxIn_R2;
            5'd3: mux_out = BusMuxIn_R3;
            5'd4: mux_out = BusMuxIn_R4;
            5'd5: mux_out = BusMuxIn_R5;
            5'd6: mux_out = BusMuxIn_R6;
            5'd7: mux_out = BusMuxIn_R7;
            5'd8: mux_out = BusMuxIn_R8;
            5'd9: mux_out = BusMuxIn_R9;
            5'd10: mux_out = BusMuxIn_R10;
            5'd11: mux_out = BusMuxIn_R11;
            5'd12: mux_out = BusMuxIn_R12;
            5'd13: mux_out = BusMuxIn_R13;
            5'd14: mux_out = BusMuxIn_R14;
            5'd15: mux_out = BusMuxIn_R15;
            5'd16: mux_out = BusMuxIn_HI;
            5'd17: mux_out = BusMuxIn_LO;
            5'd18: mux_out = BusMuxIn_Zhigh;
            5'd19: mux_out = BusMuxIn_Zlow;
            5'd20: mux_out = BusMuxIn_PC;
            5'd21: mux_out = BusMuxIn_MDR;
            5'd22: mux_out = BusMuxIn_In_Port;
            5'd23: mux_out = C_sign_extended;
            default: mux_out = 32'd0;
        endcase
    end

    assign BusMuxOut = mux_out;
endmodule
