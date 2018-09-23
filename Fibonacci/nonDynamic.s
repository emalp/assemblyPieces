# start of the main program
# implements iterative version of fibonacci.
# the program uses recursion but is non dynamic.
# main assumes:
#  f is in $s0 and n is in $s1
# /********** written by emalp **********\

    .text
    .globl  main
main:                       # main has to be a global label
    addu $s7, $0, $ra       # save the return address in a global register

  # Prompt and input the value of N
    .data
    .globl inputNmsg
inputNmsg:  .asciiz  "\nEnter N: "
inputWarning: .asciiz "\nPlease enter n less than 45 and greater than 2: "

    .text
readN:
    li   $v0, 4             # print_str
    la   $a0, inputNmsg     # takes the address of string as an argument
    syscall
    li   $v0, 5             # read_int
    syscall
	move $s1, $v0
    #add  $s1, $0, $v0       # The value of N has been read into $s1

checkN:
	li $t0, 2
	li $t1, 45
	bgt $s1, $t1, showWarning
	blt $s1, $t0, showWarning

continueFib:
	move $a0, $s1
    #add  $a0, $0, $s1       # set the parameter to N for fib call
    jal  fib               # Call the fibonacci function
    move $s0, $v0       # f = fib(N);
	j outputResult
	
showWarning:
	li $v0, 4
	la $a0, inputWarning
	syscall
	
	li $s1, 0
	j readN

outputResult:
  
  #  Output the result
    .data
    .globl  outputMsg
outputMsg:  .asciiz  "Fibonacci of N = "
    .text
    li   $v0, 4             # print_str 
    la   $a0, outputMsg     # takes the address of string as an argument 
    syscall                 # output the label
    li   $v0, 1             # print_int
	move $a0, $s0
    #add  $a0, $0, $s0       # takes integer
    syscall                 # output f

  # Usual stuff at the end of the main
    addu $ra, $0, $s7       # restore the return address
    jr   $ra                # return to the main program
    add  $0, $0, $0         # nop

	# ------------------------------------ FIBONACCI function is here: ----------------------------------------
    .globl  fib            # function named "fib"

fib:
	sub  $sp, $sp, 12        # make space on the stack for 3 items
    sw   $ra, 8($sp)        # save the return address on the stack 
	sw   $s1, 4($sp) # replace s2 with s1.
	sw   $s3, 0($sp)
		
	move $s1, $a0 # move data from a0 to s1.
	beq $s1, 0, nZero # If 0 then goto nZero.
	beq $s1, 1, nOne # if 1 then goto nOne.
	
nElse:
	addi $a0, $s1, -1 # Place a0 = n - 1
	jal fib # First jump and link 
	move $s3, $v0
	
	addi $a0, $s1, -2 # Place a0 = n - 2
	jal fib # Second jump and link.
	add  $v0, $s3, $v0     # v0 = fib(n-1) + fib(n-2)
	
	j nExit
	
nZero:
	li $v0, 0
	j nExit
	
nOne:
	li $v0, 1  # First nOne operation
	
nExit:
	lw   $ra, 8($sp)        # restore the return address
	lw   $s1, 4($sp)
	lw   $s3, 0($sp)
    addi  $sp, $sp, 12        # release the save area on the stack
	jr $ra
