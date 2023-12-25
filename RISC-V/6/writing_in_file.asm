#
# Risc-V Assembler program to print "Hello World!"
# to stdout.
#
# a0-a2 - parameters to linux function services
# a7 - linux function number
#

.global _start      # Provide program starting address to linker

# Setup the parameters to print hello world
# and then call Linux to do it.

_start: 
	
	# Ввод чисел s0=N, s1=M s2=N*M

        lw s0, N
        

        lw s1, M
        
        mul s2, s0, s1
        
        
	# Запись в файл s4 = file descriptor
	la a0, path
	li a1, 1 # write-create
	li a7, 1024
	ecall
	mv s4, a0
	
	# Запись в файл чисел N, M
	la t0, temp
	sw s0, (t0)
	
	addi t0, t0, 4
	sw s1, (t0)
	la a1, temp
	
	li a2, 8
	li a7, 64
	ecall
	
	# Запись в файл всего буфера
	mv a0, s4
	la a1, array
	mv a2, s2
	li t0, 4
	mul a2, a2, t0
	li a7, 64
	ecall
	
	# Закрытие файла
	mv a0, s4
	li a7, 57
	ecall
	
	

# Выход из программы
exit:
        addi    a0, x0, 0   # Use 0 return code
        addi    a7, x0, 93  # Service command code 93 terminates
        ecall               # Call linux to terminate the program

.data
# N - строки M - Стобцы
N: .word 2
M: .word 2
temp:           .space 8
prompt:         .asciz "Enter N and M\n"
newline:        .asciz "\n"
path:           .asciz "C:\\asm 2.2\\datas.txt"
array: .word 5, 2
       .word 4, 1