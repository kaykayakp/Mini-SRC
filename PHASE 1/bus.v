module Bus(
    //Mux
    input [31:0] BusMuxIn-R0, 
    input [31:0] BusMuxIn-R1, 
    input [31:0] BusMuxIn-R2, 
    input [31:0] BusMuxIn-R3, 
    input [31:0] BusMuxIn-R4, 
    input [31:0] BusMuxIn-R5, 
    input [31:0] BusMuxIn-R6, 
    input [31:0] BusMuxIn-R7, 
    input [31:0] BusMuxIn-R8, 
    input [31:0] BusMuxIn-R9,
    input [31:0] BusMuxIn-R10, 
    input [31:0] BusMuxIn-R11, 
    input [31:0] BusMuxIn-R12, 
    input [31:0] BusMuxIn-R13, 
    input [31:0] BusMuxIn-R14, 
    input [31:0] BusMuxIn-R15, 
    input [31:0] BusMuxIn-HI, 
    input [31:0] BusMuxIn-LO, 
    input [31:0] BusMuxIn-Zhigh, 
    input [31:0] BusMuxIn-Zlow, 
    input [31:0] BusMuxIn-PC, 
    input [31:0] BusMuxIn-MDR, 
    input [31:0] BusMuxIn_In.port,
    input [31:0] C_sign_extended,  
    //Encoder
    input R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out,
    input R14out, R15out, HIout, LOout, Zhighout, Zlowout, PCout, MDRout, In.Portout, Cout

    output wire [31:0] BusMuxOut
);

reg [31:0]q; 

always @ (*) begin
    if (R0out) q = BusMuxIn_R0;
    else if (R1out) q = BusMuxIn_R1;
    else if (R2out) q = BusMuxIn_R2;
    else if (R3out) q = BusMuxIn_R3;
    else if (R4out) q = BusMuxIn_R4;
    else if (R5out) q = BusMuxIn_R5;
    else if (R6out) q = BusMuxIn_R6;
    else if (R7out) q = BusMuxIn_R7;
    else if (R8out) q = BusMuxIn_R8;
    else if (R9out) q = BusMuxIn_R9;
    else if (R10out) q = BusMuxIn_R10;
    else if (R11out) q = BusMuxIn_R11;
    else if (R12out) q = BusMuxIn_R12;
    else if (R13out) q = BusMuxIn_R13;
    else if (R14out) q = BusMuxIn_R14;
    else if (R15out) q = BusMuxIn_R15;
    else if (HIout) q = BusMuxIn_HI;
    else if (LOout) q = BusMuxIn_LO;
    else if (Zhighout) q = BusMuxIn_Zhigh;
    else if (Zlowout) q = BusMuxIn_Zlow;
    else if (PCout) q = BusMuxIn_PC;
    else if (MDRout) q = BusMuxIn_MDR;
    else if (In_Portout) q = BusMuxIn_In_Port;
    else if (Cout) q = C_sign_extended;
    else q = 32'd0; // Default case 
end
assign BusMuxOut = q;
endmodule
