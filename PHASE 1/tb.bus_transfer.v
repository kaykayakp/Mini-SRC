`timescale 1ns/1ps

module tb;

  reg clock = 0;
  reg clear = 0;

  // Bus control (only using R0out and R1out for this demo)
  reg R0out = 0, R1out = 0;
  reg R2out = 0, R3out = 0, R4out = 0, R5out = 0, R6out = 0, R7out = 0, R8out = 0, R9out = 0;
  reg R10out = 0, R11out = 0, R12out = 0, R13out = 0, R14out = 0, R15out = 0;
  reg HIout = 0, LOout = 0, Zhighout = 0, Zlowout = 0, PCout = 0, MDRout = 0, In_Portout = 0, Cout = 0;

  // Register enables (only 2 regs for this demo)
  reg R0in = 0, R1in = 0;

  // Wires for reg outputs -> bus inputs
  wire [31:0] R0_q, R1_q;
  wire [31:0] BusMuxOut;

  // Constant / immediate input (optional)
  wire [31:0] C_sign_extended = 32'hDEAD_BEEF;

  // Instantiate two registers
  register #(32,32,32'h0000_0000) R0 (.clear(clear), .clock(clock), .enable(R0in), .BusMuxOut(BusMuxOut), .BusMuxIn(R0_q));
  register #(32,32,32'h0000_0000) R1 (.clear(clear), .clock(clock), .enable(R1in), .BusMuxOut(BusMuxOut), .BusMuxIn(R1_q));

  // Instantiate bus (tie unused inputs to 0 for now)
  Bus bus(
    .BusMuxIn_R0(R0_q),
    .BusMuxIn_R1(R1_q),
    .BusMuxIn_R2(32'b0), .BusMuxIn_R3(32'b0), .BusMuxIn_R4(32'b0), .BusMuxIn_R5(32'b0),
    .BusMuxIn_R6(32'b0), .BusMuxIn_R7(32'b0), .BusMuxIn_R8(32'b0), .BusMuxIn_R9(32'b0),
    .BusMuxIn_R10(32'b0), .BusMuxIn_R11(32'b0), .BusMuxIn_R12(32'b0), .BusMuxIn_R13(32'b0),
    .BusMuxIn_R14(32'b0), .BusMuxIn_R15(32'b0),
    .BusMuxIn_HI(32'b0), .BusMuxIn_LO(32'b0),
    .BusMuxIn_Zhigh(32'b0), .BusMuxIn_Zlow(32'b0),
    .BusMuxIn_PC(32'b0), .BusMuxIn_MDR(32'b0),
    .BusMuxIn_In_Port(32'b0),
    .C_sign_extended(C_sign_extended),

    .R0out(R0out), .R1out(R1out), .R2out(R2out), .R3out(R3out), .R4out(R4out), .R5out(R5out),
    .R6out(R6out), .R7out(R7out), .R8out(R8out), .R9out(R9out),
    .R10out(R10out), .R11out(R11out), .R12out(R12out), .R13out(R13out), .R14out(R14out), .R15out(R15out),
    .HIout(HIout), .LOout(LOout), .Zhighout(Zhighout), .Zlowout(Zlowout), .PCout(PCout), .MDRout(MDRout),
    .In_Portout(In_Portout), .Cout(Cout),

    .BusMuxOut(BusMuxOut)
  );

  // Clock: 10ns period
  always #5 clock = ~clock;

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb);

    // 1) Clear registers
    clear = 1;
    #12;
    clear = 0;

    // 2) Load R0 with a known constant via the bus using Cout
    Cout = 1;     // select C_sign_extended onto bus
    R0in = 1;     // load R0 on next clock edge
    @(posedge clock);
    R0in = 0;
    Cout = 0;

    // 3) Transfer R0 -> R1 using the bus
    R0out = 1;    // drive R0 onto bus
    R1in  = 1;    // load R1 on next clock edge
    @(posedge clock);
    R1in  = 0;
    R0out = 0;

    // 4) Check result
    if (R1_q !== 32'hDEAD_BEEF) begin
      $display("FAIL: R1 = %h (expected DEAD_BEEF)", R1_q);
    end else begin
      $display("PASS: R0->R1 transfer worked. R1 = %h", R1_q);
    end

    #20;
    $finish;
  end

endmodule
