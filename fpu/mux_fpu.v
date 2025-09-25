// mux_fpu.v
// Seleciona o resultado final: inteiro ou ponto flutuante

module mux_fpu (
    input  wire [31:0] alu_result,
    input  wire [31:0] fpu_result,
    input  wire        fpu_en,
    output wire [31:0] final_result
);

    assign final_result = (fpu_en) ? fpu_result : alu_result;

endmodule
