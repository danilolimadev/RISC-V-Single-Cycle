# RISC-V Single Cycle CPU

Este projeto implementa um processador **RISC-V de ciclo único (single cycle)** em Verilog. O objetivo é fornecer uma base educacional para estudo da arquitetura RISC-V e da implementação de processadores digitais.

## 📌 Visão Geral

O processador segue a arquitetura **RISC-V RV32I** e executa cada instrução em um único ciclo de clock. Todos os módulos foram desenvolvidos de forma modular para facilitar o entendimento, a simulação e a futura expansão do design.

## 🗂 Estrutura do Projeto

- **src/** → Implementação dos módulos em Verilog:
  - **Decodificadores e Controle**
    - `control_unit.v`: Unidade de controle principal.
    - `main_decoder.v`: Decoder de instruções em sinais de controle.
    - `alu_decoder.v`: Decoder de funções específicas da ALU.
  - **Processamento**
    - `alu.v`: Unidade lógica e aritmética.
    - `mux_alu.v`: Multiplexador das entradas da ALU.
    - `mux_result.v`: Multiplexador de seleção do resultado final.
  - **PC (Program Counter)**
    - `pc.v`: Registrador de PC.
    - `pc_plus_4.v`: Incremento de PC.
    - `pc_target.v`: Cálculo do endereço alvo (branch/jump).
    - `mux_pc.v`: Multiplexador de seleção do próximo PC.
  - **Memórias e Registradores**
    - `instruction_memory.v`: Memória de instruções.
    - `data_memory.v`: Memória de dados.
    - `register_file.v`: Banco de registradores.
    - `extend.v`: Extensor de sinal de imediatos.
  - **Integração**
    - `top.v`: Módulo de topo que conecta todos os componentes.

- **test/**
  - `tb_top.v`: Testbench principal para simulação do processador.

- **program.hex**  
  Arquivo de programa em formato hexadecimal carregado pela memória de instruções.

- **images/**  
  Capturas de tela da simulação e resultados.

## ⚙️ Como Executar

1. Compile todos os arquivos Verilog localizados em `src/`.
2. Carregue `program.hex` na memória de instruções.
3. Utilize `tb_top.v` como testbench para rodar a simulação.
4. Verifique os sinais internos e compare os resultados com as imagens em `images/`.

## 📖 Requisitos

- Simulador Verilog (Icarus Verilog, ModelSim ou equivalente).
- Visualizador de ondas (GTKWave recomendado).

## 🚀 Próximos Passos

- Implementação de versões **multi-cycle** e **pipeline** para comparação de desempenho.
- Suporte a instruções adicionais da arquitetura RISC-V.
- Testes com programas maiores e benchmarks.

---
