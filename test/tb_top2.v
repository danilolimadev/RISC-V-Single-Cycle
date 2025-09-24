module tb_top;

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
    for (int i = 0; i < 32; i = i + 1)
    begin
      uut.reg_file.rf[i] = 32'b0;
    end

    // Monitoramento
    $monitor("Ciclo = %d | PC = %h | Instr = %h | RD1 = %h | RD2 = %h | ALUResult = %h | Zero = %b | Result = %h",
             $time, uut.PC, Instr, RD1, RD2, ALUResult, Zero, Result);

    // Reseta o processador
    #10;
    RST = 1;
    #10;

    // Executar a simulação
    // Defina os valores esperados para cada ciclo baseado no seu `program.hex`
    // Abaixo, o código fará algumas verificações para o primeiro ciclo, como exemplo.

    // Teste ciclo 1 (por exemplo, instrução ADDI)
    expected_PC = 32'h00000004;
    expected_RD1 = 32'b0;  // Registrador 0 deve ter valor 0
    expected_RD2 = 32'b0;  // Registrador 0 deve ter valor 0
    expected_ALUResult = 32'h00000001;  // Resultados esperados da ALU
    expected_Zero = 1'b0;
    #20;  // Aguarda 1 ciclo
    verificar;

    // Teste ciclo 2 (por exemplo, instrução SUBI)
    expected_PC = 32'h00000008;
    expected_RD1 = 32'h00000001;  // Registrador 1
    expected_RD2 = 32'b0;         // Registrador 2
    expected_ALUResult = 32'hFFFFFFFE;  // Resultado esperado
    expected_Zero = 1'b0;
    #20;
    verificar;

    // Mais ciclos podem ser verificados dessa forma com os valores esperados para cada um.
    // Continue a simulação por ciclos suficientes para cobrir todas as instruções em `program.hex`.
    
    // Simule por 200 ns ou até que todas as instruções sejam executadas
    #200;
    $stop;  // Pare a simulação
  end

  // Tarefa de verificação de valores
  task verificar;
    begin
      // Verificar se os valores atuais correspondem aos valores esperados
      if (uut.PC !== expected_PC) begin
        $display("Erro no PC: Esperado %h, mas obteve %h", expected_PC, uut.PC);
      end

      if (uut.reg_file.rf[1] !== expected_RD1) begin
        $display("Erro no RD1: Esperado %h, mas obteve %h", expected_RD1, uut.reg_file.rf[1]);
      end

      if (uut.reg_file.rf[2] !== expected_RD2) begin
        $display("Erro no RD2: Esperado %h, mas obteve %h", expected_RD2, uut.reg_file.rf[2]);
      end

      if (uut.alu_inst.ALUResult !== expected_ALUResult) begin
        $display("Erro no ALUResult: Esperado %h, mas obteve %h", expected_ALUResult, uut.alu_inst.ALUResult);
      end

      if (uut.alu_inst.Zero !== expected_Zero) begin
        $display("Erro no Zero: Esperado %b, mas obteve %b", expected_Zero, uut.alu_inst.Zero);
      end

      // Você pode adicionar mais verificações para outros sinais, como o Result final.
    end
  endtask

endmodule
