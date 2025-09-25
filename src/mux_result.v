module mux_result (
    input [31:0] ALUResult, ReadData, PCPlus4,
    input [1:0] ResultSrc,
    output [31:0] Result
  );

  assign Result = ResultSrc[1] ? PCPlus4 : (ResultSrc[0] ? ReadData : ALUResult);

endmodule
