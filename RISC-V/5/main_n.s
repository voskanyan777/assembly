.global main
.data
  y2: .ascii "y2="
  x: .word 1      # целое число
  a: .word 3
  x_i: .ascii "x+i="
  one: .word 1
  result: .ascii "y1+y2="
  zeroo: .word 0
  x_message: .asciz "Введите x: "
  tree: .word 3
  a_message: .asciz "Введите a: "
  y1: .ascii "y1="


.text
main:	
	# Ввод чисел X и A
	la a0, x_message
	addi a7, zero, 4
	ecall
 	addi a7, zero, 5    
	ecall                 
	mv a5, a0 # В регистре а5 храним значение X
	la a0, a_message
	addi a7, zero, 4
	ecall
	addi a7, zero, 5     
	ecall                 
	mv a6, a0 # В регистре а6 храним значение А
	
	# Счётчики для цикла
	li t0, 0
	li t1, 11
	loop:
		li a0, 0x0A           # ASCII код новой строки
  		addi a7, zero, 11     # код для вывода символа
		ecall                 # системный вызов для вывода символаэ
		# x + 1
		la a0, x_i
	  	addi a7, zero, 4
	  	ecall
	  
	  
		mv a0, a5        # загрузка адреса переменной в a0
		add a0, a0, t0
		
		addi a7, zero, 1
		ecall
		
		
		#addi a7, zero, 1      # код для вывода строки
		#ecall                 # системный вызов для вывода
  		 
  		lw a1, zeroo
  		blt a0, a1, is_negative
  		bge a0, a1, is_positive 
  		

		is_negative:
			neg a0, a0
			mv a4, a0
			neg a0, a0
			lw a1, tree
			blt a4, a1, y1_1
			bge a4, a1, y1_2
  		is_positive:
			lw a1, tree
			blt a0, a1, y1_1
			bge a0, a1, y1_2
		y1_1:
			li a1, 4
			sub a1, a1, a0
			mv a2, a1 # в а2 будет значение y1
			la a0, y1
	  		addi a7, zero, 4
	  		ecall
			mv a0, a1	      # Значение y1	
			addi a7, zero, 1      # код для вывода строки
	  		ecall                 # системный вызов для вывода

	  		

	  		
			addi t0, t0, 1        # увеличиваем счетчик цикла на 1
  			bne t0, t1, y_2      # если t0 не равен t1, переходим к метке loop 
  			beq t0, t1, end
		y1_2:
			mv a1, a6
			add a1, a1, a0
			mv a2, a1 # в а2 будет значение y1
			la a0, y1
	  		addi a7, zero, 4
	  		ecall
			mv a0, a1
			addi a7, zero, 1
			ecall

			addi t0, t0, 1        # увеличиваем счетчик цикла на 1
  			bne t0, t1, y_2      # если t0 не равен t1, переходим к метке loop 
  			beq t0, t1, end
  		y_2:
  			li a0, 0x20           # ASCII код пробела
  			addi a7, zero, 11     # код для вывода символа
			ecall                 # системный вызов для вывода символаэ
  			lw a0, x
  			add a0, a0, t0
  			li a1, 2
  			rem a1, a0, a1
  			beq a1, zero, y2_1   # Если остаток равен 0, переходим к метке even (число четное)
  			j y2_2 	# число нечетное
  			
  			y2_1:
  				li a3, 2 # Значение y2 
  				
				la a0, y2
	  			addi a7, zero, 4
	  			ecall  				
  				mv a0, a3
				addi a7, zero, 1
				ecall

  				
  				bne t0, t1, print_res      # если t0 не равен t1, переходим к метке loop 
  				beq t0, t1, end
  			
  			y2_2:
  				mv a0, a6
  				li a1, 2
  				add a1, a0, a1
  				mv a3, a1 # значение y2
				
				la a0, y2
	  			addi a7, zero, 4
	  			ecall  				
  				mv a0, a1
				addi a7, zero, 1
				ecall

  				
  				bne t0, t1, print_res      # если t0 не равен t1, переходим к метке loop 
  				beq t0, t1, end
  			print_res:
  				li a0, 0x20           # ASCII код пробела
  				addi a7, zero, 11     # код для вывода символа
				ecall                 # системный вызов для вывода символа
				la a0, result
	  			addi a7, zero, 4
	  			ecall
  				mv a0, a2
  				add a0, a2, a3
  				addi a7, zero, 1
				ecall

	  			bne t0, t1, loop      # если t0 не равен t1, переходим к метке loop 
  				beq t0, t1, end
  				
  				
  				

  			
end:
  addi a7, zero, 10     # код для завершения программы
  ecall                 # системный вызов
