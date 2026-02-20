.686
.model flat, stdcall
.stack 100h

.data
X dw 103
Y dw 12


.code
ExitProcess PROTO STDCALL :DWORD

; M = (X`-4*Y`) xor Y`
Start:
	neg X

	neg Y

	mov ax, 4
	imul ax, Y
 
    sub X, ax 
    mov ax, Y 

	xor ax, X

exit:
Invoke ExitProcess, ax

END Start