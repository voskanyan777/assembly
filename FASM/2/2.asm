format PE console

include 'win32a.inc'

entry start

section '.data' data readable writeable
    enterX db 'Enter x: ', 0
    enterA db 'Enter a: ', 0
    inputX db '%lf', 0
    inputA db '%lf', 0
    completed db 'program completed', 0
    resxa db 'x = %.3lf  a = %.3lf', 0dh, 0ah, 0
    resy1 db 'y1 = %.3f', 0dh, 0ah, 0
    resy2 db 'y2 = %.3f', 0dh, 0ah, 0
    res db 'y1 - y2 = %.3f', 0dh, 0ah, 0
    emptystr db ' ', 0dh, 0ah, 0
    i dd ?
    x dq ?
    a dq ?
    x_i dq ?
    y1 dq ?
    y2 dq ?
    three dq 3.0
    seven dq 7.0
    saving dd ?
    time dq ?
    eleven dq 11.0
    resultat dq ?

section '.code' code readable executable
start:
    finit
    ; Ввод данных с клавиатуры
    invoke printf, enterX
    cinvoke scanf, inputX, x
    
    invoke printf, enterA
    cinvoke scanf, inputA, a
    
    mov ebx, 0
    lp:
        mov [i], ebx
        fld qword[x] ; Добавляем в стек значение x
        fild dword [i] ; Добавляем в стек значение i. fild -> добавление в регист целого числа
        faddp ; Складываем x + i
        fstp qword [x_i] ; Результат сохраняем в x_i. st0 очищается
        
        invoke printf, resxa, dword[x_i], dword[x_i+4], dword[a], dword[a+4]
        
        fld qword [a]
        fld qword [x_i]
        
        fcomi st0, st1
        jbe count_y1_2 ; если st0 <= st1
        
        count_y1: ; '+'
                count_y1_1:
                fstp qword [time]
                        fstp qword [time]
                        fld qword [a]
                        fld qword [x_i]
                        fabs ; берем модуль st0
                        faddp ; складываем st0 и st1
                        
                        jmp count_y2 ; Считаем y2
                count_y1_2:
                        fstp qword [time] ; удаляем st0 из верщины
                        fld qword [a]
                        mov [saving], 7
                        fild dword [saving]
                        fsubp ; вычитаем 
                        
                        
                
                        
        count_y2:
                fstp qword [y1] ; Сохраняем результат st0 в y1
                invoke printf, resy1, dword[y1], dword[y1+4]
                ;cinvoke printf, resxa, dword[x_i], dword[x_i+4], dword[a], dword[a+4]
                ;cinvoke printf, resy1, dword[y1], dword[y1+4]
                
                fld qword [three]
                fld qword [a]
                fcomi st0, st1
                jbe count_y2_2 ;если st0 <= st1
                
                count_y2_1:
                
                        fmulp
                        fstp qword [y2]
                        jmp finish
                                        
                        
                        
                
                count_y2_2:
                        fmulp
                        fstp qword [time]
                        fld qword [eleven]
                        fstp qword [y2]

                        jmp finish
                
                        
                        
        finish:
                            
            ;fstp qword [y2]
            invoke printf, resy2, dword[y2], dword[y2+4]
            fstp qword [time]
            fstp qword [time]
            fld qword [y1]
            fld qword [y2]
            fsubp
            fstp qword [resultat]
        
            invoke printf, res, dword[resultat], dword[resultat+4]
        
            invoke printf, emptystr

            add ebx, 1
        
            cmp ebx, 10
    
    jne lp
    
    call [getch]
    



section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll'

    import kernel,\
            ExitProcess, 'ExitProcess'

    import msvcrt,\
            printf, 'printf',\
            scanf, 'scanf',\
            getch, '_getch'