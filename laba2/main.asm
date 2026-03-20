.686 
.model flat,stdcall 
.stack 100h 

.data 
    ;X_val dw 0D5A9h 0D5A9h 1002h 1001h
    ;Y_val dw 31FFh 31FFh 0000h 0000h
    ;Z_val dw 5555h 5554h 0000h 0000h
    
    X_val dw 0D5A9h
    Y_val dw 31FFh
    Z_val dw 5555h

.code 
ExitProcess PROTO STDCALL :DWORD 

Start: 
    ;1 
    mov ax, X_val
    dec ax              ; AX = X'
    mov bx, Y_val
    mov cx, 3           ; Счетчик цикла
@@loop: 
    add bx, ax          ; В цикле 3 раза прибавляем X' к Y
    loop @@loop

    ;2
    or  ax, Z_val       ; AX = X' or Z (вычисляем M)
    
    cmp ax, 10E8h
    ja  @@call_sub1     ; M > 10E8h к sub1
    call sub2           ; M <= 10E8h к sub2
    jmp  @@task_3

@@call_sub1:
    call sub1

    ;3
@@task_3:
    mov X_val, ax       ; Сохраняем R в X   
    test al, al         ; Проверяем младший байт R на четность единиц
    jpo  @@call_adr1    ; нечетное к АДР1
    
    call adr2           ; четное к АДР2
    jmp  exit           ; 

@@call_adr1:
    call adr1


sub1 proc
    sub ax, 211Fh       ; R = M - 211Fh
    ret
sub1 endp

sub2 proc
    add ax, 01D0h       ; R = M + 01D0h
    ret
sub2 endp

adr1 proc
    shr ax, 1           ; R = R / 2
    ret
adr1 endp

adr2 proc
    xor ax, 0F91h       ; R = R xor 0F91h
    ret
adr2 endp

exit: 
    ; 32-битный код из 16-битного регистра AX
    movzx eax, ax       
    Invoke ExitProcess, eax 

End Start