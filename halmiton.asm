.macro end
    li      $v0, 10
    syscall
.end_macro

.macro getInt(%des)
    li      $v0, 5
    syscall
    move    %des, $v0
.end_macro

.macro printInt(%src)
    move    $a0, %src
    li      $v0, 1
    syscall
.end_macro


.macro getindex(%num, %i, %j)
    sll %num, %i, 3
    add %num,%num, %j
    sll %num, %num, 2
.end_macro



.macro push(%src)
    sw      %src, 0($sp)
    subi    $sp, $sp, 4
.end_macro

.macro pop(%des)
    addi    $sp, $sp, 4
    lw      %des, 0($sp) 
.end_macro

.data
	G: .space 1024
	book: .space 512

.text
main:
	getInt($s0)	# s0=n
	getInt($s1)	# s1=m
	li $t0, 0	# t0 is i
	input_loop:
		beq $t0, $s1, input_end
		getInt($t1)
		getInt($t2)
		subi $t1,$t1,1
		subi $t2,$t2,1
		li $t3, 1
		getindex($t4,$t2,$t1)
		sw $t3,G($t4)
		getindex($t4,$t1,$t2)
		sw $t3,G($t4)
		addi $t0,$t0,1
		j input_loop
	input_end:
	move $a0,$zero	#in 0
	jal dfs
	printInt($s2)
	end


dfs:	
	push($ra)
	push($t4)
	push($t8)
	move $t4,$a0	#t4 is x
	li $t7,1		# t7 is flag
	sll $t5,$t4,2	
	sw $t7,book($t5)
	li $t8,0		#t8 is i
	for_1:
		beq $t8,$s0,for_1_end
		sll $t9,$t8,2	# t9 is book_i_index
		lw $t6,book($t9)
		and $t7,$t7,$t6
		addi $t8,$t8,1
		j for_1
	for_1_end:
	if_1:
		# getGraph($t6,$t4,$zero)
		getindex($t5,$t4,$zero)
		lw $t6,G($t5)
		and $t6,$t6,$t7
		beq $t6,$zero,if_1_else
		li $s2,1
		
		pop($t8)
		
		pop($t4)
		pop($ra)
		jr $ra
		
	if_1_else:
	li $t8,0		#t8 is i
	for_2:
		beq $t8,$s0,for_2_end
		sll $t9,$t8,2	# t9 is book_i_index
		lw $t6,book($t9)	#t6 is book[i]
		#getGraph($t7,$t4,$t8)#t7 is G[x][i]
		getindex($t5,$t4,$t8)
		lw $t7,G($t5)
		if_2:
		bne $t6,$zero,if_2_else
		bne $t7,1,if_2_else
		move $a0,$t8
		jal dfs
		if_2_else:
		addi $t8,$t8,1
		j for_2
	for_2_end:
		sll $t5,$t4,2
		sw $zero,book($t5)
		

		pop($t8)

		pop($t4)
		pop($ra)
		jr $ra
	
	
	
	
	
