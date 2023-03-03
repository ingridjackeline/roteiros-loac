// Ingrid Jackeline dos Santos Castro
// Roteiro 4 - Problema 3

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

  // solução do Problema 3
  parameter NBITS_ADDR = 2;                            // quantidade de bits dos endereços
  parameter NBITS_DATA = 4;                            // quantidade de bits dos dados
                                                 
  logic [NBITS_ADDR-1:0] addr_entrada;                 // declaração das variáveis utilizadas
  logic [NBITS_DATA-1:0] data_saida;                   

  always_comb addr_entrada <= SWI[3:2];                // atribuição da entrada

  always_comb 
    case (addr_entrada)                                // relação entre os endereços e os dados armazenados
      2'b00: data_saida <= 4'b0011;
      2'b01: data_saida <= 4'b0110;
      2'b10: data_saida <= 4'b1001;
      2'b11: data_saida <= 4'b1100;
    endcase

  always_comb LED[7:4] <= data_saida;                  // exibição da saída

endmodule
