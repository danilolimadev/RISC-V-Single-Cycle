module extend (
    input [24:0] IN,
    input [1:0] ImmSrc,
    output [31:0] ImmExt
  );

  reg [31:0] ImmExtReg;

  always@(*)
  case(ImmSrc)
    //I-type
    2'b00:
      ImmExtReg = {{20{IN[24]}},IN[24:13]};
    //S-type(stores)
    2'b01:
      ImmExtReg = {{20{IN[24]}},IN[24:18],IN[4:0]};
    //B-type(branches)
    2'b10:
      ImmExtReg = {{20{IN[24]}},IN[0],IN[23:18],IN[4:1],1'b0};
    //J-type(jal)
    2'b11:
      ImmExtReg = {{12{IN[24]}},IN[12:5],IN[13],IN[23:14],1'b0};
    default:
      ImmExtReg = 32'bx; //undefined
  endcase

  assign ImmExt = ImmExtReg;

endmodule
