// Ingrid Jackeline dos Santos Castro
// Roteiro 2 - Problemas 1 e 2

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
  parameter APAGADO = 'b00000000;
  parameter NUM_0 = 'b00111111;
  parameter NUM_1 = 'b00000110;
  parameter NUM_2 = 'b01011011;

  logic [1:0] sensores;      // declaração da variável usada como entrada

  always_comb sensores <= SWI[1:0];     // atribuição da entrada

  always_comb
         if (sensores == 2'b00) SEG <= APAGADO;      // áreas com umidade adequada
    else if (sensores == 2'b01) SEG <= NUM_0;        // área 0 com baixa umidade
    else if (sensores == 2'b10) SEG <= NUM_1;        // área 1 com baixa umidade
    else                        SEG <= NUM_2;        // áreas com baixa umidade

  // solução do Problema 2
  logic [1:0] info_a;        // declaração das variáveis usadas como entrada
  logic [1:0] info_b;
  logic seletor;

  always_comb begin          // atribuição das entradas
    info_a <= SWI[7:6];
    info_b <= SWI[5:4];
    seletor <= SWI[3];
  end

  always_comb
      if (seletor == 0) LED[7:6] <= info_a;       // transmite a informação A
    else                LED[7:6] <= info_b;       // transmite a informação B

endmodule
