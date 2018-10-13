# This program reads 6 bytes worth of data from the user and then
# after the 6 byte buffer is full, displays it to the user and terminates
# Everything is done using memory mapped IO/ Polling.
# No syscalls used.

 .text
    .globl main
main:                          # main has to be a global label
     addu $s7, $0, $ra         # save the return address in a global register
	 
 .data
 .globl inputMsg
 
inputMsg:		.asciiz "Please start entering characters: \n"
charBuffer:		.space 6 # 6 byte buffer space.

 .text
 
	li $v0, 4 # print_str
	la $a0, inputMsg # print inputMsg
	syscall # initial syscall used only for displaying inputMsg.
	 
	li  $t0, 0xffff            # first place 0000ffff in $t0
    sll $t0, $t0, 16           # so we now have ffff0000 in $t0
 
	li $t3, 0 # first index of charbuffer
	la $t4, charBuffer # address of charbuffer into t4.
	li $t5, 5 # total input value - 1.
	
 
startReading:
	lw   $t1, 0($t0)           # receiver control
    andi $t1, $t1,0x0001       # check if ready
    beq  $t1, $zero, startReading   # if not ready back to startReading
    lb   $s0, 4($t0)           # receiver data, input from user.
	
	add $t7, $t3, $t4 # t7 now has the exact location to put our data
	
	sb $s0, 0($t7) # store the input value s0 into correct index of charBuffer
	
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
	
	beq $t3, $t5, Exit
	addi $t3, $t3, 1
	j writeBuffer # go back to read again.
	
Exit:
	 # Usual stuff at the end of the main
    addu	$ra, $0, $s7       # restore the return address
    jr  $ra                    # return to the main program
    add $0, $0, $0             # nop
 
 
 
 

