[BITS 32]


global _start

extern kernel_main

code_seg equ 0x08
data_seg equ 0x10

_start:
   mov ax,data_seg
   mov ds,ax
   mov es,ax
   mov fs,ax
   mov gs,ax
   mov ss,ax
   mov ebp,0x00200000
   mov esp,ebp
  
   ;enabled A20LINE
   in al,0x92
   or al,2
   out 0x92, al

   ;Remap the master pic
   mov al,00010001b
   out 0x20,al;tell master pic 
   mov al,0x20;interrupt 0x20 is where master ISR should start
   out 0x21,al
   mov al,00000001b
   out 0x21,al
   ;end remap of the mater pic

  
   
   call kernel_main
   
   jmp $


  

times 512-($ - $$) db 0