module datapath(
    input wire clock, clear, 
    //control signals 
    input wire R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in,
    HIin, LOin, Zhighin, Zlowin, PCin, MDRin, In_Portin, Coutin, Read, IRin, MARin, Yin, Zin,
    input wire R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
    HIout, LOout, Zhighout, Zlowout, PCout, MDRout, In_Portout, Cout,
    input wire IncPC,
    input wire [31:0]Mdatain,
    input wire[4:0] ALU_Control,
    output wire [31:0]Out_Portout
); 

    //internal wires
    wire[31:0] BusMuxOut, BusMuxIn_R0, BusMuxIn_R1, BusMuxIn_R2, BusMuxIn_R3, BusMuxIn_R4, BusMuxIn_R5, BusMuxIn_R6, BusMuxIn_R7, BusMuxIn_R8, 
    BusMuxIn_R9, BusMuxIn_R10, BusMuxIn_R11, BusMuxIn_R12, BusMuxIn_R13, BusMuxIn_R14, BusMuxIn_R15,
    BusMuxIn_HI, BusMuxIn_LO, BusMuxIn_Zhigh, BusMuxIn_Zlow, BusMuxIn_PC, BusMuxIn_MDR, BusMuxIn_In_Port, BusMuxIn_Cout,
    BusMuxIn_IR, BusMuxIn_MAR, BusMuxIn_Y, ALU_out;
    wire [31:0] pc_plus1;
    assign pc_plus1 = BusMuxIn_PC + 32'd1;   

    // choose what goes into Z
    wire [31:0] z_in;
    assign z_in = (IncPC) ? pc_plus1 : ALU_out;

    wire[63:0]ALU_out_wide;

    //split the z into lo and hi 
    wire [31:0] zlow_in;
    assign zlow_in = (IncPC) ? pc_plus1 : ALU_out_wide[31:0]; 
    
    wire [31:0] zhigh_in;
    assign zhigh_in = ALU_out_wide[63:32];

    //general purpose registers
    register R0(clear, clock, R0in, BusMuxOut, BusMuxIn_R0);
    register R1(clear, clock, R1in, BusMuxOut, BusMuxIn_R1);
    register R2(clear, clock, R2in, BusMuxOut, BusMuxIn_R2);
    register R3(clear, clock, R3in, BusMuxOut, BusMuxIn_R3);
    register R4(clear, clock, R4in, BusMuxOut, BusMuxIn_R4);
    register R5(clear, clock, R5in, BusMuxOut, BusMuxIn_R5);
    register R6(clear, clock, R6in, BusMuxOut, BusMuxIn_R6);
    register R7(clear, clock, R7in, BusMuxOut, BusMuxIn_R7);
    register R8(clear, clock, R8in, BusMuxOut, BusMuxIn_R8);
    register R9(clear, clock, R9in, BusMuxOut, BusMuxIn_R9);
    register R10(clear, clock, R10in, BusMuxOut, BusMuxIn_R10);
    register R11(clear, clock, R11in, BusMuxOut, BusMuxIn_R11);
    register R12(clear, clock, R12in, BusMuxOut, BusMuxIn_R12);
    register R13(clear, clock, R13in, BusMuxOut, BusMuxIn_R13);
    register R14(clear, clock, R14in, BusMuxOut, BusMuxIn_R14);
    register R15(clear, clock, R15in, BusMuxOut, BusMuxIn_R15);

    //other registers
    register pc(clear, clock, PCin, BusMuxOut, BusMuxIn_PC);
    register ir(clear, clock, IRin, BusMuxOut, BusMuxIn_IR);
    register mar(clear, clock, MARin, BusMuxOut, BusMuxIn_MAR);
    register y(clear, clock, Yin, BusMuxOut, BusMuxIn_Y);
    register z_low(clear, clock, Zin, z_in, BusMuxIn_Zlow);
    register z_high(clear, clock, Zin, zhigh_in, BusMuxIn_Zhigh);
    register hi_reg(clear,clock, HIin, BusMuxOut, BusMuxIn_HI);
    register lo_reg(clear,clock, LOin, BusMuxOut, BusMuxIn_LO);

    //connect MDR unit 
    mdr mdr_unit(clock, clear, MDRin, Read, BusMuxOut, Mdatain, BusMuxIn_MDR);
    //connect ALU unit 
    alu alu_unit(BusMuxIn_Y, BusMuxOut, ALU_Control, ALU_out, ALU_out_wide);

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

