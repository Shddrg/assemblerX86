.686
.model flat, stdcall
.stack 100h 

ExitProcess PROTO :DWORD

.data
    ; Массив треугольников (32-bit float). 
    ; 12 + 24 + 12 = 42
    ; 12 + 24 + 19,8 = 49,8
    triangles   dd 3.0, 4.0, 5.0
                dd 6.0, 8.0, 10.0
                dd 5.0, 10.0, 8.0

    num_triangles equ 3       ; Количество треугольников
    total_int   dd ?          ; итоговая сумма в виде целого числа
    two         dd 2.0

.code

Start:
    finit                       ; Инициализация FPU
    fldz                        ; st(0) = 0.0 (Это наш аккумулятор общей суммы площадей)

    mov ecx, num_triangles      ; Счетчик цикла
    lea esi, triangles          ; Указатель на массив

calc_loop:
    ;1. Вычисляем полупериметр p = (a + b + c) / 2
    fld dword ptr [esi]         
    fadd dword ptr [esi+4]      
    fadd dword ptr [esi+8]      
    fdiv [two]

    ;2. Считаем подкоренное выражение: p * (p-a) * (p-b) * (p-c)
    fld st(0)                   
    fsub dword ptr [esi]        
    
    fld st(1)                   
    fsub dword ptr [esi+4]      
    fmulp st(1), st(0)          
    
    fld st(1)                   
    fsub dword ptr [esi+8]     
    fmulp st(1), st(0)          
    
    fmulp st(1), st(0)          

    ;3. Извлекаем корень
    fsqrt                       

    ;4. Прибавляем площадь к общей сумме
    faddp st(1), st(0)          

    ;5. Переход к следующему треугольнику
    add esi, 12                 ; Сдвигаем указатель (3 числа по 4 байта)
    dec ecx
    jnz calc_loop

    ; Цикл завершен. В st(0) лежит общая сумма площадей
    fistp dword ptr [total_int] ; Сохраняем как int в память и очищаем стек FPU

    invoke ExitProcess, total_int

end start