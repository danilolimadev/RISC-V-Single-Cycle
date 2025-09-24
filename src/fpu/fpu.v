module fpu (
    input [31:0] operand1,  // Operando 1 (ponto flutuante)
    input [31:0] operand2,  // Operando 2 (ponto flutuante)
    input [2:0] opcode,     // Código da operação (add, sub, mul, div)
    output reg [31:0] result, // Resultado da operação
    output reg exception     // Exceção (divisão por zero)
);

    always @(*) begin
        exception = 0;  // Inicializa a exceção
        case (opcode)
            3'b000: result = operand1 + operand2; // Adição
            3'b001: result = operand1 - operand2; // Subtração
            3'b010: result = operand1 * operand2; // Multiplicação
            3'b011: begin // Divisão
                if (operand2 == 32'b0) begin
                    exception = 1;  // Divisão por zero
                    result = 32'b0;
                end else begin
                    result = operand1 / operand2;
                end
            end
            default: result = 32'b0;
        endcase
    end
endmodule
