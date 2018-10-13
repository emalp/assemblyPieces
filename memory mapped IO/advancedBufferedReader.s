# This program reads 6 bytes worth of data from the user and then
# after the 6 byte buffer is full, displays it to the user and goes back to read again.
# '#' is the terminator. If pressed, it terminates the program and then displays out the leftover chars and terminates.
# Everything is done using memory mapped IO/ Polling.
# No syscalls used.
# '#' is the terminating character used to terminate the shit.

# s1 has the terminating character.
# s2 has the current character input count.
# s3 has the round count.

 .text
    .globl main
main:                          # main has to be a global label
     addu $s7, $0, $ra         # save the return address in a global register
	 
 .data
 .globl inputMsg
 
inputMsg:		.asciiz "Please start entering characters: \n"
terminatingMsg:	.asciiz "\nProgram terminating...\n"
newLine:	.asciiz "\n"
charBuffer:		.space 6 # 6 byte buffer space.
terminatingCharacter:	.ascii "#"

 .text
 
	li $v0, 4 # print_str
	la $a0, inputMsg # print inputMsg
	syscall # initial syscall used only for displaying inputMsg.
	 
	li  $t0, 0xffff            # first place 0000ffff in $t0
    sll $t0, $t0, 16           # so we now have ffff0000 in $t0
 
 
	la $s1, terminatingCharacter
	lb $s1, 0($s1) # now s1 has the terminating character '#' in it.
	
	li $s2, 0 # s2 is the current character count.
	li $s3, 0 # s3 is the round counter.
	
	la $t4, charBuffer # address of charbuffer into t4.
	li $t5, 5 # total input value - 1.
	
startReadingInter:
	addi $s3, $s3, 1 # add round number (rounds of 6)
	li $t3, 0 # irst index of charbuffer
 
startReading:
	lw   $t1, 0($t0)           # receiver control
    andi $t1, $t1,0x0001       # check if ready
    beq  $t1, $zero, startReading   # if not ready back to startReading
    lb   $s0, 4($t0)           # receiver data, input from user.
	
	#now if the current input value is the terminator value then print shit.
	beq $s0, $s1, writeAndTerminate
	
	add $t7, $t3, $t4 # t7 now has the exact location to put our data
	sb $s0, 0($t7) # store the input value s0 into correct index of charBuffer
	
	addi $s2, $s2, 1 # increase the counter eveytime something is entered.
	
	beq $t3, $t5, intermediate
	addi $t3, $t3, 1
	j startReading # go back to read again.
	
intermediate:
	# this is the reader writer connector
	li $t3, 0 # place back the initial index.
	
writeBuffer:
	# do shit here.
	lw  $t1, 8($t0)            # transmitter control
    andi $t1, $t1,0x0001       # check if ready
    beq  $t1, $zero, writeBuffer  # if not ready
	
	add $t7, $t3, $t4 # t7 now has the exact location to output our data
	
	lb $t2, 0($t7) # put the value in t7 into t2.
	sb $t2, 12($t0)
	
	beq $t3, $t5, startReadingInter
	addi $t3, $t3, 1
	j writeBuffer # go back to read again.
	
writeAndTerminate:
	# write the leftovers and terminate
	li $v0, 4
	la $a0, terminatingMsg # print out the terminating msg.
	syscall
	
	li $v0, 1
	move $a0, $s2
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	li $s5, 0
	mul $s4, $s3, 6 # total character with multiples of 6 before this one's
	sub $s6, $s4, $s2 # now the number of chars we nee to iterate.
	sub $s6, $s6, 1 # -1 
	
loopWrite:
	
	lw  $t1, 8($t0)            # transmitter control
    andi $t1, $t1,0x0001       # check if ready
    beq  $t1, $zero, loopWrite  # if not ready
	
	add $t7, $s5, $t4 # t7 now has the exact location to output our data
	
	lb $t2, 0($t7) # put the value in t7 into t2.
	sb $t2, 12($t0)
	
	beq $s5, $s6, Exit 
	
	addi $s5, $s5, 1 # increment counter.
	j loopWrite
	
	
Exit:
	 # Usual stuff at the end of the main
    addu	$ra, $0, $s7       # restore the return address
    jr  $ra                    # return to the main program
    add $0, $0, $0             # nop
 
 
 
 

