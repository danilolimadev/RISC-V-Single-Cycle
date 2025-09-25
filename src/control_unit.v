`timescale 1ns / 1ps

module control_unit (
    input [6:0] op,
    input [2:0] funct3,
    input       funct7,
    input       Zero,
    output reg        PCSrc,
    output reg  [1:0] ResultSrc,
    output reg        MemWrite,
    output reg  [3:0] ALUControl,
    output reg        ALUSrc,
    output reg  [1:0] ImmSrc,
    output reg        RegWrite
  );

  wire [1:0] ALUop;
  wire branch;

  wire [3:0] ALUControl_internal;
  wire [1:0] ResultSrc_internal;
  wire MemWrite_internal;
  wire ALUSrc_internal;
  wire RegWrite_internal;
  wire [1:0] ImmSrc_internal;

  assign PCSrc = branch & Zero;

  main_decoder main_dec(
                 .op(op),
                 .ResultSrc(ResultSrc_internal),
                 .MemWrite(MemWrite_internal),
                 .Branch(branch),
                 .ALUSrc(ALUSrc_internal),
                 .RegWrite(RegWrite_internal),
                 .ImmSrc(ImmSrc_internal),
                 .ALUop(ALUop));

  ALU_decoder alu_dec(
                .opb5(op[5]),
                .funct3(funct3),
                .funct7b5(funct7),
                .ALUOp(ALUop),
                .ALUControl(ALUControl_internal) );

  // Atribuição do valor de controle
  always @(*)
  begin
    ALUControl = ALUControl_internal;
    ResultSrc = ResultSrc_internal;
    MemWrite = MemWrite_internal;
    ALUSrc = ALUSrc_internal;
    RegWrite = RegWrite_internal;
    ImmSrc = ImmSrc_internal;
  end

endmodule
