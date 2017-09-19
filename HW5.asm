#	Joshua Duncan
#	05/02/2016
#	CS 2430


.data

	message:	.asciiz		"Enter a positive Integer: "	
	messageEven:	.asciiz		"The number is even."
	messageOdd:	.asciiz		"The number is odd."
	
.text

	main:
	
	li	$v0,4
	la	$a0,message	# ask user for a number
	syscall
	li	$v0,5		# get number;
	syscall
	
	lui	$v0,0x1234	# unsigned, is only allowed for 16 bits; if user enters negative number
	ori	$v0,$v0,0x5678	# take the positive value
	
	addi	$t0,$zero,2	# assign the value 2 to $t0;
	div	$v0,$t0		# divide the integer by 2;
	mflo	$v0		# quotient;
	mfhi	$v1		# remainder;
	
	beq	$v1,$zero,even	# if( $v1 == $zero ) go to even;
	b	odd		# else go to odd;
	
	exit:
		li	$v0,10
		syscall
	
	even:
		li	$v0,4
		la	$a0,messageEven
		syscall
		b	exit
	odd:
		li	$v0,4
		la	$a0,messageOdd
		syscall
		b 	exit
