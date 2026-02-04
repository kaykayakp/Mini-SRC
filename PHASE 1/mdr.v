module mdr(
    input wire clock, 
    input wire clear,
    input wire MDRin,
    input wire Read,            
    input wire [31:0] BusMuxOut,
    input wire [31:0] Mdatain,  
    output [31:0] BusMuxIn_MDR        
);
    reg [31:0]q;

    always @(posedge clock) begin
        if (clear) begin
            q <= 32'b0;
        end
        else if(MDRin) begin 
            if (Read)
                q <= Mdatain;        // load from memory
            else 
                q<= BusMuxOut;     // load from bus
        end
    end 

    //connect storage to output port 
    assign BusMuxIn_MDR = q;


endmodule