module data_memory (
    input CLK,
    input WE,
    input [31:0] A,
    input [31:0] WD,
    output [31:0] RD
  );

  reg [31:0] ram[63:0];
  assign RD = ram[A[31:2]];

  initial
  begin
    ram[32'h00_00_00_00]  = 32'hFACEFACE;
    ram[1]  = 32'h00000002;
    ram[2]  = 32'h00000003;
    ram[63] = 32'h000000063;  // Should be replaced by FACE
  end

  always @(posedge CLK)
    if (WE)
      ram[A[31:2]] = WD;

endmodule