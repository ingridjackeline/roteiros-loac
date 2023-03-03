// Ingrid Jackeline dos Santos Castro
// Roteiro 3 - Problema 1

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
  parameter NBITS_NUM = 3;                                  // quantidade de bits das variáveis utilizadas
  parameter NBITS_F = 2;
  parameter NBITS_Y = 4;

  parameter OVERFLOW = 'b00111111;                          // o overflow é indicado pela letra O no display
  parameter UNDERFLOW = 'b00111110;                         // o underflow é indicado pela letra U no display

  parameter NUM_0 = 7'b0111111;
  parameter NUM_1 = 7'b0000110;
  parameter NUM_2 = 7'b1011011;
  parameter NUM_3 = 7'b1001111;
  parameter NUM_4 = 7'b1100110;

  logic signed [NBITS_NUM-1:0] a, b;                        // declaração das variáveis utilizadas
  logic [NBITS_F-1:0] f;
  logic signed [NBITS_Y-1:0] y;

  always_comb begin                                         // atribuição das entradas
    a <= SWI[7:5];
    b <= SWI[2:0];
    f <= SWI[4:3];
  end

  always_comb
    case (f) 
      2'b00: y <= a + b;                                    // soma
      2'b01: y <= a - b;                                    // subtração
      2'b10: y <= a & b;                                    // and
      2'b11: y <= a | b;                                    // or
    endcase

  always_comb
    if (y >= -4 & y <= 3) begin                             // resultados dentro da faixa de valores suportada
        LED[7] <= 0;
        LED[2:0] <= y;
        SEG[7] <= y[3];

             if (y == -4)          SEG[6:0] <= NUM_4;
        else if (y == -3 | y == 3) SEG[6:0] <= NUM_3;
        else if (y == -2 | y == 2) SEG[6:0] <= NUM_2;
        else if (y == -1 | y == 1) SEG[6:0] <= NUM_1;
        else                       SEG[6:0] <= NUM_0;
      end
    else begin                                              // ocorrência de erro: underflow ou overflow
        LED[7] <= 1;
        LED[2:0] <= 0;
        
          if (y < -4) SEG <= UNDERFLOW;                   
        else          SEG <= OVERFLOW;
      end

endmodule
