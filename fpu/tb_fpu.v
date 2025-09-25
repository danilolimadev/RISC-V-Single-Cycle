// tb_fpu.v
// Testbench para validar a FPU (operações básicas RV32F)

`timescale 1ns/1ps

module tb_fpu;

    reg clk;
    reg rst;
    reg [4:0] op;
    reg [31:0] a, b;
    wire [31:0] result;

    // Instancia a FPU
    fpu uut (
        .clk(clk),
        .rst(rst),
        .op(op),
        .a(a),
        .b(b),
        .result(result)
    );

    // Clock de 10ns (100 MHz)
    always #5 clk = ~clk;

    // Função para mostrar em float
    real fa, fb, fres;
    task show_result;
        begin
            fa   = $bitstoshortreal(a);
            fb   = $bitstoshortreal(b);
            fres = $bitstoshortreal(result);
            $display("[%0t] OP=%0d | a=%f b=%f -> result=%f",
                     $time, op, fa, fb, fres);
        end
    endtask

    initial begin
        // Inicialização
        clk = 0;
        rst = 1;
        op  = 0;
        a   = 0;
        b   = 0;

        #12 rst = 0;

        // Teste FADD.S
        a  = 32'h3f800000; // 1.0
        b  = 32'h40000000; // 2.0
        op = 5'd0;         // FADD
        #20 show_result;

        // Teste FSUB.S
        a  = 32'h40400000; // 3.0
        b  = 32'h40000000; // 2.0
        op = 5'd1;         // FSUB
        #20 show_result;

        // Teste FMUL.S
        a  = 32'h3f800000; // 1.0
        b  = 32'h40400000; // 3.0
        op = 5'd2;         // FMUL
        #20 show_result;

        // Teste FDIV.S
        a  = 32'h40800000; // 4.0
        b  = 32'h40000000; // 2.0
        op = 5'd3;         // FDIV
        #20 show_result;

        // Teste operação inválida
        a  = 32'h3f800000; // 1.0
        b  = 32'h3f800000; // 1.0
        op = 5'd31;        // inválido
        #20 show_result;

        $display("Fim da simulação.");
        $finish;
    end

endmodule
