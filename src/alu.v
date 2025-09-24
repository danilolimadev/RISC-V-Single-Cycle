module alu (
    input CLK,
    input [2:0] ALUControl,
    input [31:0] SrcA,
    input [31:0] SrcB,
    output Zero,
    output reg [31:0] ALUResult
  );

  always @ (posedge CLK)
  begin
    case (ALUControl)
      3'b000:
        ALUResult = SrcA + SrcB;
      3'b001:
        ALUResult = SrcA | SrcB;
      3'b010:
        ALUResult = SrcA >> SrcB [4:0];
      3'b011:
        ALUResult = (SrcA < SrcB) ? 1 : 0;
      3'b100:
        ALUResult = SrcA - SrcB;
      default   :
        ALUResult = SrcA + SrcB;
    endcase
  end

  assign Zero = (ALUResult == 0);

endmodule