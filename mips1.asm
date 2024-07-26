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

.macro printStr(%src)
    la    $a0, %src
    li      $v0, 4
    syscall
.end_macro

.macro  getindex(%ans, %i, %j)
    sll %ans, %i, 3             # %ans = %i * 8
    add %ans, %ans, %j          # %ans = %ans + %j
    sll %ans, %ans, 2           # %ans = %ans * 4
.end_macro


.data
matrix: .space 11000
str_enter:  .asciiz "\n"
str_space:  .asciiz " "

.text 
getInt($s0)	#s0=n
getInt($s1)	#s1=m

input:
li  $t0, 0	#t0 is i
in_i:
beq $t0,$s0,in_i_end
li  $t1, 0	#t1 is j
in_j:
beq $t1,$s1,in_j_end

getInt($t2)
getindex($t3, $t0, $t1)
sw  $t2, matrix($t3)

addi $t1, $t1, 1
j   in_j
in_j_end:
addi $t0, $t0, 1
j   in_i
in_i_end:

output:
subi $t0, $s0,1
out_i:
blt $t0,0,out_i_end
subi $t1, $s1,1
out_j:
blt $t1,0,out_j_end

getindex($t3, $t0, $t1)
lw  $t2, matrix($t3)
beq $t2,$zero,beq_else
addi $t0,$t0,1
addi $t1,$t1,1
printInt($t0)
printStr(str_space)
printInt($t1)
printStr(str_space)
printInt($t2)
printStr(str_enter)
subi $t0, $t0,1
subi $t1, $t1,2
j   out_j
out_j_end:
subi $t0, $t0,1
j   out_i
out_i_end:
end

beq_else:
subi $t1, $t1,1
j out_j

