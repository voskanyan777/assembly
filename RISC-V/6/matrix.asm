.global _start      

_start: 
	 # File reading s4 = file descriptor
	la a0, path
	li a1, 0 
	li a7, 1024
	ecall
	mv s4, a0
	
	# File reading N=s0, M=s1, N*M=s2
	la a1, temp
	li a2, 8
	li a7, 63
	ecall
	
	la t0, temp
	lw s0, (t0)
	addi t0, t0, 4
	lw s1, (t0)
	mul s2, s0, s1
	

        # Array reading
        li t0, 4
        mul s3, s2, t0
        mv a0, s4
        la a1, array
        mv a2, s3
        li a7, 63
        ecall
  	
  	la t0, array
  	
# Переходим к работе с матрицей
# Индекс элемента, который принадлежит строке и главной диагонали 
# Можно вычислить по формуле: ((i * (M+1)) * 4, где i - индекс строки (начинается, естественно, с нуля)
replace:
  # Оригинальный массив
  la t0, array  
  
  # Копия массива
  la t1, array
  
  # Счетчики для циклов
  mv t2, s1 
  li t3, 0
  
  # Количество пройденных строк
  li t5, 0
  
  # i
  li t4, 0
  
  i_loop:
    beq t5, t2, end
    # i
    la t1, array
    mv a0, t4 
    mv a1, s1
    addi a1, a1, 1
    mul a0, a0, a1
    li a2, 4
    mul a0, a0, a2
    # в a0 находится смещение для элемента
    add t1, t1, a0
    # Теперь в а0 находится элемент, который нужен по условию
    lw a0, (t1)

    j_loop:
      # Прибавляем к текущему элементу элемент главной диагонали
      lw a3, (t0)
      add a3, a3, a0
      sw a3, (t0)
      # Переходим к следующему элементу
      addi t0, t0, 4
      
      # Увеличиваем счетчик
      addi t3, t3, 1
      bne t2, t3, j_loop
      j new_search
      
  new_search:
    # Увеличиваем i
    addi t4, t4, 1
    addi t5, t5, 1
    # Сбрасываем значение счетчика
    li t3, 0
    j i_loop  
      
      
end:
  # Обновляем указатель на оригинальный массив
  la t0, array
  
  
  # Вычисляем размер матрицы
  mv a1, s0
  mul a1, a1, a1
  
  # Счетчик для всей матрицы
  li t1, 0 
  
  # Счетчик для строк
  li t2, 0 
  mv t3, s0
      
new_line:
  beq t1, a1, finish
  li t2, 0
  li a0, 0x0A           # ASCII код новой строки
  addi a7, zero, 11     # код для вывода символа
  ecall                 # системный вызов для вывода символаэ
 
 
print_array:
  # Вывод элемента матрицы
  lw a0, (t0)
  addi a7, zero, 1
  ecall
  
  # Выводим пробел
  li a0, 32         
  addi a7, zero, 11 
  ecall             

  
  # Переходим к следующему элементу 
  addi t0, t0, 4
  
  addi t2, t2 1
  addi t1, t1, 1
  
  bne t2, t3, print_array
  j new_line
  
  
finish:
  addi a7, zero, 10    # code to exit
  ecall         # make the system call             

.data
array: .space 1024
temp: .space 8
newline: .asciz "\n"
path: .asciz "C:\\asm 2.2\\datas.txt"
space: .asciz " "
