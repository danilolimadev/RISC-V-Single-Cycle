`timescale 1ns / 1ps

module tb_top3;

  // Entradas
  reg CLK, RST;

  // Saídas
  wire [31:0] PC;
  wire [31:0] Instr;
  wire [31:0] Result;
  wire [31:0] ALUResult;
  wire [31:0] RD;
  wire Zero;
  wire RegWrite;
  wire ALUSrc;
  wire [2:0] ALUControl;
  wire MemWrite;
  wire ResultSrc;
  wire PCSrc;

  integer i;
  integer error_count;

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
    error_count = 0; // Inicializa o contador de erros

    // Inicializa o simulador
    $display("Iniciando Testbench");

    // Inicialize a memória (opcional, se necessário)
    $readmemh("program.hex", uut.instr_mem.rom);  // Pode substituir o caminho conforme necessário

    // Inicializa os registradores
    for (i = 0; i < 32; i = i + 1)
    begin
      uut.reg_file.rf[i] = 32'b0;
    end

    // Monitoramento do PC, Instr e Result
    $monitor("Ciclo: %0d | PC = %h, Instr = %h, ALUResult = %h, Result = %h, RegWrite = %b, ALUSrc = %b, ALUControl = %b, MemWrite = %b, ResultSrc = %b, PCSrc = %b",
      $time/10, uut.PC, uut.Instr, uut.alu_inst.ALUResult, uut.mux_result.Result, uut.ctrl_unit.RegWrite, uut.ctrl_unit.ALUSrc, uut.ctrl_unit.ALUControl, uut.ctrl_unit.MemWrite, uut.ctrl_unit.ResultSrc, uut.ctrl_unit.PCSrc);

    // Simula o ciclo de reset
    #10;
    RST = 1;

    // Ciclos de teste, dependendo do número de instruções no program.hex
    #20; // espera para que o processador execute algumas instruções

    // Verificação de valores esperados
    // Aqui fazemos as comparações automáticas

    // Ciclos de execução
    for (i = 0; i < 32; i = i + 1) begin
      #10; // Espera 10ns para cada ciclo

      // Comparação do PC
      if (uut.PC !== expected_PC(i)) begin
        $display("Erro: PC esperado = %h, PC obtido = %h, no ciclo %0d", expected_PC(i), uut.PC, i);
        error_count = error_count + 1;
      end

      // Comparação da instrução
      if (uut.Instr !== expected_instr(i)) begin
        $display("Erro: Instr esperada = %h, Instr obtida = %h, no ciclo %0d", expected_instr(i), uut.Instr, i);
        error_count = error_count + 1;
      end

      // Comparação do ALUResult
      if (uut.alu_inst.ALUResult !== expected_ALUResult(i)) begin
        $display("Erro: ALUResult esperado = %h, ALUResult obtido = %h, no ciclo %0d", expected_ALUResult(i), uut.alu_inst.ALUResult, i);
        error_count = error_count + 1;
      end

      // Comparação do Resultado final (Result)
      if (uut.mux_result.Result !== expected_Result(i)) begin
        $display("Erro: Result esperado = %h, Result obtido = %h, no ciclo %0d", expected_Result(i), uut.mux_result.Result, i);
        error_count = error_count + 1;
      end

      // Comparação de RegWrite
      if (uut.ctrl_unit.RegWrite !== expected_RegWrite(i)) begin
        $display("Erro: RegWrite esperado = %b, RegWrite obtido = %b, no ciclo %0d", expected_RegWrite(i), uut.ctrl_unit.RegWrite, i);
        error_count = error_count + 1;
      end
    end

    // Finaliza a simulação
    if (error_count == 0) begin
      $display("Simulação concluída com sucesso! Nenhum erro encontrado.");
    end else begin
      $display("Simulação concluída com %d erros.", error_count);
    end
    $stop;
  end

  // Funções para os valores esperados, baseados nas instruções do arquivo "program.hex"

  // Função para valores esperados de PC
  function [31:0] expected_PC;
    input integer cycle;
    begin
      // Preencha conforme a lógica esperada para o PC em cada ciclo
      case (cycle)
        0: expected_PC = 32'h00000000; // Exemplo, você deve calcular com base no seu código
        1: expected_PC = 32'h00000004;
        // Adicione os valores esperados para cada ciclo
        default: expected_PC = 32'hxxxxxxxx;
      endcase
    end
  endfunction

  // Função para valores esperados de Instr
  function [31:0] expected_instr;
    input integer cycle;
    begin
      // Preencha conforme as instruções no arquivo program.hex
      case (cycle)
        0: expected_instr = 32'h00100113; // Exemplo de instrução (ADDI)
        1: expected_instr = 32'h00030333; // Exemplo de instrução (ADD)
        // Adicione os valores esperados para cada ciclo
        default: expected_instr = 32'hxxxxxxxx;
      endcase
    end
  endfunction

  // Função para valores esperados de ALUResult
  function [31:0] expected_ALUResult;
    input integer cycle;
    begin
      // Preencha com o resultado esperado da ALU para cada ciclo
      case (cycle)
        0: expected_ALUResult = 32'h00000000; // Exemplo de ALUResult
        1: expected_ALUResult = 32'h00000004;
        // Adicione os valores esperados para cada ciclo
        default: expected_ALUResult = 32'hxxxxxxxx;
      endcase
    end
  endfunction

  // Função para valores esperados de Result
  function [31:0] expected_Result;
    input integer cycle;
    begin
      // Preencha conforme o valor final esperado
      case (cycle)
        0: expected_Result = 32'h00000000;
        1: expected_Result = 32'h00000004;
        // Adicione os valores esperados para cada ciclo
        default: expected_Result = 32'hxxxxxxxx;
      endcase
    end
  endfunction

  // Função para valores esperados de RegWrite
  function [0:0] expected_RegWrite;
    input integer cycle;
    begin
      // Defina se RegWrite deve ser ativado ou não para cada ciclo
      case (cycle)
        0: expected_RegWrite = 1'b1; // Exemplo
        1: expected_RegWrite = 1'b0;
        // Adicione mais valores conforme necessário
        default: expected_RegWrite = 1'bx;
      endcase
    end
  endfunction

endmodule
