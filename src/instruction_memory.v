module instruction_memory (
    input CLK,
    input RST,
    input [31:0] A,
    output reg [31:0] Instr
  );

  reg [31:0] rom [63:0];
  //assign Instr = rom [A];

  always @ (posedge CLK or negedge RST)
  begin
    if(!RST)
    begin
      Instr = 0;
    end
    else
    begin
      Instr = rom[A[31:2]];
    end
  end

  initial
  begin
    $readmemh ("program.hex", rom);
  end

endmodule