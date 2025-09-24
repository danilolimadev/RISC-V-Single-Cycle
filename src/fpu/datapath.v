module datapath (
    input [31:0] reg_data1,  // Operando 1 (registro)
    input [31:0] reg_data2,  // Operando 2 (registro)
    input [31:0] immediate,  // Imediato
    input [2:0] alu_opcode,  // OpCode da ALU
    input [2:0] fpu_opcode,  // OpCode da FPU
    input alu_fpu_select,     // Selecção entre ALU e FPU
    output [31:0] result,     // Resultado da operação
    output exception          // Exceção da FPU
);

    wire [31:0] alu_result, fpu_result;
    wire alu_exception, fpu_exception;

    // Instância da ALU
    alu alu_instance (
        .CLK(CLK),
        .ALUControl(alu_opcode),
        .SrcA(reg_data1),
        .SrcB(reg_data2),
        .Zero(),
        .ALUResult(alu_result)
    );

    // Instância da FPU
    fpu fpu_instance (
        .operand1(reg_data1),
        .operand2(reg_data2),
        .opcode(fpu_opcode),
        .result(fpu_result),
        .exception(fpu_exception)
    );

    // Multiplexador para escolher entre ALU e FPU
    assign result = alu_fpu_select ? fpu_result : alu_result;

    // Gerenciamento de exceção
    assign exception = alu_fpu_select ? fpu_exception : 0;
endmodule
