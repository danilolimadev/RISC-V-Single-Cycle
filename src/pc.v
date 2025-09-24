module pc (
    input CLK,
    input RST,
    input [31:0] PCNext,
    output [31:0] PC
  );

  reg [31:0] PCReg;

  initial
  begin
    PCReg = 32'h00000000;
  end

  always@(posedge CLK or negedge RST)
  begin
    if(!RST)
    begin
      PCReg = 0;
    end
    else
    begin
      PCReg = PCNext;
    end
  end

  assign PC = PCReg;

endmodule