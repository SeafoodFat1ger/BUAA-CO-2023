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
.macro push(%des)
 	sw %des,0($sp)
 	subi $sp,$sp,4
.end_macro 
.macro pop(%des)
 	addi $sp,$sp,4
 	lw %des,0($sp)
.end_macro 	
.macro getIndex(%des,%i,%j)
 	mul  %des,%i,10
 	add %des,%des,%j
	sll %des,%des,2
.end_macro

.data
	book:	.space	400
	maze:	.space	400
	dx:		.space  20
	dy:		.space  20
	
.text
li $s1,4
li $s2,8
li $s3,12
li $s0,0
li $t0, 0
sw $t0, dx($s2)
sw $t0, dx($s3)
sw $t0, dy($s0)
sw $t0, dy($s1)
addi $t0,$t0,1
sw $t0, dx($s1)
sw $t0, dy($s3)
subi $t0,$t0,2
sw $t0, dx($s0)
sw $t0, dy($s2)

main:
getInt($s0) 	#s0 is n
getInt($s1) 	#s1 is m

addi $s2,$s0,1
addi $s3,$s1,1
li $t0,1		#t0 is i
for_i:
	beq $t0,$s2,for_i_end
	li $t1,1		#t1 is j
	for_j:
		beq $t1,$s3,for_j_end
		getInt($t2)
		getIndex($t3,$t0,$t1)
		sw $t2,maze($t3)
		addi $t1,$t1,1
		j for_j
	for_j_end:
	addi $t0,$t0,1
	j for_i
for_i_end:



getInt($s2) 	#s2 is qi_x
getInt($s3) 	#s3 is qi_y
getInt($s4) 	#s4 is zhong_x
getInt($s5) 	#s5 is zhong_y


getIndex($t6,$s2,$s3)
li $t7,1
sw $t7,book($t6)

move $a0,$s2
move $a1,$s3
jal DFS
printInt($s6)
end

DFS:
push($ra)
push($t0)
push($t1)
push($t2)
push($t6)

move $t0,$a0	#t0 is x
move $t1,$a1	#t0 is y


bne $t0,$s4,else
bne $t1,$s5,else

addi $s6,$s6,1

pop($t6)
pop($t2)
pop($t1)
pop($t0)
pop($ra)
jr $ra

else:

li $t2,0	#t2 is i
for_2:
beq $t2,4,for_2_end
sll $t3,$t2,2	#index i is t3
lw $t4,dx($t3)	#t4 is dx[i]
lw $t5,dy($t3)	#t5 is dy[i]
add $t4,$t4,$t0	#t4 is next_x
add $t5,$t5,$t1	#t5 is next_y
getIndex($t6,$t4,$t5)
lw $t7,book($t6)
lw $t8,maze($t6)

bne $t7,0,else_2
bne $t8,0,else_2
ble $t4,0,else_2
ble $t5,0,else_2
bgt  $t4,$s0,else_2
bgt  $t5,$s1,else_2


li $t7,1
sw $t7,book($t6)
move $a0,$t4
move $a1,$t5
jal DFS
sw $zero,book($t6)	
	
else_2:
addi $t2,$t2,1
j for_2
for_2_end:

pop($t6)
pop($t2)
pop($t1)
pop($t0)
pop($ra)
jr $ra

















