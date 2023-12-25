format PE Console
entry Start

include 'win32a.inc'

section '.data' data readable writeable

  m dd 4 ; Количество строк
  n dd 4 ; Количество столбцов
  
  trash dd ?
  
  ; матрица 3 на 4
  matrix dd 4, 3, 2, 1
         dd 4, 3, 2, 1
         dd 1, 2, 3, 4
         dd 15, 22, 24, 20
  i dd 0
  j dd 0

  count_v dd 0
  count_u dd 0    

      
    
  result1 db "monoton row: %d", 0dh, 0ah, 0
  result2 db "not mono row: %d",  0dh, 0ah, 0
  result3 db "monoton column: %d",  0dh, 0ah, 0
  result4 db "not mono column: %d",  0dh, 0ah, 0


section '.text' code readable executable

Start:
    i_loop:
      mov [j], 0
      j_loop:
        ; Получаем текущий элемент
        mov ecx, [i]
        mov eax, [j]

        
        imul ecx, [n]
        imul ecx, 4
        imul eax, 4
        add eax, ecx
        mov edx, [matrix + eax] ; Текущий элемент

        ; Получаем следущюий элемент
                
        mov ecx, [i]
        mov eax, [j]
        
        add eax, 1
        
        imul ecx, [n]
        imul ecx, 4
        imul eax, 4
        add eax, ecx
        mov ebx, [matrix + eax] ; Следующий элемент
        
        cmp edx, ebx
        jnb new_search
        
        inc [j]
        mov ecx, [n]
        sub ecx, 1
        cmp [j], ecx
        jl j_loop

        
        
      add [count_v], 1
      inc [i]
      mov ecx, [m]
      cmp [i], ecx
      jl i_loop
      jmp ass  
    
    new_search:
        inc [i]
        mov ecx, [m]
        cmp [i], ecx
        jl i_loop   
    ass:
        mov [i], 0
        
    i_loop_2:
      mov [j], 0
      j_loop_2:
        ; Получаем текущий элемент
        mov ecx, [i]
        mov eax, [j]

        
        imul ecx, [n]
        imul ecx, 4
        imul eax, 4
        add eax, ecx
        mov edx, [matrix + eax] ; Текущий элемент

        ; Получаем следущюий элемент
                
        mov ecx, [i]
        mov eax, [j]
        
        add eax, 1
        
        imul ecx, [n]
        imul ecx, 4
        imul eax, 4
        add eax, ecx
        mov ebx, [matrix + eax] ; Следующий элемент
        
        cmp edx, ebx
        jbe new_search_2
        
        inc [j]
        mov ecx, [n]
        sub ecx, 1
        cmp [j], ecx
        jl j_loop_2

        
        
      add [count_u], 1
      inc [i]
      mov ecx, [m]
      cmp [i], ecx
      jl i_loop_2
      jmp done
      
    
    new_search_2:
        inc [i]
        mov ecx, [m]
        cmp [i], ecx
        jl i_loop_2  
    
   

    
    done:
        ; Вывод результата
        push [count_v]
        push result1
        call [printf] 
        
        push [count_u]
        push result2
        call [printf]               
        call [getch]
        call [ExitProcess]


section '.idata' import data readable

  library kernel32, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll'

    import kernel32,\
           ExitProcess, 'ExitProcess'

    import msvcrt,\
           printf, 'printf',\
           getch, '_getch', \
           scanf, 'scanf'
