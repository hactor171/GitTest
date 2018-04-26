.data 
STDIN = 0
STDOUT = 1
SYSREAD = 3
SYSWRITE = 4
SYSEXIT = 1
EXIT_SUCCESS = 0
BUFLEN = 512

.bss 
   .comm wpr_tekst, BUFLEN


.text 
.global _start 

_start:   #wejscie w program
   movl $SYSREAD, %eax #wczytanie pliku az do zanku ENTER
   movl $STDIN, %ebx #identyfikator wejscia
   movl $wpr_tekst, %ecx # adres poczatku bufora 
   movl $BUFLEN, %edx #rozmiar bufora w bajtach
   int $0x80 #wywolanie funkcji

   movl $0, %edi  # wyzerowanie licznika
   movl %eax, %esi #faktyczna ilosc znakow dla wyswietlania
jmp przeksztalcenie

przeksztalcenie:  #petla dla sprawdzenia i zmieniania wszystkich 
   #duzych liter na male
   movb wpr_tekst(, %edi, 1), %al #odczytanie znaku do %al
   cmp $'A', %al # jezeli kod wiekszy niz poczatek duzych liter 
   # przeskok do etykiety zmien_na_male
   jge zmien_na_male
   # w przeciwnym wypadku przeskok do zapis_wyniku
   jmp zapis_wyniku
   
   zmien_na_male:
   cmp $'Z', %al #jezeli kod wiekszy niz koniec duzych liter
   # przeskok do zapis_wyniku
   jge zapis_wyniku
   # w przeciwnym wypadku zmniejszanie i przeskok do zapis_wyniku
   xor $0x20, %al
   jmp zapis_wyniku

   
   zapis_wyniku:
   mov %al, wpr_tekst(, %edi, 1)

   inc %edi #zwiekszenie licznika
   cmp %eax, %edi #warunek
jle przeksztalcenie
 
wyswietl:
   movl $SYSWRITE, %eax # wyprowadz zmieniony tekst
   movl $STDOUT, %ebx # identyfikator wyjscia
   movl $wpr_tekst, %ecx # adres poczatku bufora
   movl %esi, %edx # fakryczna liczba znakow w bajtach
   int $0x80

wyjscie:
   movl $SYSEXIT, %eax
   movl $EXIT_SUCCESS, %ebx 
   int $0x80
