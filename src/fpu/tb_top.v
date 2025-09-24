module tb_top;
    // Entradas reg CLK, RST;
    // Saídas wire [31:0] PC;
    integer i;

    // Instancia o módulo top
    top uut (
        .CLK(CLK),
        .RST(RST)
    );

    // Gerador de clock
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK; // Clock de 10ns
    end

    // Bloco de inicialização
    initial begin
        RST = 0; // Inicializa o simulador
        $display("Iniciando Testbench");

        // Inicializa a memória (opcional)
        $readmemh("program.hex", uut.instr_mem.rom); // Substitua pelo caminho correto do arquivo
        // Inicializa os registradores do processador
        for (i = 0; i < 32; i = i + 1) begin
            uut.reg_file.rf[i] = 32'b0;
        end
        
        // Monitore o PC
        $monitor("PC = %h", uut.PC);
        
        #20; // Aguarda o processamento inicial

        // Sinaliza o reset
        RST = 1;

        // Simula a execução de instruções
        #10;
        
        // Teste de operação de ponto flutuante (FPU)
        $display("Iniciando Teste de FPU");

        // Teste de adição de ponto flutuante
        uut.instr_mem.rom[0] = 32'b0000000_000_000_000_000_000_0000011;  // Instrução FADD (exemplo)
        // Teste de subtração de ponto flutuante
        uut.instr_mem.rom[1] = 32'b0000000_001_000_000_000_000_0000001;  // Instrução FSUB (exemplo)
        // Teste de multiplicação de ponto flutuante
        uut.instr_mem.rom[2] = 32'b0000000_010_000_000_000_000_0000010;  // Instrução FMUL (exemplo)
        // Teste de divisão de ponto flutuante
        uut.instr_mem.rom[3] = 32'b0000000_011_000_000_000_000_0000100;  // Instrução FDIV (exemplo)

        // Simulação de execução de instruções
        #200;  // Simula por 200ns

        // Finaliza a simulação
        $stop; // Para a simulação
    end
endmodule
