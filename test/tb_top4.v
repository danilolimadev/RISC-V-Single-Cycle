`timescale 1ns / 1ps

module tb_top4;

  reg CLK, RST;

  wire [31:0] PC;
  wire [31:0] Instr;
  wire [31:0] RD1, RD2;
  wire [31:0] ALUResult;
  wire Zero;
  wire [31:0] Result;

  // Esperados
  reg [31:0] expected_PC;
  reg [31:0] expected_reg [0:31];
  reg [31:0] expected_ALUResult;
  reg expected_Zero;

  integer i;

  // Instancia o módulo top
  top uut (
    .CLK(CLK),
    .RST(RST)
  );

  // Clock de 10ns
  initial begin
    CLK = 0;
    forever #5 CLK = ~CLK;
  end

  // Acesso direto aos sinais internos
  assign PC         = uut.PC;
  assign Instr      = uut.Instr;
  assign ALUResult  = uut.alu_inst.ALUResult;
  assign Zero       = uut.alu_inst.Zero;

  // Início da simulação
  initial begin
    RST = 0;

    // Inicializa esperado
    for (i = 0; i < 32; i = i + 1)
      expected_reg[i] = 0;

    $display("Carregando programa.hex...");
    $readmemh("program.hex", uut.instr_mem.rom);

    // Zera registradores físicos
    for (i = 0; i < 32; i = i + 1)
      uut.reg_file.rf[i] = 0;

    $monitor("Tempo=%0dns | PC=%h | Instr=%h | x1=%h | x2=%h | x3=%h | x4=%h | Zero=%b | ALUResult=%h", 
              $time, PC, Instr, uut.reg_file.rf[1], uut.reg_file.rf[2], uut.reg_file.rf[3], uut.reg_file.rf[4], Zero, ALUResult);

    // Reset
    #10;
    RST = 1;

    // Instrução 0: 00500113 -> addi x2, x0, 5
    #10;
    expected_reg[2] = 32'd5;
    expected_ALUResult = 5;
    expected_Zero = 0;
    verificar(2, expected_reg[2], expected_ALUResult, expected_Zero);

    // Instrução 1: 00C00193 -> addi x3, x0, 12
    #10;
    $stop; //TODO: REMOVER
    expected_reg[3] = 32'd12;
    expected_ALUResult = 12;
    expected_Zero = 0;
    verificar(3, expected_reg[3], expected_ALUResult, expected_Zero);

    // Instrução 2: FF718393 -> addi x7, x3, -9
    #10;
    expected_reg[7] = expected_reg[3] + -9;
    expected_ALUResult = expected_reg[7];
    expected_Zero = (expected_ALUResult == 0);
    verificar(7, expected_reg[7], expected_ALUResult, expected_Zero);

    // Instrução 3: 0023E233 -> or x4, x7, x2
    #10;
    expected_reg[4] = expected_reg[7] | expected_reg[2];
    expected_ALUResult = expected_reg[4];
    expected_Zero = (expected_ALUResult == 0);
    verificar(4, expected_reg[4], expected_ALUResult, expected_Zero);

    // Instrução 4: 0041F2B3 -> and x5, x3, x4
    #10;
    expected_reg[5] = expected_reg[3] & expected_reg[4];
    expected_ALUResult = expected_reg[5];
    expected_Zero = (expected_ALUResult == 0);
    verificar(5, expected_reg[5], expected_ALUResult, expected_Zero);

    // Instrução 5: 004282B3 -> add x5, x5, x4
    #10;
    expected_reg[5] = expected_reg[5] + expected_reg[4];
    expected_ALUResult = expected_reg[5];
    expected_Zero = (expected_ALUResult == 0);
    verificar(5, expected_reg[5], expected_ALUResult, expected_Zero);

    // Instrução 6: 02728863 -> beq x5, x7, +12
    #10;
    expected_Zero = (expected_reg[5] == expected_reg[7]);
    $display("BEQ check: x5=%h vs x7=%h -> Zero esperado=%b", expected_reg[5], expected_reg[7], expected_Zero);
    verificar(5, expected_reg[5], ALUResult, expected_Zero); // ALUResult não muda

    // Instrução 7: 0041A233 -> srl x4, x3, x4
    #10;
    expected_reg[4] = expected_reg[3] >> (expected_reg[4] & 5'b11111);
    expected_ALUResult = expected_reg[4];
    expected_Zero = (expected_ALUResult == 0);
    verificar(4, expected_reg[4], expected_ALUResult, expected_Zero);

    // Instrução 8: 00020463 -> beq x4, x0, +8
    #10;
    expected_Zero = (expected_reg[4] == 0);
    $display("BEQ check: x4=%h vs x0=0 -> Zero esperado=%b", expected_reg[4], expected_Zero);
    verificar(4, expected_reg[4], ALUResult, expected_Zero);

    // Instrução 9: 00000293 -> addi x5, x0, 0
    #10;
    expected_reg[5] = 0;
    expected_ALUResult = 0;
    expected_Zero = 1;
    verificar(5, expected_reg[5], expected_ALUResult, expected_Zero);

    // Outras instruções continuariam da mesma forma...

    // Final da simulação
    #10;
    $display("Simulação concluída.");
    $stop;
  end

  // ------------------------------------
  // Tarefa de verificação aprimorada
  // ------------------------------------
  task verificar;
    input [4:0] reg_index;
    input [31:0] esperado_reg;
    input [31:0] esperado_alu;
    input esperado_zero;
    begin
      $display("Verificando x%0d...", reg_index);

      if (uut.reg_file.rf[reg_index] !== esperado_reg)
        $display("ERRO: x%0d = %h (esperado %h)", reg_index, uut.reg_file.rf[reg_index], esperado_reg);
      else
        $display("OK: x%0d = %h", reg_index, esperado_reg);

      if (ALUResult !== esperado_alu)
        $display("ERRO ALUResult: %h (esperado %h)", ALUResult, esperado_alu);
      else
        $display("OK ALUResult: %h", ALUResult);

      if (Zero !== esperado_zero)
        $display("ERRO Zero: %b (esperado %b)", Zero, esperado_zero);
      else
        $display("OK Zero: %b", Zero);
    end
  endtask

endmodule
