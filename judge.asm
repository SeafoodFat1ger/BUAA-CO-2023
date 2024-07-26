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
	A:.space 100
.text

input:
getInt($s0)	#s0 is n
li $t0 ,0	#t0 is i
for_i:
beq $t0,$s0,for_i_end
	getStr($t1)
	sll $t2,$t0,2
	sw $t1,A($t2)
addi $t0,$t0,1
j for_i
for_i_end:



li $t0 ,0
srl $s1,$s0,1
for_i_judge:
beq $t0,$s1,for_end_judge
	sll $t1,$t0,2
	sub $t2,$s0,$t0
	subi $t2,$t2,1
	sll $t2,$t2,2
	lw $t3,A($t1)
	lw $t4,A($t2)
bne $t3,$t4,not_equal
addi $t0,$t0,1
j for_i_judge
not_equal:
printInt($t5)
end
for_end_judge:
li $t5,1
printInt($t5)
end







