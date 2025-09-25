module top (
    input CLK,
    input RST
  );

  //Unidade de Controle
  wire [6:0] op;
  wire [2:0] funct3;
  wire funct7;
  wire PCSrc;
  wire [1:0] ResultSrc;
  wire MemWrite;
  wire [3:0] ALUControl;
  wire ALUSrc;
  wire [1:0] ImmSrc;
  wire RegWrite;

  //PC
  wire [31:0] PCPlus4;
  wire [31:0] PCTarget;
  wire [31:0] PCNext;
  wire [31:0] PC;

  //Instrução
  wire [31:0] Instr;
  assign op = Instr [6:0];
  assign funct3 = Instr [14:12];
  assign funct7 = Instr [30];
  wire [4:0] A1;
  wire [4:0] A2;
  wire [4:0] A3;
  assign A1 = Instr [19:15];
  assign A2 = Instr [24:20];
  assign A3 = Instr [11:7];
  wire [25:0] IN;
  assign IN = Instr [31:7];

  //Registrador
  wire [31:0] RD1;
  wire [31:0] RD2;

  //Mux ALU
  wire [31:0] SrcB;

  //ALU
  wire Zero;
  wire [31:0] ALUResult;

  //Memória
  wire [31:0] RD;

  //Mux Resultado
  wire [31:0] Result;

  //Extend
  wire [31:0] ImmExt;

  control_unit ctrl_unit (
                 .op(op),
                 .funct3(funct3),
                 .funct7(funct7),
                 .Zero(Zero),
                 .PCSrc(PCSrc),
                 .ResultSrc(ResultSrc),
                 .MemWrite(MemWrite),
                 .ALUControl(ALUControl),
                 .ALUSrc(ALUSrc),
                 .ImmSrc(ImmSrc),
                 .RegWrite(RegWrite)
               );

  mux_pc mpc (
           .PCPlus4(PCPlus4),
           .PCTarget(PCTarget),
           .PCSrc(PCSrc),
           .PCNext(PCNext)
         );

  pc pc_inst (
       .CLK(CLK),
       .RST(RST),
       .PCNext(PCNext),
       .PC(PC)
     );

  instruction_memory instr_mem (
                       .CLK(CLK),
                       .RST(RST),
                       .A(PC),
                       .Instr(Instr)
                     );

  register_file reg_file (
                  .CLK(CLK),
                  .RST(RST),
                  .A1(A1),
                  .A2(A2),
                  .A3(A3),
                  .WE3(RegWrite),
                  .WD3(Result),
                  .RD1(RD1),
                  .RD2(RD2)
                );

  mux_alu malu (
            .WD(RD2),
            .ImmExt(ImmExt),
            .ALUSrc(ALUSrc),
            .SrcB(SrcB)
          );

  alu alu_inst (
        .ALUControl(ALUControl),
        .SrcA(RD1),
        .SrcB(SrcB),
        .Zero(Zero),
        .ALUResult(ALUResult)
      );

  data_memory data_mem (
                .CLK(CLK),
                .WE(MemWrite),
                .A(ALUResult),
                .WD(RD2),
                .RD(RD)
              );

  mux_result mresult (
               .ALUResult(ALUResult),
               .ReadData(RD),
               .PCPlus4(PCPlus4),
               .ResultSrc(ResultSrc),
               .Result(Result)
             );

  pc_plus_4 pc4 (
              .PC(PC),
              .PCPlus4(PCPlus4)
            );

  extend ext (
           .IN(IN),
           .ImmSrc(ImmSrc),
           .ImmExt(ImmExt)
         );

  pc_target pct (
              .PC(PC),
              .ImmExt(ImmExt),
              .PCTarget(PCTarget)
            );

endmodule
