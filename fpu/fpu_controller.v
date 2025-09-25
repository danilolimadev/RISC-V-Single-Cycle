// fpu_controller.v
// Gera sinais de controle para a FPU a partir do fpu_decoder

module fpu_controller (
    input  wire [31:0] instr,
    output wire [4:0]  fpu_op,
    output wire        fpu_en
);

    fpu_decoder dec (
        .instr (instr),
        .fpu_op(fpu_op),
        .fpu_en(fpu_en)
    );

endmodule
