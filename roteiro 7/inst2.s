.text
main:
        addi x11, x0, 0xFE
        addi x12, x0, 0x000   
        lui x12, 0x10000 

        sw x11, 0xC (x12)

        lw x10, 0xC (x12)