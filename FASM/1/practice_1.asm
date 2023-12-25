format PE console

include 'win32a.inc'

entry Start

section '.data' data readable writeable
    enterX db 'Enter x: ', 0
    enterY db 'Enter y: ', 0 
    strRes1 db '1)Z = X^3 + Y -1.  Z = %d  |', 0
    strRes2 db '2)Z = (XY + 1)/ X^2.  Z = %d |', 0
    strRes3 db '3)Z = (X+Y)/(X-Y).  Z = %d |', 0
    strRes4 db '4)Z = - 1/X^3 + 3.  Z = %d |', 0
    strRes5 db '5)Z = X - Y/X +1.  Z = %d', 0                               


    xNum db '%d', 0
    yNum db '%d', 0
    
    x rd 1
    y rd 1

    
    


section '.code' code readable executable
Start:
        ;Ввод чисел x и y
        push enterX
        call [printf]
        
        push x
        push xNum
        call [scanf]
        
        push enterY
        call [printf]
        
        push y
        push yNum
        call [scanf]
        
        ;Вычисляем результат формулы strRes1
        mov ecx, [x]
        imul ecx, [x]
        imul ecx, [x]
        add ecx, [y]
        add ecx, -1
        push ecx
        push strRes1
        call [printf]
        
        ;Вычисляем результат формулы strRes2  Z = (XY + 1)/ X^2
        ;eax - целая часть, edx - остаток от деления
        ;Делится на eax, там и хранится целая часть
        ;div operand, operand -> делитель
        ; eax / ecx
        
        
        ;Вычисляем значение формулы strRes2 Z = (XY + 1)/ X^2
        mov eax, [x]
        imul eax, [y]
        add eax, 1
        mov ecx, [x]
        imul ecx, [x]
        cdq 
        idiv ecx
        push eax
        push strRes2
        call [printf]
        
        
        ;Вычисляем значение формулы strRes3  Z = (X+Y)/(X-Y)
        mov eax, [x]
        add eax, [y]
        mov ecx, [x]
        sub ecx, [y]
        cdq
        idiv ecx
        push eax
        push strRes3
        call [printf]
        
        ;Вычисляем значение формулы strRes4 Z = - 1/X^3 + 3

        mov eax, 1
        mov ecx, [x]
        imul ecx, [x]
        imul ecx, [x]
        cdq
        idiv ecx
        neg eax
        add eax, 3
        push eax
        push strRes4
        call [printf]
        
        
        ;Вычисляем значение формулы strRes5 Z = X - Y/X +1
        mov eax, [y]
        mov ecx, [x]
        cdq
        idiv ecx
        neg eax
        add ecx, eax
        add ecx, 1
        push ecx
        
        push strRes5
        call [printf]
        
        
        call [getch]
        call [ExitProcess]
        
        
        
                
        
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll'

    import kernel,\
            ExitProcess, 'ExitProcess'

    import msvcrt,\
            printf, 'printf',\
            getch, '_getch',\
            scanf, 'scanf'