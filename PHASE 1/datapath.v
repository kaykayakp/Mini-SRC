module datapath(
    input wire clock, clear, 
    //control signals 
    input wire R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in,
    HIin, LOin, Zhighin, Zlowin, PCin, MDRin, In_Portin, Coutin, Read, IRin, MARin, Yin, Zin,
    input wire R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
    HIout, LOout, Zhighout, Zlowout, PCout, MDRout, In_Portout, Cout,
    input wire [31:0]Mdatain,
    output wire [31:0]Out_Portout 
); 

    //internal wires
    wire[31:0] BusMuxOut, BusMuxIn_R0, BusMuxIn_R1, BusMuxIn_R2, BusMuxIn_R3, BusMuxIn_R4, BusMuxIn_R5, BusMuxIn_R6, BusMuxIn_R7, BusMuxIn_R8, 
    BusMuxIn_R9, BusMuxIn_R10, BusMuxIn_R11, BusMuxIn_R12, BusMuxIn_R13, BusMuxIn_R14, BusMuxIn_R15,
    BusMuxIn_HI, BusMuxIn_LO, BusMuxIn_Zhigh, BusMuxIn_Zlow, BusMuxIn_PC, BusMuxIn_MDR, BusMuxIn_In_Port, BusMuxIn_Cout,
    BusMuxIn_IR, BusMuxIn_MAR, BusMuxIn_Y, BusMuxIn_Zlow;

    //general purpose registers
    register R0(clock, clear, R0in, BusMuxOut, BusMuxIn_R0);
    register R1(clock, clear, R1in, BusMuxOut, BusMuxIn_R1);
    register R2(clock, clear, R2in, BusMuxOut, BusMuxIn_R2);
    register R3(clock, clear, R3in, BusMuxOut, BusMuxIn_R3);
    register R4(clock, clear, R4in, BusMuxOut, BusMuxIn_R4);
    register R5(clock, clear, R5in, BusMuxOut, BusMuxIn_R5);
    register R6(clock, clear, R6in, BusMuxOut, BusMuxIn_R6);
    register R7(clock, clear, R7in, BusMuxOut, BusMuxIn_R7);
    register R8(clock, clear, R8in, BusMuxOut, BusMuxIn_R8);
    register R9(clock, clear, R9in, BusMuxOut, BusMuxIn_R9);
    register R10(clock, clear, R10in, BusMuxOut, BusMuxIn_R10);
    register R11(clock, clear, R11in, BusMuxOut, BusMuxIn_R11);
    register R12(clock, clear, R12in, BusMuxOut, BusMuxIn_R12);
    register R13(clock, clear, R13in, BusMuxOut, BusMuxIn_R13);
    register R14(clock, clear, R14in, BusMuxOut, BusMuxIn_R14);
    register R15(clock, clear, R15in, BusMuxOut, BusMuxIn_R15);

    //other registers
    register pc(clock, clear, PCin, BusMuxOut, BusMuxIn_PC);
    register ir(clock, clear, IRin, BusMuxOut, BusMuxIn_IR);
    register mar(clock, clear, MARin, BusMuxOut, BusMuxIn_MAR);
    register y(clock, clear, Yin, BusMuxOut, BusMuxIn_Y);
    register z_low(clock, clear, Zin, BusMuxOut, BusMuxIn_Zlow);

    //connect MDR unit 
    MDR mdr(clear, clock, MDRin, Read, BusMuxOut, Mdatain, BusMuxIn_MDR);

    Bus bus(
        //Mux inputs
        BusMuxIn_R0, BusMuxIn_R1, BusMuxIn_R2, BusMuxIn_R3, BusMuxIn_R4, BusMuxIn_R5, BusMuxIn_R6, BusMuxIn_R7,
        BusMuxIn_R8, BusMuxIn_R9, BusMuxIn_R10, BusMuxIn_R11, BusMuxIn_R12, BusMuxIn_R13, BusMuxIn_R14, BusMuxIn_R15,
        BusMuxIn_HI, BusMuxIn_LO, BusMuxIn_Zhigh, BusMuxIn_Zlow, BusMuxIn_PC, BusMuxIn_MDR, BusMuxIn_In_Port,
        BusMuxIn_Cout,
        //Encoder inputs
        R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out,
        R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
        HIout, LOout, Zhighout, Zlowout, PCout, MDRout, In_Portout,
        Cout,
        //Bus output
        BusMuxOut
    );

    assign Out_Portout = BusMuxIn_R0;

endmodule

