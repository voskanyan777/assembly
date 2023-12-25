format PE Console

entry start

include 'win32a.inc'

section '.data' data readable writeable

        struct student
            surname db 30 dup(0)
            name db 30 dup(0)
            father_name db 30 dup(0)
            age dd 0
        ends
        students student ?,?,?,?
                student ?,?,?,?
                student ?,?,?,?
                student ?,?,?,?
                student ?,?,?,?
                student ?,?,?,?
        string_input db '%s',0
        int_output db '%d',10,0
        struct_output db '%s, %s, %s, %d',10,0
        n dd 6
        size_of dd 94
        i dd 0

        read_file_name db 'input',0
        write_file_name db 'output',0
        w_mode db 'w',0
        r_mode db 'r',0
        read_file_d dd 0
        write_file_d dd 0
        size dd 0

section '.code' code readable writeable executable

start:
        invoke fopen, read_file_name, r_mode

        ; сохранение дескриптора файла
        mov [ds:read_file_d], eax

        ; вывчислить количество имеющихся байт
        mov eax, [ds:n]
        imul [ds:size_of]
        ; хотим выбрать 1 элемент
        mov ecx, 1

        invoke fread, students, ecx, eax, [ds:read_file_d]

        invoke fclose, [ds:read_file_d]

        invoke fopen, write_file_name, w_mode

        mov [ds:write_file_d], eax


        mov [ds:i], 0
        looop2:
                ; Расчет смещения к началу структуры
                mov eax, [ds:i]
                imul [ds:size_of]

                ; расчет поля cost
                mov edx, eax
                add edx, students.age

                ; изменение cost
                push eax
                mov eax, 1
                add eax, [edx]
                mov [edx], eax
                pop eax

                inc [ds:i]
                mov edx, [ds:i]
                cmp edx, 6
                jne looop2

        ; расчет количества байт для записи в файл
        mov eax, [ds:n]
        imul [ds:size_of]
        mov ecx, 1
        mov [ds:i], 0

                looop:
                ; расчет смещения к началу структуры
                mov eax, [ds:i]
                imul [ds:size_of]
                mov [ds:size], eax

                ; расчет полей
                mov ebx, [ds:size]
                add ebx, students.name


                mov ecx, [ds:size]
                add ecx, students.surname


                add eax, students.father_name


                mov edx, [ds:size]
                add edx, students.age


                invoke fprintf, [ds:write_file_d], struct_output, ebx, ecx, eax, [edx]


                inc [ds:i]
                mov edx, [ds:i]
                cmp edx, 6
                jne looop


        ; запись в файл и закрытие
        invoke fwrite, students, ecx, [ds:size], [ds:write_file_d]
        invoke fclose, [ds:write_file_d]




        invoke getch
        invoke ExitProcess, 0

section '.idata' data import readable
  library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'
  
  import kernel,\
         ExitProcess, 'ExitProcess'

          
  import msvcrt,\
          printf, 'printf',\
          getch, '_getch', scanf,'scanf',\
           fopen, 'fopen',\
            fwrite, 'fwrite', \
            fclose, 'fclose', \
            fread, 'fread', \
            fprintf, 'fprintf'