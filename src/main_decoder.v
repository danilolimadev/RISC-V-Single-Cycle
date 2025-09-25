module main_decoder(
    input wire [6:0] op,
    output reg [1:0] ResultSrc,
    output reg       MemWrite, Branch,ALUSrc, RegWrite,
    output reg [1:0] ImmSrc, ALUop
  );

  reg [10:0] control_signals;

  always@(*)
  case(op)
    //RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_Branch_ALUop
    7'b0000011:
      control_signals = 11'b1_00_1_0_01_0_00;//lw
    7'b0100011:
      control_signals = 11'b0_01_1_1_00_0_00;//sw
    7'b0110011:
      control_signals = 11'b1_xx_0_0_00_0_10;//R-type
    7'b0010011:
      control_signals = 11'b1_00_1_0_00_0_10;//I-typr ALU
    7'b1100011:
      control_signals = 11'b0_10_0_0_00_1_01;//beq
    7'b1100011:
      control_signals = 11'b0_10_0_0_00_1_01;//B-type Branch
    7'b1101111:
      control_signals = 11'b1_11_0_0_10_0_00;//jal
    7'b1100111:
      control_signals = 11'b1_00_1_0_10_0_00;//jalr
    7'b0110111:
      control_signals = 11'b1_00_1_0_00_0_11;//U-type lui
    7'b0010111:
      control_signals = 11'b1_00_1_0_00_0_01;//U-type AUIPC
    7'b0000000:
      control_signals = 11'b0_00_0_0_00_0_00;//reset conditionm

    default:
      control_signals = 11'bx_xx_x_x_xx_x_xx;
  endcase

  assign {RegWrite,ImmSrc,ALUSrc,MemWrite,
          ResultSrc,Branch,ALUop} = control_signals;

endmodule
