module mux_alu (
    input [31:0] WD,
    input [31:0] ImmExt,
    input ALUSrc,
    output [31:0] SrcB
  );

  assign SrcB = ALUSrc ? ImmExt : WD;

endmodule