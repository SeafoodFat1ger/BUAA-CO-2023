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
 	li $v0,36
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
.text
getInt($s0)
li $t0,1	#t0 is i
li $s1,1	#s0 is n!
li $s2,0	#s1 is sum
for_i:
	bgt $t0,$s0,for_i_end
	mul $s1,$t0,$s1
	addu $s2,$s2,$s1
	addi $t0,$t0,1
	j for_i
for_i_end:
printInt($s2)
end



