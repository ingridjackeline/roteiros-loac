// Ingrid Jackeline dos Santos Castro
// Roteiro 5 - Problemas 1 e 2

parameter divide_by=100000000;  // divisor do clock de referência
// A frequencia do clock de referencia é 50 MHz.
// A frequencia de clk_2 será de  50 MHz / divide_by

parameter NBITS_INSTR = 32;
parameter NBITS_TOP = 8, NREGS_TOP = 32, NBITS_LCD = 64;
module top(input  logic clk_2,
           input  logic [NBITS_TOP-1:0] SWI,
           output logic [NBITS_TOP-1:0] LED,
           output logic [NBITS_TOP-1:0] SEG,
           output logic [NBITS_LCD-1:0] lcd_a, lcd_b,
           output logic [NBITS_INSTR-1:0] lcd_instruction,
           output logic [NBITS_TOP-1:0] lcd_registrador [0:NREGS_TOP-1],
           output logic [NBITS_TOP-1:0] lcd_pc, lcd_SrcA, lcd_SrcB,
             lcd_ALUResult, lcd_Result, lcd_WriteData, lcd_ReadData, 
           output logic lcd_MemWrite, lcd_Branch, lcd_MemtoReg, lcd_RegWrite);

  always_comb begin
    lcd_WriteData <= SWI;
    lcd_pc <= 'h12;
    lcd_instruction <= 'h34567890;
    lcd_SrcA <= 'hab;
    lcd_SrcB <= 'hcd;
    lcd_ALUResult <= 'hef;
    lcd_Result <= 'h11;
    lcd_ReadData <= 'h33;
    lcd_MemWrite <= SWI[0];
    lcd_Branch <= SWI[1];
    lcd_MemtoReg <= SWI[2];
    lcd_RegWrite <= SWI[3];
    for(int i=0; i<NREGS_TOP; i++)
       if(i != NREGS_TOP/2-1) lcd_registrador[i] <= i+i*16;
       else                   lcd_registrador[i] <= ~SWI;
    lcd_a <= {56'h1234567890ABCD, SWI};
    lcd_b <= {SWI, 56'hFEDCBA09876543};
  end

  // solução do Problema 1
  parameter NBITS_CONTAGEM = 4;                                                // quantidade de bits da contagem

  parameter NUMERO_0 = 'b00111111;                                             // sequência hexadecimal (0 a F) a ser apresentada no display de 7 segmentos
  parameter NUMERO_1 = 'b00000110;
  parameter NUMERO_2 = 'b01011011;
  parameter NUMERO_3 = 'b01001111;
  parameter NUMERO_4 = 'b01100110;
  parameter NUMERO_5 = 'b01101101;
  parameter NUMERO_6 = 'b01111101;
  parameter NUMERO_7 = 'b00000111;
  parameter NUMERO_8 = 'b01111111;
  parameter NUMERO_9 = 'b01101111;

  parameter LETRA_A = 'b01110111;
  parameter LETRA_B = 'b01111100;
  parameter LETRA_C = 'b00111001;
  parameter LETRA_D = 'b01011110;
  parameter LETRA_E = 'b01111001;
  parameter LETRA_F = 'b01110001;

  logic [NBITS_CONTAGEM-1:0] valor_inicial, contagem;                          // declaração das variáveis utilizadas
  logic reset, load, select_contagem;

  always_comb begin                                                            // atribuição das entradas
    reset <= SWI[0];
    select_contagem <= SWI[1];
    load <= SWI[2];
    valor_inicial <= SWI[7:4];
  end

  always_ff @ (posedge clk_2) begin
         if (reset)           contagem <= 0;                                   // reseta a contagem
    else if (load)            contagem <= valor_inicial;                       // define o valor inicial da contagem
    else if (select_contagem) contagem <= contagem - 1;                        // realiza a contagem decrescente
    else                      contagem <= contagem + 1;                        // realiza a contagem crescente
  end

  always_comb LED[7] <= clk_2;                                                 // exibição do clock

  always_comb 
    case (contagem)                                                            // exibição dos valores da contagem hexadecimal
      4'b0000: SEG <= NUMERO_0;
      4'b0001: SEG <= NUMERO_1;
      4'b0010: SEG <= NUMERO_2;
      4'b0011: SEG <= NUMERO_3;
      4'b0100: SEG <= NUMERO_4;
      4'b0101: SEG <= NUMERO_5;
      4'b0110: SEG <= NUMERO_6;
      4'b0111: SEG <= NUMERO_7;
      4'b1000: SEG <= NUMERO_8;
      4'b1001: SEG <= NUMERO_9;
      4'b1010: SEG <= LETRA_A;
      4'b1011: SEG <= LETRA_B;
      4'b1100: SEG <= LETRA_C;
      4'b1101: SEG <= LETRA_D;
      4'b1110: SEG <= LETRA_E;
      4'b1111: SEG <= LETRA_F;
    endcase

  //solução do Problema 2
  logic bit_entrada, bit_saida;                                                // declaração das variáveis utilizadas

  always_comb bit_entrada <= SWI[3];                                           // atribuição da entrada

  enum logic [1:0] {A, B, C, D} estado;                                        // definição dos estados possíveis

  always_ff @ (posedge clk_2)
      if (reset) estado <= A;                                                  // reseta a FSM para o estado A
    else 
      unique case (estado)                                                     // realiza a passagem de estados confome o bit de entrada recebido
        A:   if (bit_entrada == 0) estado <= A;
           else                    estado <= B;
        B:   if (bit_entrada == 0) estado <= A;
           else                    estado <= C;
        C:   if (bit_entrada == 0) estado <= A;
           else                    estado <= D;
        D:   if (bit_entrada == 0) estado <= A;
           else                    estado <= D;
      endcase

  always_comb bit_saida <= (estado == D);                                      // define o bit de saída de acordo com a ocorrência do estado D

  always_comb LED[0] <= bit_saida;                                             // exibição do bit de saída

endmodule
