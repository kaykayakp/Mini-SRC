module datapath_tb;
    reg clock;
    reg clear;

    // control signals
    reg R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in;
    reg HIin, LOin, Zhighin, Zlowin, PCin, MDRin, In_Portin, Coutin, Read, IRin, MARin, Yin, Zin;
    reg R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out;
    reg HIout, LOout, Zhighout, Zlowout, PCout, MDRout, In_Portout, Coutout;

    reg [3:0]  ALU_Control;
    reg [31:0] Mdatain;

    wire [31:0] Out_Portout;

    reg [4:0] state = 0;

    localparam Default = 5'b00000,
               Reg_load1a = 5'b00001,
               Reg_load1b = 5'b00010,
               Reg_load2a = 5'b00011,
               Reg_load2b = 5'b00100,
               Reg_load3a = 5'b00101,
               Reg_load3b = 5'b00110,
               T0 = 5'b00111,
               T1 = 5'b01000,
               T2 = 5'b01001,
               T3 = 5'b01010,
               T4 = 5'b01011,//11
               T5 = 5'b01100,//12
               T6 = 5'b01101,//13
               T7 = 5'b01110,//14
               T8 = 5'b01111,//15
               T9 = 5'b10000,//16
               T10 = 5'b10001,//17
               T11 = 5'b10010;//18


    // DUT
    datapath DUT(
        clock, clear,
        R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in,
        HIin, LOin, Zhighin, Zlowin, PCin, MDRin, In_Portin, Coutin, Read, IRin, MARin, Yin, Zin,
        R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
        HIout, LOout, Zhighout, Zlowout, PCout, MDRout, In_Portout, Coutout,
        Mdatain, ALU_Control, Out_Portout
    );

    // clock + reset
    initial begin
        clock = 0;
        clear = 1;
        #5 clear = 0;
        forever #10 clock = ~clock;
    end

    // state register
    always @(posedge clock) begin
        case (state)
            Default:    state <= Reg_load1a;
            Reg_load1a: state <= Reg_load1b;
            Reg_load1b: state <= Reg_load2a;
            Reg_load2a: state <= Reg_load2b;
            Reg_load2b: state <= Reg_load3a;
            Reg_load3a: state <= Reg_load3b;
            Reg_load3b: state <= T0;
            T0:state <= T1;
            T1: state <= T2;
            T2: state <= T3;
            T3: state <= T4;
            T4: state <= T5;
            T5: state <= T6;
            T6: state <= T7;
            T7: state <= T8;
            T8: state <= T9;
            T9: state <= T10;
            T10: state <= T11;
            T11: state <= T11;
            default:state <= Default;
        endcase
    end

    always @(*) begin
        // set defaults
        R0in=0; R1in=0; R2in=0; R3in=0; R4in=0; R5in=0; R6in=0; R7in=0;
        R8in=0; R9in=0; R10in=0; R11in=0; R12in=0; R13in=0; R14in=0; R15in=0;

        R0out=0; R1out=0; R2out=0; R3out=0; R4out=0; R5out=0; R6out=0; R7out=0;
        R8out=0; R9out=0; R10out=0; R11out=0; R12out=0; R13out=0; R14out=0; R15out=0;

        HIin=0; LOin=0; Zhighin=0; Zlowin=0; PCin=0; MDRin=0; In_Portin=0; Coutin=0;
        Read=0; IRin=0; MARin=0; Yin=0; Zin=0;

        HIout=0; LOout=0; Zhighout=0; Zlowout=0; PCout=0; MDRout=0; In_Portout=0; Coutout=0;

        ALU_Control = 5'b00000;
        Mdatain     = 32'h00000000;

        case (state)
            // load R2 <= 0x12
            Reg_load1a: begin
                Mdatain = 32'h00000012;
                Read = 1;
                MDRin = 1;
            end
            Reg_load1b: begin
                MDRout = 1;
                R2in = 1;
            end

            // load R3 <= 0x14
            Reg_load2a: begin
                Mdatain = 32'h00000014;
                Read = 1;
                MDRin = 1;
            end
            Reg_load2b: begin
                MDRout = 1;
                R3in = 1;
            end

            // clear R1 <= 0
            Reg_load3a: begin
                Mdatain = 32'h00000000;
                Read = 1;
                MDRin = 1;
            end
            Reg_load3b: begin
                MDRout = 1;
                R1in = 1;
            end

            // “AND R1, R2, R3” 
            T0: begin // PC -> MAR
                PCout = 1;
                MARin = 1;
            end

            T1: begin // mem -> MDR 
                Mdatain = 32'h28918000;
                Read = 1;
                MDRin= 1;
            end

            T2: begin // MDR -> IR
                MDRout = 1;
                IRin = 1;
            end

            T3: begin // R2 -> Y 
                R2out = 1;
                Yin= 1;
            end

            T4: begin // R3 AND Y -> Zlow
                R3out = 1;
                ALU_Control = 5'b00010; // AND (matches your ALU)
                Zin = 1;
            end

            T5: begin // Zlow -> R1 
                Zlowout = 1;
                R1in = 1;
            end

            T6: begin // Zhigh -> R1
                R2out = 1;
                Yin = 1;
            end
            T7: begin
                R3out = 1;
                ALU_Control = 5'b00011; // AND
                Zin = 1;
            end
            T8: begin
                Zlowout = 1;
                R4in = 1;
            end
            T9: begin
                R2out = 1;
                ALU_Control = 5'b00101; // AND
                Zin = 1;
            end
            T10: begin
                Zlowout = 1;
                R5in = 1;
            end
            default: begin
                // keep defaults
            end
        endcase
    end

    initial begin
        $dumpfile("cpu_waves.vcd");
        $dumpvars(0, datapath_tb);

        $monitor("Time:%3d|State:%d|R1:%h|R4(OR):%h|R5(NOT):%h", 
          $time, state, DUT.R1.q, DUT.R4.q, DUT.R5.q);
        #500 $finish;
    end
endmodule
