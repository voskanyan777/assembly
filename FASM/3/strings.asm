format PE console

include 'win32a.inc'

entry start
                                                      
section '.data' data readable writeable
    buffer db 256 dup (0)         ; Буфер для ввода строки
    input_str db "Input: ", 0     ; Строка приглашение для ввода
    resStr db "%s", 0             ; Используем %s для вывода строки
    result db "Longest word: %s", 0 ; Строка для вывода
section '.code' code readable executable 
start:
    ; Выводим приглашение для ввода строки
    push input_str
    call [printf]

    ; Считываем строку от пользователя
    lea eax, [buffer]
    push eax
    call [gets]

    ; Ищем самое длинное слово
    lea esi, [buffer]  ; Исходная строка
    lea edi, [buffer]  ; Начало самого длинного слова
    xor ebx, ebx       ; Текущая длина слова
    mov ecx, ebx       ; Максимальная длина слова

    find_longest_word:
        mov al, [esi]       ; Загружаем текущий символ
        cmp al, 0           ; Проверяем, не достигнут ли конец строки
        je done_finding
        cmp al, ' '         ; Проверяем, не является ли текущий символ разделителем
        je update_length
        inc ebx             ; Увеличиваем длину текущего слова
        jmp continue_finding

    update_length:
        cmp ebx, ecx        ; Сравниваем текущую длину с максимальной
        jbe skip_update
        mov ecx, ebx        ; Обновляем максимальную длину
        sub esi, ecx        ; Переходим к первому символу длинного слова
        lea edi, [esi]      ; Обновляем указатель на начало самого длинного слова
        mov byte [edi + ecx], 0 ; Указываем конец строки, чтобы выводилось только длинное слово 
        add esi, ecx ; Переходим к концу длинной строки для продолжения поиска
        

    skip_update:
        xor ebx, ebx         ; Сбрасываем счетчик для следующего слова

    continue_finding:
        inc esi             ; Переходим к следующему символу
        jmp find_longest_word

done_finding:
    ; Проверяем, не является ли последнее слово самым длинным
    cmp ebx, ecx
    jbe no_update

    ; Обновляем указатель на начало самого длинного слова
    sub esi, ebx  ; уменьшаем esi на длину слова
    mov edi, esi  ; копируем esi в edi

no_update:
    ; Выводим самое длинное слово
    push edi
    push result
    call [printf]

    ; Завершение программы
    call [getch]


section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll'

    import kernel,\
            ExitProcess, 'ExitProcess'

    import msvcrt,\
            printf, 'printf',\
            gets, 'gets',\
            getch, '_getch'