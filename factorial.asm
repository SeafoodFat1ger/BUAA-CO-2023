.macro end
 	li $v0,10
 	syscall 
.end_macro 
.macro getInt(%des)
 	li $v0,5
 	syscall 
 	move %des,$v0
.end_macro 
.macro getStr(%des)
 	li $v0,12
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
.macro push(%des)
 	sw %des,0($sp)
 	subi $sp,$sp,4
.end_macro 
.macro pop(%des)
 	addi $sp,$sp,4
 	lw %des,0($sp)
.end_macro 	
.macro getIndex(%des,%n,%i,%j)
 	mul  %des,%i,%n
 	add %des,%des,%j
	sll %des,%des,2
.end_macro


.data
	a:.space 4500
	
.text
getInt($s0)		#s0 is n
li $t1,1
sw $t1,a($zero)

#1000*9=9000
li $s1,0	#s1 is lenth

li $s2,10


li $t0,2	#t0 is i
for_i:
	bgt $t0,$s0,for_i_end
	li $t1,0	#t1 is cin
	li $t2,0	#t2 is j
	addi $t3,$s1,4
	for_j:
		bgt $t2,$t3,for_j_end	#t3 is lenth+4
			
			sll $t4,$t2,2
			lw $t5,a($t4)
			mul $t5,$t5,$t0
			add $t5,$t5,$t1
			
			div $t5,$s2
			mflo $t1
			mfhi $t5
			sw $t5,a($t4)
		addi $t2,$t2,1
		j for_j
	for_j_end:
	
	while:
		ble $t3,0,end_while
		sll $t7,$t3,2
		lw $t8,a($t7)
		bne $t8,0,end_while
		subi $t3,$t3,1
		j while	
	end_while:
	move $s1,$t3
	addi $t0,$t0,1
	j for_i
for_i_end:

while_2:
	ble $s1,0,end_while_2
	sll $t3,$s1,2
	lw $t4,a($t3)
	bne $t3,0,end_while_2
	subi $s1,$s1,1
end_while_2:

move $t0,$s1	#t0 is i
output_i:
	blt $t0,0,end_output
	sll $t1,$t0,2
	lw $t2,a($t1)
	printInt($t2)
	subi $t0,$t0,1
	j output_i
	
end_output:
end



