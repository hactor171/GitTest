.data 
STDIN = 0
STDOUT = 1
SYSREAD = 3
SYSWRITE = 4
SYSEXIT = 1
EXIT_SUCCESS = 0
BUFLEN = 512
tekst: .ascii "Nie jest cyfra\n"
tekst_len = .-tekst
.bss 
   .comm textin, BUFLEN


.text 
.global _start 

_start:
   movl $SYSREAD, %eax
   movl $STDIN, %ebx 
   movl $textin, %ecx 
   movl $BUFLEN, %edx
   int $0x80

   movl $0, %ebx
   movl $0, %edi
   movl $10, %r10d
   movl %eax, %r8d
   dec %r8d
   movl $0, %eax
  

loop:
   movb textin(, %edi, 1), %bl

   cmp $'0', %bl
   jl nie_czyslo

   cmp $'9', %bl
   jg nie_czyslo

   sub $'0', %bl
   mul %r10d
      
   add %ebx, %eax

   inc %edi
   cmp %r8d, %edi
jl loop

#do_stosu:
#   div %r10d 
#   add $'0', %edx
#   push %edx
#   movl $0, %edx

movl $0, %r8d
movl $0, %edi   

to_tekst:
   movb %al, textin(, %edi,1)
   inc %edi
   cmp %r8d, %edi
#jl to_tekst

wyswietl:
   movl $SYSWRITE, %eax
   movl $STDOUT, %ebx
   movl $textin, %ecx
   movl $BUFLEN, %edx
   int $0x80

jmp exit

nie_czyslo:

   movl $SYSWRITE, %eax
   movl $STDOUT, %ebx
   movl $tekst, %ecx
   movl $tekst_len, %edx
   int $0x80


exit:
   movl $SYSEXIT, %eax
   movl $EXIT_SUCCESS, %ebx
   int $0x80
