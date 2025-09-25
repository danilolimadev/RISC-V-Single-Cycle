`timescale 1ns / 1ps

module tb_top2;

  // Entradas
  reg CLK, RST;

  // Saídas
  wire [31:0] PC;
  wire [31:0] RD1, RD2;   // Registradores
  wire [31:0] ALUResult;   // Resultado da ALU
  wire Zero;               // Flag Zero da ALU
  wire [31:0] Instr;      // Instrução
  wire [31:0] Result;     // Resultado final

  // Variáveis para comparação
  reg [31:0] expected_PC;
  reg [31:0] expected_RD1, expected_RD2;
  reg [31:0] expected_ALUResult;
  reg expected_Zero;

  integer i;

  // Instancia o módulo top
  top uut (
        .CLK(CLK),
        .RST(RST)
      );

  // Gerador de clock
  initial
  begin
    CLK = 0;
    forever
      #5 CLK = ~CLK;  // Clock de 10ns
  end

  // Bloco de inicialização
  initial
  begin
    RST = 0;
    // Inicializa o simulador
    $display("Iniciando Testbench");

    // Inicializa o programa na memória
    $readmemh("program.hex", uut.instr_mem.rom);  // Carrega o programa

    // Inicializa os registradores
    for (i = 0; i < 32; i = i + 1)
    begin
      uut.reg_file.rf[i] = 32'b0;
    end

    // Monitoramento
    $monitor("Ciclo = %d | PC = %h | Instr = %h | RD1 = %h | RD2 = %h | ALUResult = %h | Zero = %b | Result = %h",
             $time, uut.PC, Instr, RD1, RD2, ALUResult, Zero, Result);

    // Reseta o processador
    #10;
    RST = 1;
    #5;

    // Executar a simulação
    // Teste ciclos com os valores esperados para cada instrução do seu programa.

    // Teste ciclo 1: LUI
    expected_PC = 32'h00000004;
    expected_RD1 = 32'b0;  // Registrador 0 deve ter valor 0
    expected_RD2 = 32'b0;  // Registrador 0 deve ter valor 0
    expected_ALUResult = 32'h12345000;  // LUI x1, 0x12345
    expected_Zero = 1'b0;
    #10;  
    verificar;

    // Teste ciclo 2: ADDI
    expected_PC = 32'h00000008;
    expected_RD1 = 32'h12345000;  // Registrador 1 deve ter valor 0x12345000
    expected_RD2 = 32'b0;         // Registrador 2 deve ser 0
    expected_ALUResult = 32'h12345005;  // ADDI x2, x1, 5 -> 0x12345000 + 5
    expected_Zero = 1'b0;
    #10;
    verificar;

    // Teste ciclo 3: ADD
    expected_PC = 32'h0000000C;
    expected_RD1 = 32'h12345000;  // x1
    expected_RD2 = 32'h12345005;  // x2
    expected_ALUResult = 32'h12345005 + 32'h12345005;  // ADD x3, x1, x2
    expected_Zero = 1'b0;
    #10;
    verificar;

    // Teste ciclo 4: SUB
    expected_PC = 32'h00000010;
    expected_RD1 = 32'h12345010;  // x3
    expected_RD2 = 32'h12345005;  // x2
    expected_ALUResult = 32'h12345010 - 32'h12345005;  // SUB x4, x3, x2
    expected_Zero = 1'b0;
    #10;
    verificar;

    // Teste ciclo 5: OR
    expected_PC = 32'h00000014;
    expected_RD1 = 32'h12345000;  // x1
    expected_RD2 = 32'h12345005;  // x2
    expected_ALUResult = 32'h12345000 | 32'h12345005;  // OR x5, x1, x2
    expected_Zero = 1'b0;
    #10;
    verificar;

    // Teste ciclo 6: SRL
    expected_PC = 32'h00000018;
    expected_RD1 = 32'h12345000;  // x1
    expected_RD2 = 32'h12345005;  // x2
    expected_ALUResult = 32'h12345000 >> 5;  // SRL x6, x5, x2
    expected_Zero = 1'b0;
    #10;
    verificar;

    // Teste ciclo 7: SLTU
    expected_PC = 32'h0000001C;
    expected_RD1 = 32'h12345005;  // x2
    expected_RD2 = 32'h12345010;  // x3
    expected_ALUResult = 32'b0;  // SLTU x7, x2, x3 (0x12345005 < 0x12345010)
    expected_Zero = 1'b0;
    #10;
    verificar;

    // Teste ciclo 8: BEQ
    expected_PC = 32'h00000020;
    expected_RD1 = 32'h12345005;  // x2
    expected_RD2 = 32'h12345005;  // x2 (igual)
    expected_ALUResult = 32'b0;  // BEQ x2, x2, +4 (zero -> branch)
    expected_Zero = 1'b1;
    #10;
    verificar;

    // Teste ciclo 9: BNE
    expected_PC = 32'h00000024;
    expected_RD1 = 32'h12345005;  // x2
    expected_RD2 = 32'h12345010;  // x3 (diferente)
    expected_ALUResult = 32'b0;  // BNE x2, x3, +4 (não zero -> branch)
    expected_Zero = 1'b0;
    #10;
    verificar;

    // Simule por mais alguns ciclos para garantir que todas as instruções foram executadas corretamente.
    #10;
    $stop;  // Pare a simulação
  end

  // Tarefa de verificação de valores
  task verificar;
    begin
      // Verificar se os valores atuais correspondem aos valores esperados
      if (uut.PC !== expected_PC)
      begin
        $display("Erro no PC: Esperado %h, mas obteve %h", expected_PC, uut.PC);
      end else begin
        $display("PC Correto: Esperado e obteve %h", uut.PC);
      end

      if (uut.reg_file.rf[1] !== expected_RD1)
      begin
        $display("Erro no RD1: Esperado %h, mas obteve %h", expected_RD1, uut.reg_file.rf[1]);
      end else begin
        $display("RD1 Correto: Esperado e obteve %h", uut.reg_file.rf[1]);
      end

      if (uut.reg_file.rf[2] !== expected_RD2)
      begin
        $display("Erro no RD2: Esperado %h, mas obteve %h", expected_RD2, uut.reg_file.rf[2]);
      end else begin
        $display("RD2 Correto: Esperado e obteve %h", uut.reg_file.rf[2]);
      end

      if (uut.alu_inst.ALUResult !== expected_ALUResult)
      begin
        $display("Erro no ALUResult: Esperado %h, mas obteve %h", expected_ALUResult, uut.alu_inst.ALUResult);
      end else begin
        $display("ALUResult Correto: Esperado e obteve %h", uut.alu_inst.ALUResult);
      end

      if (uut.alu_inst.Zero !== expected_Zero)
      begin
        $display("Erro no Zero: Esperado %b, mas obteve %b", expected_Zero, uut.alu_inst.Zero);
      end else begin
        $display("Zero Correto: Esperado e obteve %h", uut.alu_inst.Zero);
      end
    end
  endtask

endmodule
