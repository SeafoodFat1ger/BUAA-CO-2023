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

.macro push(%src)
    sw      %src, 0($sp)
    subi    $sp, $sp, 4
.end_macro

.macro pop(%des)
    addi    $sp, $sp, 4
    lw      %des, 0($sp) 
.end_macro

.text 
getInt($s0)
addi $t0,$zero,400
div $s0,$t0
mfhi $t1

addi $t0,$zero,4
div $s0,$t0
mfhi $t2

addi $t0,$zero,100
div $s0,$t0
mfhi $t3

bne $t2,$zero,N

bne $t3,$zero,Y

bne $t1,$zero,N
j Y

Y:
li $t4,1
printInt($t4) 
j endd

N:
printInt($zero)
j endd

endd:
end