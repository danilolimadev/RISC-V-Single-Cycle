`timescale 1ns / 1ps

module tb_top;

  // Entradas
  reg CLK, RST;

  // Saídas
  wire [31:0] PC;

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

    // Inicialize a memória (opcional, se necessário)
    $readmemh("program.hex", uut.instr_mem.rom);  // Pode substituir o caminho conforme necessário

    for (i = 0; i < 32; i = i + 1)
    begin
      uut.reg_file.rf[i] = 32'b0;
    end

    // Monitore o PC
    $monitor("PC = %h", uut.PC);
    #20;
    RST = 1;

    // Simulação
    #10;
    // Aqui você pode simular várias instruções com diferentes tipos de operação

    #200;  // Simule por 200 ns
    $stop;  // Pare a simulação
  end

endmodule
