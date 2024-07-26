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
	symbol:.space 40
	array:.space 40
	space:.asciiz " "
	enter:.asciiz "\n"
.text
main:
getInt($s0)		#s0 is n
move $a0,$zero	#in 0
jal FullArray
end

FullArray:
push($ra)
push($t0)
push($t1)
push($t2)
push($t3)
push($t4)
push($t5)


move $t0,$a0	#t0 is index
if:
blt  $t0,$s0,else

then:
li $t1,0	#t1 is i
for_1:
beq $t1,$s0,for_1_end
sll $t2,$t1,2
lw $t3,array($t2)
printInt($t3)
printStr(space)
addi $t1,$t1,1
j for_1
for_1_end:
printStr(enter)
pop($t5)
pop($t4)
pop($t3)
pop($t2)
pop($t1)
pop($t0)
pop($ra)
jr $ra

else:
li $t1,0	
for_2:
beq $t1,$s0,for_2_end
sll $t2,$t1,2			#index i is t2
lw $t3,symbol($t2)
	bne $t3,$zero,else_2
	sll $t4,$t0,2		# index index is t4
	addi $t5,$t1,1
	sw $t5,array($t4)	# array[index]=i+1
	li $t4,1
	sw $t4,symbol($t2)	# symbal[i]=1
	
	addi $t5,$t0,1
	move $a0,$t5
	jal FullArray
	li $t4,0
	sw $t4,symbol($t2)	# symbal[i]=0
else_2:
addi $t1,$t1,1
j for_2
for_2_end:
pop($t5)
pop($t4)
pop($t3)
pop($t2)
pop($t1)
pop($t0)
pop($ra)
jr $ra










