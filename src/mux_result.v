module mux_result (
    input [31:0] ALUResult,
    input [31:0] ReadData,
    input ResultSrc,
    output [31:0] Result
  );

  assign Result = ResultSrc ? ReadData : ALUResult;

endmodule
