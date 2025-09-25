// fpu_decoder.v
// Decodifica instruções de ponto flutuante (RV32F)

module fpu_decoder (
    input  wire [31:0] instr,
    output reg  [4:0]  fpu_op,     // operação FPU (mapeada internamente)
    output reg         fpu_en      // habilita execução FPU
);

    wire [6:0] opcode = instr[6:0];
    wire [2:0] funct3 = instr[14:12];
    wire [6:0] funct7 = instr[31:25];

    always @(*) begin
        fpu_en = 1'b0;
        fpu_op = 5'b00000;

        if (opcode == 7'b1010011) begin
            fpu_en = 1'b1;
            case ({funct7, funct3})
                // operações principais RV32F
                {7'b0000000, 3'b000}: fpu_op = 5'd0; // FADD.S
                {7'b0000100, 3'b000}: fpu_op = 5'd1; // FSUB.S
                {7'b0001000, 3'b000}: fpu_op = 5'd2; // FMUL.S
                {7'b0001100, 3'b000}: fpu_op = 5'd3; // FDIV.S
                default:              fpu_op = 5'd31; // operação não suportada
            endcase
        end
    end

endmodule
