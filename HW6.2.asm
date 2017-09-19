.data
	message:	.asciiz		"Enter a number: "
	message2:	.asciiz		"Your number is equal to: "
	days:		.asciiz		" days, "
	hours:		.asciiz		" hours, "
	minutes:	.asciiz		" minutes and "
	seconds:	.asciiz		" seconds."
	
.text
	main:
		li	$v0,4
		la	$a0,message
		syscall
		li	$v0,5
		syscall
		add	$a1,$zero,$v0
		li	$v0,4
		la	$a0,message2
		syscall
		
		
		jal	day
		
	exit:
		li	$v0,10
		syscall
		
		
	day:
		addi	$t0,$zero,86400
		div	$a1,$t0
		mflo	$t1
		mfhi	$t2		
		
		
		li	$v0,1
		addi	$a0,$t1,0
		syscall
		
		li	$v0,4
		la	$a0,days
		syscall
		j	hour
		
	hour:
		addi	$t0,$zero,24
		div	$t2,$t0
		mflo	$t1
		mfhi	$t2
		
		li	$v0,1
		addi	$a0,$t1,0
		syscall
		
		li	$v0,4
		la	$a0,hours
		syscall
		j	minute
		
	minute:
		addi	$t0,$zero,60
		div	$t2,$t0
		mflo	$t1
		mfhi	$t2
		
		li	$v0,1
		addi	$a0,$t1,0
		syscall
		
		li	$v0,4
		la	$a0,minutes
		syscall
		
		li	$v0,1
		addi	$a0,$t2,0
		syscall
		li	$v0,4
		la	$a0,seconds
		syscall
		jr	$ra
		
	
	
		
		
		