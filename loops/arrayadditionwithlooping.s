# s0 holds the value of N.
# s1 holds base address of p.
#s2 holds the base address of q.
#s3 holds the sum of the p looping at p's index. to add into q.
# t0 is the counter./ index.
# t5 is the immediate value at index.

# t1 = current address of q in the loop.
# t2 = current address of p in the loop.

.data 
	.globl message
	message: .asciiz "Please enter N (between 1 and 9):"
	messageAsk: .asciiz "Please enter the index number: "
	warningMessage: .asciiz "Please enter your number below 9.\n"
	finalDisplay: .asciiz "\n"
	p: .word 0,0,0,0,0,0,0,0,0
	q: .word 0,0,0,0,0,0,0,0,0
	n: .word 0
	
	.text
	.globl main
main:
	addu  $s7, $0, $ra # save return address in $s7.

askN:
	la $a0, message
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	li $t0, 9
	li $t1, 1
	bgt $v0, $t0, showWarning
	blt $v0, $t1, showWarning
	
	add $s0, $0, $v0 # $s0 holds N
	sub $s0, $s0, 1 #s0 = s0-1
	sw $s0, n
	
	.text
	li $t0, 0
	la $s1, p
	la $s2, q
	
	j Loop
	
showWarning:
	la $a0, warningMessage
	li $v0, 4
	syscall
	
	j askN
	
Loop:
	la $a0,messageAsk
	li $v0, 4
	syscall #Print message ask.
	
	li $t5, 0
	li $t1, 0
	li $t3, 0
	li $s3, 0
	
	li $v0, 5
	syscall
	
	add $t5, $0, $v0 # t5 holds the immediate index value.
	
	add $t1, $t0, $t0
	add $t1, $t1, $t1 # t1 = 4*t0. i.e the offset of t0 index.
	
	add $t2, $t1, $s1
	add $t1, $t1, $s2
	
	sw $t5, 0($t2) # store the index into the p offset.
	#sw $t5, 0($t1)

LoopAndStoreQ:
	
	add $t6, $t3, $t3 # t3 is the inside loop counter.
	add $t6, $t6, $t6  #t6 stores 4*t3, i.e the offset of t3 index at p.
	
	add $t6, $t6, $s1 # t6 holds the actual address at p's shitty index.
	
	lw $t7, 0($t6) # t7 is not in use so put the value in t6 into t7.
	add $s3, $s3, $t7 #s3 holds the sum.
	
	beq $t3, $t0, QLoopQuitter
	
QLoopAdder:
	add $t3, $t3, 1
	j LoopAndStoreQ
	
QLoopQuitter:
	#store the sum to q.
	sw $s3, 0($t1)
	beq $t0, $s0, L2
	
L1:
	add $t0, $t0, 1 # add the counter by 1.
	j Loop
	
L2:
	# do result display in here.
	li $t0, 0
	li $t1, 0
	
	#Loop2 is just a result display loop.
Loop2: 
	add $t1, $t0, $t0
	add $t1, $t1, $t1 
	
	add $t2, $t1, $s1
	add $t1, $t1, $s2
	
	lw $s3, 0($t2) # Get the data into s2 from the p offset
	lw $s4, 0($t1)
	
	la $a0, finalDisplay
	li $v0, 4
	syscall
	
	add $a0, $0, $s3
	li $v0, 1
	syscall
	
	la $a0, finalDisplay
	li $v0, 4
	syscall
	
	add $a0, $0, $s4
	li $v0, 1
	syscall
	
	beq $t0, $s0, L22
	#la $t2, p
L12:
	add $t0, $t0, 1
	j Loop2

L22:
	addu  $ra, $0, $s7      # restore the return address
    jr  $ra   
	
	