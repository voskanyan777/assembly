format PE console

include 'win32a.inc'

entry start
                                                      
section '.data' data readable writeable
    buffer db 256 dup (0)         ; ����� ��� ����� ������
    input_str db "Input: ", 0     ; ������ ����������� ��� �����
    resStr db "%s", 0             ; ���������� %s ��� ������ ������
    result db "Longest word: %s", 0 ; ������ ��� ������
section '.code' code readable executable 
start:
    ; ������� ����������� ��� ����� ������
    push input_str
    call [printf]

    ; ��������� ������ �� ������������
    lea eax, [buffer]
    push eax
    call [gets]

    ; ���� ����� ������� �����
    lea esi, [buffer]  ; �������� ������
    lea edi, [buffer]  ; ������ ������ �������� �����
    xor ebx, ebx       ; ������� ����� �����
    mov ecx, ebx       ; ������������ ����� �����

    find_longest_word:
        mov al, [esi]       ; ��������� ������� ������
        cmp al, 0           ; ���������, �� ��������� �� ����� ������
        je done_finding
        cmp al, ' '         ; ���������, �� �������� �� ������� ������ ������������
        je update_length
        inc ebx             ; ����������� ����� �������� �����
        jmp continue_finding

    update_length:
        cmp ebx, ecx        ; ���������� ������� ����� � ������������
        jbe skip_update
        mov ecx, ebx        ; ��������� ������������ �����
        sub esi, ecx        ; ��������� � ������� ������� �������� �����
        lea edi, [esi]      ; ��������� ��������� �� ������ ������ �������� �����
        mov byte [edi + ecx], 0 ; ��������� ����� ������, ����� ���������� ������ ������� ����� 
        add esi, ecx ; ��������� � ����� ������� ������ ��� ����������� ������
        

    skip_update:
        xor ebx, ebx         ; ���������� ������� ��� ���������� �����

    continue_finding:
        inc esi             ; ��������� � ���������� �������
        jmp find_longest_word

done_finding:
    ; ���������, �� �������� �� ��������� ����� ����� �������
    cmp ebx, ecx
    jbe no_update

    ; ��������� ��������� �� ������ ������ �������� �����
    sub esi, ebx  ; ��������� esi �� ����� �����
    mov edi, esi  ; �������� esi � edi

no_update:
    ; ������� ����� ������� �����
    push edi
    push result
    call [printf]

    ; ���������� ���������
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