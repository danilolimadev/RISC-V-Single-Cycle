module alu (
    input [3:0] ALUControl,
    input [31:0] SrcA,
    input [31:0] SrcB,
    output Zero,
    output reg [31:0] ALUResult
  );

  always @ (*)
  begin
    case (ALUControl)
      4'b0000:
        ALUResult = SrcA + SrcB;
      4'b0001:
        ALUResult = SrcA | SrcB;
      4'b0010:
        ALUResult = SrcA >> SrcB [4:0];
      4'b0011:
        ALUResult = (SrcA < SrcB) ? 1 : 0;
      4'b0100:
        ALUResult = SrcA - SrcB;
      default   :
        ALUResult = SrcA + SrcB;
    endcase
  end

  assign Zero = (ALUResult == 0);

endmodule