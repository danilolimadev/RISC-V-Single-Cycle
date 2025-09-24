`timescale 1ns / 1ps

//ALU commands
`define ALU_ADD     3'b000
`define ALU_OR      3'b001
`define ALU_SRL     3'b010
`define ALU_SLTU    3'b011
`define ALU_SUB     3'b100

// instruction opcode
`define RVOP_ADDI   7'b0010011
`define RVOP_BEQ    7'b1100011
`define RVOP_LUI    7'b0110111
`define RVOP_BNE    7'b1100011
`define RVOP_ADD    7'b0110011
`define RVOP_OR     7'b0110011
`define RVOP_SRL    7'b0110011
`define RVOP_SLTU   7'b0110011
`define RVOP_SUB    7'b0110011

// instruction funct3
`define RVF3_ADDI   3'b000
`define RVF3_BEQ    3'b000
`define RVF3_BNE    3'b001
`define RVF3_ADD    3'b000
`define RVF3_OR     3'b110
`define RVF3_SRL    3'b101
`define RVF3_SLTU   3'b011
`define RVF3_SUB    3'b000
`define RVF3_ANY    3'b???

// instruction funct7
`define RVF7_ADD    7'b0000000
`define RVF7_OR     7'b0000000
`define RVF7_SRL    7'b0000000
`define RVF7_SLTU   7'b0000000
`define RVF7_SUB    7'b0100000
`define RVF7_ANY    7'b???????

module control_unit (
    input CLK,
    input RST,
    input [6:0] op,
    input [2:0] funct3,
    input [6:0] funct7,
    input       Zero,
    output reg  PCSrc,
    output reg  ResultSrc, //é o wdsrc??
    output reg  MemWrite, //ñ usado
    output reg  [2:0] ALUControl,
    output reg  ALUSrc,
    output reg  [1:0] ImmSrc,
    output reg  RegWrite
  );

  reg branch;
  reg condZero;
  assign PCSrc = branch & (Zero == condZero);

  always @ (posedge CLK or negedge RST)
  begin
    if (!RST)
    begin
      branch   = 1'b0;
    end
    else
    begin
      branch      = 1'b0;
      condZero    = 1'b0;
      RegWrite    = 1'b0;
      ALUSrc      = 1'b0;
      ResultSrc   = 1'b0;
      ALUControl  = `ALU_ADD;

      casez( {funct7, funct3, op} )
        { `RVF7_ADD,  `RVF3_ADD,  `RVOP_ADD  } :
        begin
          RegWrite = 1'b1;
          ALUControl = `ALU_ADD;
          ImmSrc = 2'b00;
        end
        { `RVF7_OR,   `RVF3_OR,   `RVOP_OR   } :
        begin
          RegWrite = 1'b1;
          ALUControl = `ALU_OR;
        end
        { `RVF7_SRL,  `RVF3_SRL,  `RVOP_SRL  } :
        begin
          RegWrite = 1'b1;
          ALUControl = `ALU_SRL;
        end
        { `RVF7_SLTU, `RVF3_SLTU, `RVOP_SLTU } :
        begin
          RegWrite = 1'b1;
          ALUControl = `ALU_SLTU;
        end
        { `RVF7_SUB,  `RVF3_SUB,  `RVOP_SUB  } :
        begin
          RegWrite = 1'b1;
          ALUControl = `ALU_SUB;
        end

        { `RVF7_ANY,  `RVF3_ADDI, `RVOP_ADDI } :
        begin
          RegWrite = 1'b1;
          ALUSrc = 1'b1;
          ALUControl = `ALU_ADD;
          ImmSrc = 2'b00; // I-type
        end
        { `RVF7_ANY,  `RVF3_ANY,  `RVOP_LUI  } :
        begin
          RegWrite = 1'b1;
          //wdSrc  = 1'b1;
          ResultSrc = 1'b1;
          ImmSrc = 2'b00; // U-type normalmente não passa pelo extend
        end

        { `RVF7_ANY,  `RVF3_BEQ,  `RVOP_BEQ  } :
        begin
          branch = 1'b1;
          condZero = 1'b1;
          ALUControl = `ALU_SUB;
          ImmSrc = 2'b10; // B-type
        end
        { `RVF7_ANY,  `RVF3_BNE,  `RVOP_BNE  } :
        begin
          branch = 1'b1;
          ALUControl = `ALU_SUB;
          ImmSrc = 2'b10; // B-type
        end
        { `RVF7_ANY, `RVF3_SW, `RVOP_SW } :
        begin
          ALUSrc    = 1'b1;       // imediato é usado como offset
          MemWrite  = 1'b1;       // ativa escrita na memória
          ALUControl = `ALU_ADD;  // endereço = base + offset
          ImmSrc    = 2'b01;      // S-type para SW
        end
        default:
        begin
          branch     = 1'b0;
          condZero   = 1'b0;
          RegWrite   = 1'b0;
          ALUSrc     = 1'b0;
          ResultSrc  = 1'b0;
          ALUControl = `ALU_ADD;
          ImmSrc     = 2'b00;
        end
      endcase
    end
  end
endmodule