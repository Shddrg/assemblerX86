.686
.model flat, c
option casemap:none

; Объявляем внешнюю функцию на C
extern calc_f:proc

.code
; Функция: double find_max_asm(double start, double end, double step) (стековый кадр)
find_max_asm proc
    push ebp
    mov ebp, esp
    ; Выделяем память в стеке для локальных переменных:
    sub esp, 16 

    ; Инициализация curr_x = start
    fld qword ptr [ebp+8]    
    fstp qword ptr [ebp-16]  


    ; Вычисляем f(start), чтобы задать начальное значение max_val
    push dword ptr [ebp-12]  ; Старшие 4 байта curr_x
    push dword ptr [ebp-16]  ; Младшие 4 байта curr_x
    call calc_f              ; Результат возвращается в st(0)
    add esp, 8               
    fstp qword ptr [ebp-8]   ; max_val = f(start)

check_loop:
    ; Увеличиваем curr_x на step: curr_x = curr_x + step
    fld qword ptr [ebp-16]
    fadd qword ptr [ebp+24]  
    fst qword ptr [ebp-16]   

    ; Проверяем условие цикла: curr_x > end
    fcomp qword ptr [ebp+16] 
    fstsw ax                 
    sahf                     
    ja end_loop              

    ; Вызываем calc_f(curr_x)
    push dword ptr [ebp-12]
    push dword ptr [ebp-16]
    call calc_f
    add esp, 8               ; st(0) теперь содержит f(curr_x)

    ; Сравниваем f(curr_x) с max_val
    fcom qword ptr [ebp-8]   ; Сравниваем st(0) и max_val
    fstsw ax
    sahf
    jbe not_greater          ; Если f(curr_x) <= max_val, пропускаем обновление

    ; Обновляем max_val
    fst qword ptr [ebp-8]    ; max_val = f(curr_x)

not_greater:
    fstp st(0)               ; Очищаем значение f(curr_x) из стека FPU
    jmp check_loop

end_loop:
    ; По правилам cdecl, тип double возвращается через регистр st(0)
    fld qword ptr [ebp-8]    ; Загружаем итоговый max_val в st(0)

    ; Восстанавливаем фрейм стека
    mov esp, ebp
    pop ebp
    ret
find_max_asm endp
end