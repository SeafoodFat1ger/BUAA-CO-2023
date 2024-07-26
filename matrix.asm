.macro end
 	li $v0,10
 	syscall 
.end_macro 
.macro getInt(%des)
 	li $v0,5
 	syscall 
 	move %des,$v0
.end_macro 
.macro printInt(%des)
 	move $a0,%des
 	li $v0,1
 	syscall
.end_macro 
.macro printStr(%des)
 	la  $a0,%des
 	li $v0,4
 	syscall
.end_macro	
.macro getIndex(%des,%n,%i,%j)
 	mul  %des,%i,%n
 	add %des,%des,%j
	sll %des,%des,2
.end_macro

.data
	A:	.space	256
	B:	.space	256
	C:	.space	256
	enter:	.asciiz	"\n"
	space:	.asciiz	" "
.text 
getInt($s0) 	#s0 is n
li $t0,0		#t0 is i

A_for_i:
	beq $t0,$s0,A_for_i_end
	li $t1,0		#t1 is j
	A_for_j:
		beq $t1,$s0,A_for_j_end
		getInt($t2)
		getIndex($t3,$s0,$t0,$t1)
		sw $t2,A($t3)
		addi $t1,$t1,1
		j A_for_j
	A_for_j_end:
	addi $t0,$t0,1
	j A_for_i
A_for_i_end:
li $t0,0

B_for_i:
	beq $t0,$s0,B_for_i_end
	li $t1,0		#t1 is j
	B_for_j:
		beq $t1,$s0,B_for_j_end
		getInt($t2)
		getIndex($t3,$s0,$t0,$t1)
		sw $t2,B($t3)
		addi $t1,$t1,1
		j B_for_j
	B_for_j_end:
	addi $t0,$t0,1
	j B_for_i
B_for_i_end:

li $t0,0
li $t1,0
li $t2,0 # t2 is k

# A[i][k]*B[k][j]=C[i][j]
C_for_i:
	beq $t0,$s0,C_for_i_end
	li $t1,0
	C_for_j:
		beq $t1,$s0,C_for_j_end
		li $t2,0
		C_for_k:
			beq $t2,$s0,C_for_k_end
			
			#A
			getIndex($t3,$s0,$t0,$t2) 
			lw $t4,A($t3)
			#B
			getIndex($t3,$s0,$t2,$t1) 
			lw $t5,B($t3)
			#C
			getIndex($t3,$s0,$t0,$t1)
			mul $t4,$t4,$t5 
			lw $t6,C($t3)
			add $t6,$t6,$t4
			sw $t6,C($t3)
			
			addi $t2,$t2,1
			j C_for_k
		C_for_k_end:
		addi $t1,$t1,1		
		j C_for_j
	C_for_j_end:
	addi $t0,$t0,1
	j C_for_i
C_for_i_end:
li $t0,0
li $t1,0
out:
out_i:
	beq $t0,$s0,out_i_end
	li $t1,0
	out_j:
		beq $t1,$s0,out_j_end
		getIndex($t3,$s0,$t0,$t1)
		lw $t6,C($t3)
		printInt($t6)
		printStr(space)
		addi $t1,$t1,1
		j out_j
	out_j_end:
	addi $t0,$t0,1
	printStr(enter)
	j out_i
out_i_end:

end











