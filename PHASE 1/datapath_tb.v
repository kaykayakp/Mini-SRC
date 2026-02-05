// and datapath_tb.v file
`timescale 1ns/10ps
`default_nettype none

module datapath_tb;

  // clock + reset
  reg clock;
  reg clear;

  // datapath control signals 
  reg R0in,R1in,R2in,R3in,R4in,R5in,R6in,R7in,R8in,R9in,R10in,R11in,R12in,R13in,R14in,R15in;
  reg HIin, LOin, Zhighin, Zlowin, PCin, MDRin, In_Portin, Coutin, Read, IRin, MARin, Yin, Zin;
  reg R0out,R1out,R2out,R3out,R4out,R5out,R6out,R7out,R8out,R9out,R10out,R11out,R12out,R13out,R14out,R15out;
  reg HIout, LOout, Zhighout, Zlowout, PCout, MDRout, In_Portout, Coutout;

  reg IncPC;

  // ALU + memory input
  reg  [4:0]  ALU_Control;
  reg  [31:0] Mdatain;

  // output
  wire [31:0] Out_Portout;

  // state machine
  parameter Default   = 4'b0000,
            Reg_load1a= 4'b0001,
            Reg_load1b= 4'b0010,
            Reg_load2a= 4'b0011,
            Reg_load2b= 4'b0100,
            T0        = 4'b0111,
            T1        = 4'b1000,
            T2        = 4'b1001,
            T3        = 4'b1010,
            T4        = 4'b1011,
            T5        = 4'b1100;

  reg [3:0] Present_state = Default;

  // DUT 
  datapath DUT(
    clock, clear,
    R0in,R1in,R2in,R3in,R4in,R5in,R6in,R7in,R8in,R9in,R10in,R11in,R12in,R13in,R14in,R15in,
    HIin,LOin,Zhighin,Zlowin,PCin,MDRin,In_Portin,Coutin,Read,IRin,MARin,Yin,Zin,
    R0out,R1out,R2out,R3out,R4out,R5out,R6out,R7out,R8out,R9out,R10out,R11out,R12out,R13out,R14out,R15out,
    HIout,LOout,Zhighout,Zlowout,PCout,MDRout,In_Portout,Coutout,
    IncPC, Mdatain, ALU_Control, Out_Portout
  );

  // clock
  initial begin
    clock = 1'b0;
    forever #10 clock = ~clock;
  end

  // reset pulse
  initial begin
    clear = 1'b1;
    #5 clear = 1'b0;
  end

  always @(posedge clock) begin
    case (Present_state)
      Default:    Present_state <= Reg_load1a;
      Reg_load1a: Present_state <= Reg_load1b;
      Reg_load1b: Present_state <= Reg_load2a;
      Reg_load2a: Present_state <= Reg_load2b;
      Reg_load2b: Present_state <= T0;
      T0:         Present_state <= T1;
      T1:         Present_state <= T2;
      T2:         Present_state <= T3;
      T3:         Present_state <= T4;
      T4:         Present_state <= T5;
      T5:         Present_state <= T5;   
      default:    Present_state <= Default;
    endcase
  end

  always @(Present_state) begin
    // default ALL signals low each state
    {R0in,R1in,R2in,R3in,R4in,R5in,R6in,R7in,R8in,R9in,R10in,R11in,R12in,R13in,R14in,R15in} = 16'b0;
    {R0out,R1out,R2out,R3out,R4out,R5out,R6out,R7out,R8out,R9out,R10out,R11out,R12out,R13out,R14out,R15out} = 16'b0;

    HIin=0; LOin=0; Zhighin=0; Zlowin=0; PCin=0; MDRin=0; In_Portin=0; Coutin=0; Read=0; IRin=0; MARin=0; Yin=0; Zin=0;
    HIout=0; LOout=0; Zhighout=0; Zlowout=0; PCout=0; MDRout=0; In_Portout=0; Coutout=0;

    IncPC = 0;
    ALU_Control = 5'b00000;
    Mdatain = 32'h00000000;

    case (Present_state)

      // LOAD R5 = 0x34 
      Reg_load1a: begin
        Mdatain <= 32'h00000034;
        Read    <= 1'b1;
        MDRin   <= 1'b1;
      end
      Reg_load1b: begin
        MDRout <= 1'b1;
        R5in   <= 1'b1;
      end

      // LOAD R6 = 0x45
      Reg_load2a: begin
        Mdatain <= 32'h00000045;
        Read    <= 1'b1;
        MDRin   <= 1'b1;
      end
      Reg_load2b: begin
        MDRout <= 1'b1;
        R6in   <= 1'b1;
      end

      T0: begin
        PCout <= 1'b1;
        MARin <= 1'b1;
        IncPC <= 1'b1;
        Zin   <= 1'b1;
        ALU_Control <= 5'b00000; 
      end

      T1: begin
        Zlowout <= 1'b1;
        PCin    <= 1'b1;
        Read    <= 1'b1;
        MDRin   <= 1'b1;
        Mdatain <= 32'h112B0000; 
      end

      T2: begin
        MDRout <= 1'b1;
        IRin   <= 1'b1;
      end

      T3: begin
        R5out <= 1'b1;
        Yin   <= 1'b1;
      end

      T4: begin
        R6out       <= 1'b1;
        ALU_Control <= 5'b00010; // AND
        Zin         <= 1'b1;
      end

      T5: begin
        Zlowout <= 1'b1;
        R2in    <= 1'b1;
      end

    endcase
  end

  initial begin
    $dumpfile("cpu_waves.vcd");
    $dumpvars(0, datapath_tb);

    $monitor("t=%0t state=%0d R5=%h R6=%h R2(result)=%h",
             $time, Present_state, DUT.R5.q, DUT.R6.q, DUT.R2.q);

    #400 $finish;
  end

endmodule

`default_nettype wire
