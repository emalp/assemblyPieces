    .text
    .globl  main
main:                       # main has to be a global label
    addu $s7, $0, $ra       # save the return address in a global register
	.data
number1: .double 0.0
number2: .double 1.0	
	.text
	ldc1 $f2, number1
	ldc1 $f4, number2
	addi $s4, $0, 51
	addi $s5, $0, 2
#--------------------------------------Get user input 
	.data
    .globl inputNmsg
inputNmsg:  .asciiz  "\nEnter Index :"
message1:  .asciiz "\nInput is greater than 45, less than 2 try again"

    .text
inputLoop:	
    li   $v0, 4             # print_str
    la   $a0, inputNmsg     # takes the address of string as an argument
    syscall
    li   $v0, 5             # read_int
    syscall
    add  $s3, $0, $v0       # The value of N has been read into $s1
	
	bge  $s3, $s4, Error
	blt  $s3, $s5, Error
	

    add  $a0, $0, $s3       # set the parameter to N for fact call
    jal  fib                # Call the factorial function
    add  $s0, $0, $v0 
	blt  $s3, $s4, Exit
	
Error:
	li  $v0, 4         
	la  $a0, message1  
	syscall	
	j inputLoop
	
Exit:
#--------------------------------------Print output
	.data
    .globl  outputMsg
outputMsg:  .asciiz  "\nFibonacci Value = "
    .text
    li   $v0, 4             # print_str 
    la   $a0, outputMsg     # takes the address of string as an argument 
    syscall                 # output the label
    li   $v0, 3             # print_int
    add  $a0, $0, $s0       # takes integer
    syscall                 # output f

  # Usual stuff at the end of the main
    addu $ra, $0, $s7       # restore the return address
    jr   $ra                # return to the main program
    add  $0, $0, $0         # nop
	
	# --- fibonacci function.
	.globl  fib            # function named "fib"
fib:
    add  $v0, $zero, 0      # prepare return = 0
	li   $t0, 1	
L2: 
    bne  $t0, $a0, L1       #
    jr  $ra                 # all done, return
L1:
    add.d  $f12, $f2, $f4      # yes finally we can calculate
    addi   $t0, $t0, 1         # increment counter
	mov.d  $f2, $f4
	mov.d  $f4, $f12
	#cvt.w.d $f14, $f12
	mfc1   $v0, $f14
    j  L2                   # jump to L2