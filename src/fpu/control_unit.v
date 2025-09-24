module control_unit (
    input CLK, input RST, 
    input [6:0] op, 
    input [2:0] funct3, 
    input [6:0] funct7, 
    input Zero,
    output reg PCSrc,
    output reg ResultSrc,
    output reg MemWrite,
    output reg [2:0] ALUControl,
    output reg ALUSrc,
    output reg [1:0] ImmSrc,
    output reg RegWrite,
    output reg [2:0] FPUControl, // Novo sinal de controle para FPU
    output reg ALU_FPU_Select  // Novo sinal para selecionar entre ALU e FPU
);

    reg branch;
    reg condZero;
    
    assign PCSrc = branch & (Zero == condZero);

    always @ (posedge CLK or negedge RST) begin
        if (!RST) begin
            branch = 1'b0;
        end else begin
            branch = 1'b0;
            condZero = 1'b0;
            RegWrite = 1'b0;
            ALUSrc = 1'b0;
            ResultSrc = 1'b0;
            ALUControl = ALU_ADD;
            FPUControl = 3'b000; // FPUControl padrão
            ALU_FPU_Select = 0;  // Começa com ALU selecionada
            casez({funct7, funct3, op})
                { RVF7_ADD, RVF3_ADD, RVOP_ADD } : begin
                    RegWrite = 1'b1;
                    ALUControl = ALU_ADD;
                    ImmSrc = 2'b00;
                    ALU_FPU_Select = 0;  // ALU
                end
                { RVF7_SUB, RVF3_SUB, RVOP_SUB } : begin
                    RegWrite = 1'b1;
                    ALUControl = ALU_SUB;
                    ALU_FPU_Select = 0;  // ALU
                end
                // Adicionando operações para FPU
                { RVF7_ANY, RVF3_ANY, RVOP_FADD } : begin
                    RegWrite = 1'b1;
                    FPUControl = 3'b000; // FPU Add
                    ALU_FPU_Select = 1;  // FPU
                end
                { RVF7_ANY, RVF3_ANY, RVOP_FSUB } : begin
                    RegWrite = 1'b1;
                    FPUControl = 3'b001; // FPU Sub
                    ALU_FPU_Select = 1;  // FPU
                end
                { RVF7_ANY, RVF3_ANY, RVOP_FMUL } : begin
                    RegWrite = 1'b1;
                    FPUControl = 3'b010; // FPU Mul
                    ALU_FPU_Select = 1;  // FPU
                end
                { RVF7_ANY, RVF3_ANY, RVOP_FDIV } : begin
                    RegWrite = 1'b1;
                    FPUControl = 3'b011; // FPU Div
                    ALU_FPU_Select = 1;  // FPU
                end
                // Outras instruções
                default: begin
                    branch = 1'b0;
                    condZero = 1'b0;
                    RegWrite = 1'b0;
                    ALUSrc = 1'b0;
                    ResultSrc = 1'b0;
                    ALUControl = ALU_ADD;
                    ImmSrc = 2'b00;
                    ALU_FPU_Select = 0;  // ALU
                end
            endcase
        end
    end
endmodule
