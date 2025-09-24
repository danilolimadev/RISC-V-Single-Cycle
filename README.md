# RISC-V-Single-Cycle
# RISC-V Single Cycle CPU Implementation

Este projeto implementa um processador RISC-V de ciclo único (single cycle) utilizando Verilog. O objetivo é fornecer uma simulação completa da execução de instruções RISC-V em um processador de ciclo único. O projeto inclui módulos como a unidade de controle, ALU, memória, registradores, entre outros.

## Estrutura do Projeto

A estrutura do repositório está dividida da seguinte forma:

- **src/**: Contém os arquivos Verilog para cada módulo individual, como:
  - `control_unit.v`: Implementação da unidade de controle.
  - `mux_pc.v`: Multiplexador para o PC.
  - `pc.v`: Registrador do PC.
  - `instruction_memory.v`: Memória de instrução.
  - `register_file.v`: Arquivo de registradores.
  - `alu.v`: Unidade lógica e aritmética.
  - `data_memory.v`: Memória de dados.
  - `mux_result.v`: Multiplexador de resultado.
  - `pc_plus_4.v`: Soma de 4 para o PC.
  - `extend.v`: Extensor de sinal para imedidos.
  - `pc_target.v`: Cálculo do alvo do PC.
  - `top.v`: Arquitetura geral do processador.

- **test/**: Contém o banco de testes (`tb_top.v`) para validar o comportamento do processador.

- **program.hex**: Arquivo com o código em formato hexadecimal para ser carregado na memória de instrução.

- **Makefile**: Opcional, mas recomendado para facilitar a execução da simulação.

## Como Rodar a Simulação

1. **Instalar ferramentas de simulação Verilog**:
   - Para simular o código, você pode usar ferramentas como [ModelSim](https://www.mentor.com/products/fpga/modelsim) ou [Icarus Verilog](http://iverilog.icarus.com/).
   
2. **Compilar e simular**:
   - Se estiver usando o ModelSim:
     ```bash
     vlib work
     vcom src/*.v
     vsim test.tb_top
     run -all
     ```
   - Para Icarus Verilog:
     ```bash
     iverilog -o cpu_tb src/*.v test/tb_top.v
     vvp cpu_tb
     ```

3. **Analisar resultados**:
   - Durante a simulação, o `monitor` no testbench irá exibir o valor do PC. Isso pode ser alterado para monitorar outras variáveis de interesse, como registradores ou a memória.

## Módulos Implementados

- **Unidade de Controle**: Controla o fluxo das instruções, decide se o próximo PC é atualizado, qual operação ALU deve ser realizada, entre outras tarefas.
  
- **Registradores e Memória**: Implementação de um arquivo de registradores e uma memória de dados simples, junto com a memória de instruções que é carregada de um arquivo `.hex`.

- **ALU (Unidade Lógica e Aritmética)**: Implementa operações como adição, subtração, OR lógico, shift e comparação.

- **Multiplexadores**: Vários multiplexadores para controle de fluxo de dados e seleção de entradas para a ALU e outros componentes.

## Arquivo de Programa

O arquivo `program.hex` contém o código em formato hexadecimal que será carregado na memória de instruções. Você pode modificá-lo para testar diferentes programas.

## Contribuições

Se você quiser contribuir para o projeto, sinta-se à vontade para abrir um pull request. Novas implementações de instruções ou otimizações para o design do processador são sempre bem-vindas.

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).
