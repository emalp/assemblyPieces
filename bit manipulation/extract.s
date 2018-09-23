# Program extracts 'N' bits from position 'M' in any 32 bit register with a value 'P' in it.
# p is located in register $s0.
# m is located in register $s3.
# n is located in register $s4.
# signed is in $s1, unsigned is in $s2
# /**** Written by emalp ****\
	
	.data
	.globl askP
	askP : .asciiz "\n\nEnter P:"
	askM : .asciiz "\nEnter M:"
	askN : .asciiz "\nEnter N:"
	displayUnsigned: .asciiz "\n The unsigned value is: "
	displaySigned: .asciiz "\n The signed value is: "
	displayMNError: .asciiz "\n The sum of M and N must not exceed P!"

	.text
	.globl main
main:
	addu  $s7, $0, $ra  #save the return address in a global register
	
loop: 
	li $v0, 4
	la $a0, askP 	# ask p
	syscall 
	
	li $v0, 5 # read_int
	syscall
	
	beqz  $v0, exit    # terminate on 0 value
	move $s0, $v0 # p is now stored in $s0.
	
	li $v0, 4
	la $a0, askM # ask M
	syscall
	
	li $v0, 5,
	syscall
	move $s3, $v0 # m is now stored in $s3.
	
	li $v0, 4
	la $a0, askN # ask N
	syscall
	
	li $v0, 5
	syscall
	move $s4, $v0 # n is now stored in $s4
	
	li $t0, 0 # Now check if the sum of M and N is greater than P
	add $t0, $s4, $s3
	bgt $t0, $s0, displayMNError
	
	
	move $a2, $s0 # first argument is p
	move $a1, $s3 # second argument is m
	move $a0, $s4 # third argument is n
	jal extractExt
	
	move $s2, $v0 # s2 now contains the unsigned value.
	
	li $t1, 0
	li $t5, 32
	sub $t1, $t5, $s4 # t1 = 32 - n
	
	sll $s1, $s2, $t1
	sra $s1, $s1, $t1 # s3 now has the signed value.
	
	
displayResults:
	
	li $v0, 4
	la $a0, displaySigned
	syscall 
	
	li $v0, 1
	move $a0, $s1 # signed value displayed.
	syscall
	
	li $v0, 4
	la $a0, displayUnsigned
	syscall
	
	li $v0, 1
	move $a0, $s2 # unsigned value displayed.
	syscall

	j loop

showError: 
	li $v0, 4
	la $a0, displayMNError
	syscall

exit:	
	# Usual stuff at the end of the main
    addu  $ra, $0, $s7  # restore the return address
    jr  $ra             # return to the main program
    add  $0, $0, $0     # nop
	
	
# ---------------------- main extract func -------------------------------
	.globl extractExt
extractExt:

	li $t0, 0
	addi $t0, 0, 0xffffffff # add all ones into t0
	li $t5, 32
	sub $t1, $t5, $a0 # t1 = 32 - n
	
	srl $t0, $t0, $t1 # shift t0 right by t1.
	sll $t0, $t0, $a1 # shift t0 left by m, i.e a1
	# now mask is in t0, ready.
	
	and $t2, $t0, $a2 # now t2 has the and of mask and p.
	srl $t2, $t2, $a1 # put the least significant bit in first.
	
	move $v0, $t2
	
	jr $ra
	

