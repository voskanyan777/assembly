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
        students student 'Ivanov','Ivan','Ivanovich',20
                student 'Petrov','Artem','Alekseevich', 21
                student 'Andreev','Andrey','Maksimovich',18
                student 'dd','sds','as',7
                student 'asd','asdsd','alalovich',14
                student 'test','testov','testovich',22
        string_input db '%s',0
        int_output db '%d',15,0
        n dd 6
        size_of dd 94

        write_file_name db 'input',0
        w_mode db 'w',0
        file_d dd 0

section '.code' code readable writeable executable

start:
        invoke fopen, write_file_name, w_mode
        ; дескриптор файла
        mov [ds:file_d], eax
        mov eax, [ds:n]
        imul [ds:size_of]
        mov ecx, 1
        invoke fwrite, students, ecx, eax, [ds:file_d]
        invoke fclose, [ds:file_d]


        invoke getch
        invoke ExitProcess, 0

section '.idata' data import readable
  library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'
  
  import kernel,\
         ExitProcess, 'ExitProcess'

          
  import msvcrt,\
          printf, 'printf',\
          getch, '_getch', scanf, 'scanf',\
           fopen, 'fopen', fwrite, 'fwrite',\
           fclose, 'fclose'