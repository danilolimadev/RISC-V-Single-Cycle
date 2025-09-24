module mux_pc (
    input [31:0] PCPlus4,
    input [31:0] PCTarget,
    input PCSrc,
    output [31:0] PCNext
  );

  assign PCNext = PCSrc ? PCTarget : PCPlus4;

endmodule