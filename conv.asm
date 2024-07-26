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
	F:.space 576
	H:.space 576
	G:.space 576
	space:.asciiz " "
	enter:.asciiz "\n"
	
.text
getInt($s0)		#s0 is m1
getInt($s1)		#s1 is n1
getInt($s2)		#s0 is m2
getInt($s3)		#s1 is n2

li $t0,0	#t0 is i
for_1_i:
beq $t0,$s0,for_1_i_end
	li $t1,0	#t1 is j
	for_1_j:
	beq $t1,$s1,for_1_j_end
	getInt($t2)
	getIndex($t3,$s1,$t0,$t1)
	sw $t2,F($t3)
	addi $t1,$t1,1
	j for_1_j
	for_1_j_end:
		
addi $t0,$t0,1
j for_1_i
for_1_i_end:


li $t0,0	#t0 is i
for_2_i:
beq $t0,$s2,for_2_i_end
	li $t1,0	#t1 is j
	for_2_j:
	beq $t1,$s3,for_2_j_end
	getInt($t2)
	getIndex($t3,$s3,$t0,$t1)
	sw $t2,H($t3)
	addi $t1,$t1,1
	j for_2_j
	for_2_j_end:
		
addi $t0,$t0,1
j for_2_i
for_2_i_end:

sub $s4,$s0,$s2
addi $s4,$s4,1		#s4 is m1-m2+1
sub $s5,$s1,$s3
addi $s5,$s5,1		#s5 is n1-n2+1


li $t0,0	#t0 is i
i_in:
beq $t0,$s4,i_end
li $t1,0	#t1 is j

j_in:
beq $t1,$s5,j_end
li $t2,0	#t2 is k

k_in:
beq $t2,$s2,k_end
li $t3,0	#t3 is l

l_in:
beq $t3,$s3,l_end

getIndex($t4,$s3,$t2,$t3)
lw $t5,H($t4)

add $t8,$t0,$t2
add $t9,$t1,$t3
getIndex($t6,$s1,$t8,$t9)
lw $t7,F($t6)

mul $t5,$t5,$t7
getIndex($t6,$s5,$t0,$t1)
lw $t4,G($t6)
add $t4,$t4,$t5
sw $t4,G($t6)

addi $t3,$t3,1
j l_in
l_end:

addi $t2,$t2,1
j k_in
k_end:

addi $t1,$t1,1
j j_in
j_end:

addi $t0,$t0,1
j i_in
i_end:


li $t0,0	#t0 is i
i_out:
beq $t0,$s4,i_out_end
li $t1,0	#t1 is j

j_out:
beq $t1,$s5,j_out_end

getIndex($t2,$s5,$t0,$t1)
lw $t3,G($t2)
printInt($t3)
printStr(space)

addi $t1,$t1,1
j j_out
j_out_end:
addi $t0,$t0,1
printStr(enter)
j i_out
i_out_end:

end


