.data
	message: 		.asciiz	"array["
	message2: 		.asciiz	"]: "
	newLine:		.asciiz "\n"
	printMessage:		.asciiz	"This is the array: "
	space:			.asciiz	" "
	whileMessage:		.asciiz	"Menu:\n Enter 1 to switch Rows\n Enter 2 to switch Cols\n Enter 0 to Quit\n"
	moveRowMessage1:	.asciiz	"Which Row would you like to switch, Enter a number 1-5: "
	moveRowMessage2:	.asciiz	"Which Row would you like to switch with, Enter a number 1-5: "
	moveColMessage1:	.asciiz	"Which Col would you like to switch, Enter a number 1-5: "
	moveColMessage2:	.asciiz	"Which Col would you like to switch with, Enter a number 1-5: "
	
.text
	main:
		addi	$sp,$sp,-140		# make room on the stack for array of 25 elements, and 2 1x5 arrays for
						#	moving rows/columns
		jal	getArray
		addi	$sp,$sp,-100		# set $sp back at top of stack
		
		jal	printArray
		addi	$sp,$sp,-100		# set $sp back at top of stack
		
	while:
	
######################## WHILE MENU ######################################
		li	$v0,4			# Menu:			 #
		la	$a0,newLine		# Enter 1 to switch Rows #
		syscall				# Enter 2 to switch Cols #
		li	$v0,4			# Enter 0 to Quit	 #
		la	$a0,whileMessage	#			 #
		syscall				#			 #
##########################################################################

		move	$t7,$zero			# set value of $t7 to zero ( make sure it's empty );
		addi	$t7,$zero,3			# set $t7 to some arbitrary value that is not part of our menu;
		li	$v0,5				# get the users selection;
		syscall	
		
		move	$t7,$v0				# set our comparitor to the users entered value;
		beq	$t7,1,moveRow			# self explanatory;
		beq	$t7,2,moveCol			# self explanatory;
		beq	$t7,0,exit			# if user enters 0, go to exit function;
		
	whileLoop:	
		jal	printArray			# print Array after every move;
		bnez	$t7,while			# while our user has not entered 0, repeat the menu;	
		
	exit:
		li	$v0,10
		syscall
		
		
#------------------------------------------------------------------------------------------------#
#------------------------------------------- MOVE COL -------------------------------------------#
#------------------------------------------------------------------------------------------------#		
	
	moveCol:
		move	$t7,$zero
		addi	$t7,$t7,1
		li	$v0,4					
		la	$a0,moveColMessage1			
		syscall
		li	$v0,5
		syscall
		
		move	$a2,$zero				
		move	$a2,$v0					
		beq	$v0,1,moveCol1
		beq	$v0,2,moveCol2
		beq	$v0,3,moveCol3
		beq	$v0,4,moveCol4
		beq	$v0,5,moveCol5
		
	move_Col:
		li	$v0,4					#
		la	$a0,moveColMessage2			# "Which Row would you like to switch with, Enter a number 1-5: "
		syscall
		li	$v0,5
		syscall
		
		beq	$v0,1,col1PreMove
		beq	$v0,2,col2PreMove
		beq	$v0,3,col3PreMove
		beq	$v0,4,col4PreMove
		beq	$v0,5,col5PreMove
		
####################################### MOVE COL ONE ###############################################

	############################### COLUMN ONE IS PICKED FIRST ###########################

	moveCol1:
		move	$t0,$zero		# intialize $t0 to 0;
		move	$t1,$zero		# intialize $t1 to 0;
		addi	$t0,$t0,20		# increment our $sp by 20 each time;
	mover:
		lw	$s0,0($sp)		# get word at current position
		jal	save			# jump to save
		# return from save here
		addi	$t1,$t1,4		# increase the $t1 by 4 to mark one new element added to tempArray
		add	$sp,$sp,$t0		# add our $t0 value to access next element in the column
		bne	$t0,100,mover
		
		addi	$sp,$sp,-100
		b	move_Col		# return to the column transfer menu, we are done saving the first array
	save:
		sub	$sp,$sp,$t0		# set sp back to 0
		addi	$sp,$sp,100		# move sp to front of tempArray1
		add	$sp,$sp,$t1		# add the value of $t1, to skip over values we have added 
		sw	$s0,0($sp)		# save the word
		sub	$sp,$sp,$t1		# move back to head of tempArray
		addi	$sp,$sp,-100		# move back to top of stack
		add	$sp,$sp,$t0		# move the pointer back to the location before we came
		addi	$t0,$t0,20		# increment the $t0 by 20 before we head back
		
		jr	$ra			# return
		
	############################### COLUMN ONE IS PICKED SECOND ###########################
	
	col1PreMove:
		move	$t0,$zero		# intialize $t0 to 0;
		move	$t1,$zero		# intialize $t1 to 0;
	col1PreMover:
		lw	$s0,0($sp)		# get word at current position @0/ @20/ @40/ @60
		jal	col1PreMoveSave			# jump to save
		# return from save here
		addi	$t1,$t1,4		# increase the $t1 by 4 to mark one new element added to tempArray @4/ @8/ @12/
		add	$sp,$sp,$t0		# add our $t0 value to access next element in the column @20/ @40/ @60/
		bne	$t0,100,col1PreMover
		
		addi	$sp,$sp,-100
		b	col1PreMoveCopy
		
	col1PreMoveSave:
		sub	$sp,$sp,$t0		# set sp back to +0@0/ -20@0/ -40@0/
		addi	$sp,$sp,120		# move sp to front of tempArray1 @120/ @120/ @120/
		add	$sp,$sp,$t1		# add the value of $t1, to skip over values we have added 0+@120/ +4@124/ +8@128/
		sw	$s0,0($sp)		# save the word
		sub	$sp,$sp,$t1		# move back to head of tempArray -0@120/ -4@120/ -8@120/
		addi	$sp,$sp,-120		# move back to top of stack @0/ @0/ @0/
		addi	$t0,$t0,20		# increment the $t0 by 20 before we head back @20/ @40/ @60/
		
		jr	$ra			# return
	
	col1PreMoveCopy:
		addi	$sp,$sp,100		# tempArray1 starts at index 100 in the stack;
		move	$t0,$zero		# intialize $t0 to 0;
		move	$t1,$zero		# intialize $t1 to 0;
		
	col1StartMove:
		lw	$s0,0($sp)		# get the word from first index in tempArray1 @100/ @104/ @108/
		jal	col1FinishMove
		# return here
		addi	$t1,$t1,4		# increase our place holder in tempArray @4/ @8/
		add	$sp,$sp,$t1		# move to next index in our tempArray @104/ @108/
		bne	$t1,20,col1StartMove 	# @4/ @8/
		
		addi	$sp,$sp,-120
		bnez	$t7,secondMove
		b whileLoop	
		
	col1FinishMove:
		sub	$sp,$sp,$t1		# set sp back to -0@100/ -4@100/ -8@100/
		addi	$sp,$sp,-100		# move sp to front of array @0/ @0/ @0/
		add	$sp,$sp,$t0		# add the value of $t0, to skip over values we have added +0@0/ @20/ @40/
		sw	$s0,0($sp)		# save the word
		sub	$sp,$sp,$t0		# move back to head of the stack +0@0/ -20@0/
		addi	$sp,$sp,100		# move back to top of arrayTemp @100/ @100/
		addi	$t0,$t0,20		# increment the $t0 by 20 before we head back @20/ @40/
		
		jr	$ra			# return
		
		
		
####################################### MOVE COL TWO ###############################################

	############################### COLUMN TWO IS PICKED FIRST ###########################

	moveCol2:
		addi	$sp,$sp,4		# column 2 starts at second spot in the stack
		move	$t0,$zero		# intialize $t0 to 0;
		move	$t1,$zero		# intialize $t1 to 0;
	mover2:
		lw	$s0,0($sp)		# get word at current position
		addi	$sp,$sp,-4		# set stack pointer to 0 before the jump
		jal	save2			# jump to save
		# return from save here
		addi	$t1,$t1,4		# increase the $t1 by 4 to mark one new element added to tempArray
		add	$sp,$sp,$t0		# add our $t0 value to access next element in the column
		bne	$t0,100,mover2
		
		addi	$sp,$sp,-104
		b	move_Col
	save2:
		sub	$sp,$sp,$t0		# set sp back to 0
		addi	$sp,$sp,100		# move sp to front of tempArray1
		add	$sp,$sp,$t1		# add the value of $t1, to skip over values we have added 
		sw	$s0,0($sp)		# save the word
		addi	$sp,$sp,-96		# move back to top of stack
		addi	$t0,$t0,20		# increment the $t0 by 20 before we head back
		
		jr	$ra			# return
		
		
	############################### COLUMN TWO IS PICKED SECOND ###########################

	col2PreMove:
		addi	$sp,$sp,4		# column 2 starts at second spot in the stack
		move	$t0,$zero		# intialize $t0 to 0;
		move	$t1,$zero		# intialize $t1 to 0;
	col2PreMover:
		lw	$s0,0($sp)		# get word at current position @4/ @24/ @44/
		addi	$sp,$sp,-4		# set stack pointer to 0 before the jump @0/ @20/ @40
		jal	col2PreMoveSave		# jump to save
		# return from save here
		addi	$t1,$t1,4		# increase the $t1 by 4 to mark one new element added to tempArray 0+@4/ +4@8/
		add	$sp,$sp,$t0		# add our $t0 value to access next element in the column 20+4@24/ 40+4@44/
		bne	$t0,100,col2PreMover
		
		addi	$sp,$sp,-104
		b	col2PreMoveCopy
		
	col2PreMoveSave:
		sub	$sp,$sp,$t0		# set sp back to @0/ 20-20@0/
		addi	$sp,$sp,120		# move sp to front of tempArray1 @120/ @120/
		add	$sp,$sp,$t1		# add the value of $t1, to skip over values we have added +0@120/ @124/
		sw	$s0,0($sp)		# save the word 
		sub	$sp,$sp,$t1		# move pointer back -0@120/ -4@120/
		addi	$sp,$sp,-116		# move back to top of stack @4/ @4/
		sub	$sp,$sp,$t0		# move the pointer back to the location before we came +0@4/ -20@4/ -40@4
		addi	$t0,$t0,20		# increment the $t0 by 20 before we head back +20@20/ @40/ @60
		
		jr	$ra			# return	
		
	col2PreMoveCopy:
		addi	$sp,$sp,100		# tempArray1 starts at index 100 in the stack;
		move	$t0,$zero		# intialize $t0 to 0;
		move	$t1,$zero		# intialize $t1 to 0;
		
	col2StartMove:
		lw	$s0,0($sp)		# get the word from first index in tempArray1 @100 @104 @108 @112 @116
		jal	col2FinishMove
		# return here
		add	$sp,$sp,4		# move to next index in our tempArray @104 @108 @112 @116
		addi	$t1,$t1,4		# increase our place holder in tempArray @4 @8 @12 @16
		
		bne	$t1,20,col2StartMove 	# @20 @40 @60 @80
		
		addi	$sp,$sp,-120
		bnez	$t7,secondMove
		b whileLoop	
		
	col2FinishMove:
		addi	$sp,$sp,4		# @104 @108 @112 @116
		sub	$sp,$sp,$t1		# set sp back to 0 @104 @104 @104 @104
		addi	$sp,$sp,-100		# move sp to front of array @4 @4 @4 @4
		add	$sp,$sp,$t0		# add the value of $t0, to skip over values we have added @4 @24 @44 @64
		sw	$s0,0($sp)		# save the word
		sub	$sp,$sp,$t0		# move back to head of the stack @4 @4 @4 @4
		addi	$sp,$sp,96		# move back to top of arrayTemp @100 @100 @100 @100
		add	$sp,$sp,$t1		# move the pointer back to the location in tempArray before we came @100 @104 @108 @112
		addi	$t0,$t0,20		# increment the $t0 by 20 before we head back @20 @40 @60 @80
		
		jr	$ra			# return
		
				
####################################### MOVE COL THREE #############################################

	############################### COLUMN THREE IS PICKED FIRST ###########################

	moveCol3:
		addi	$sp,$sp,8		# column 3 starts at third spot in the stack
		move	$t0,$zero		# intialize $t0 to 0;
		move	$t1,$zero		# intialize $t1 to 0;
	mover3:
		lw	$s0,0($sp)		# get word at current position
		addi	$sp,$sp,-8		# set stack pointer to 0 before the jump
		jal	save3			# jump to save
		# return from save here
		addi	$t1,$t1,4		# increase the $t1 by 4 to mark one new element added to tempArray
		add	$sp,$sp,$t0		# add our $t0 value to access next element in the column
		bne	$t0,100,mover3
		
		addi	$sp,$sp,-108
		b	move_Col
	save3:
		sub	$sp,$sp,$t0		# set sp back to 0
		addi	$sp,$sp,100		# move sp to front of tempArray1
		add	$sp,$sp,$t1		# add the value of $t1, to skip over values we have added 
		sw	$s0,0($sp)		# save the word
		addi	$sp,$sp,-92		# move back to top of stack
		addi	$t0,$t0,20		# increment the $t0 by 20 before we head back
		
		jr	$ra			# return
		
	
	############################### COLUMN THREE IS PICKED SECOND ###########################

	col3PreMove:
		addi	$sp,$sp,8		# column 3 starts at third spot in the stack
		move	$t0,$zero		# intialize $t0 to 0;
		move	$t1,$zero		# intialize $t1 to 0;
	col3PreMover:
		lw	$s0,0($sp)		# get word at current position
		addi	$sp,$sp,-8		# set stack pointer to 0 before the jump
		jal	col3PreMoveSave			# jump to save
		
		# return from save here
		addi	$t1,$t1,4		# increase the $t1 by 4 to mark one new element added to tempArray
		add	$sp,$sp,$t0		# add our $t0 value to access next element in the column
		bne	$t0,100,col3PreMover
		
		addi	$sp,$sp,-108
		b	col3PreMoveCopy
		
	col3PreMoveSave:
		sub	$sp,$sp,$t0		# set sp back to 0
		addi	$sp,$sp,120		# move sp to front of tempArray1
		add	$sp,$sp,$t1		# add the value of $t1, to skip over values we have added 
		sw	$s0,0($sp)		# save the word
		addi	$sp,$sp,-112		# move back to top of stack
		addi	$t0,$t0,20		# increment the $t0 by 20 before we head back
		
		jr	$ra			# return	
		
	col3PreMoveCopy:
		addi	$sp,$sp,100		# tempArray1 starts at index 100 in the stack;
		move	$t0,$zero		# intialize $t0 to 0;
		move	$t1,$zero		# intialize $t1 to 0;
		
	col3StartMove:
		lw	$s0,0($sp)		# get the word from first index in tempArray1 @100 @104 @108 @112 @116
		jal	col3FinishMove
		# return here
		add	$sp,$sp,4		# move to next index in our tempArray @104 @108 @112 @116
		addi	$t1,$t1,4		# increase our place holder in tempArray @4 @8 @12 @16
		
		bne	$t1,20,col3StartMove 	# @20 @40 @60 @80
		
		addi	$sp,$sp,-120
		bnez	$t7,secondMove
		b whileLoop	
		
	col3FinishMove:
		addi	$sp,$sp,8		# @108 @112 @112 @116
		sub	$sp,$sp,$t1		# set sp back to 0 @108 @108 @104 @104
		addi	$sp,$sp,-100		# move sp to front of array @8 @8 @4 @4
		add	$sp,$sp,$t0		# add the value of $t0, to skip over values we have added @8 @28 @44 @64
		sw	$s0,0($sp)		# save the word
		sub	$sp,$sp,$t0		# move back to head of the stack @8 @8 @4 @4
		addi	$sp,$sp,92		# move back to top of arrayTemp @100 @100 @100 @100
		add	$sp,$sp,$t1		# move the pointer back to the location in tempArray before we came @100 @104 @108 @112
		addi	$t0,$t0,20		# increment the $t0 by 20 before we head back @20 @40 @60 @80
		
		jr	$ra			# return
		
		
		
####################################### MOVE COL FOUR ##############################################

	############################### COLUMN FOUR IS PICKED FIRST ###########################

	moveCol4:
		addi	$sp,$sp,12		# column 4 starts at fourth spot in the stack
		move	$t0,$zero		# intialize $t0 to 0;
		move	$t1,$zero		# intialize $t1 to 0;
	mover4:
		lw	$s0,0($sp)		# get word at current position
		addi	$sp,$sp,-12		# set stack pointer to 0 before the jump
		jal	save4			# jump to save
		# return from save here
		addi	$t1,$t1,4		# increase the $t1 by 4 to mark one new element added to tempArray
		add	$sp,$sp,$t0		# add our $t0 value to access next element in the column
		bne	$t0,100,mover4
		
		addi	$sp,$sp,-112
		b	move_Col
	save4:
		sub	$sp,$sp,$t0		# set sp back to 0
		addi	$sp,$sp,100		# move sp to front of tempArray1
		add	$sp,$sp,$t1		# add the value of $t1, to skip over values we have added 
		sw	$s0,0($sp)		# save the word
		addi	$sp,$sp,-88		# move back to top of stack
		addi	$t0,$t0,20		# increment the $t0 by 20 before we head back
		
		jr	$ra			# return
		
		
	############################### COLUMN FOUR IS PICKED SECOND ###########################

	col4PreMove:
		addi	$sp,$sp,12		# column 4 starts at fourth spot in the stack
		move	$t0,$zero		# intialize $t0 to 0;
		move	$t1,$zero		# intialize $t1 to 0;
	col4PreMover:
		lw	$s0,0($sp)		# get word at current position @12/ @32/ @52/
		addi	$sp,$sp,-12		# set stack pointer to 0 before the jump @0/ @20/ @40/
		jal	col4PreMoveSave			# jump to save
		
		# return from save here
		addi	$t1,$t1,4		# increase the $t1 by 4 to mark one new element added to tempArray @4/ @8/
		add	$sp,$sp,$t0		# add our $t0 value to access next element in the column @32/ @52/
		bne	$t0,100,col4PreMover
		
		addi	$sp,$sp,-112
		b	col4PreMoveCopy
		
	col4PreMoveSave:
		sub	$sp,$sp,$t0		# set sp back to +0@0/ -20@0/ -40@0/
		addi	$sp,$sp,120		# move sp to front of tempArray1 @120/ @120/ @120/ 
		add	$sp,$sp,$t1		# add the value of $t1, to skip over values we have added +0@120/ +4@124/
		sw	$s0,0($sp)		# save the word
		sub	$sp,$sp,$t1		# @120/, @120/
		addi	$sp,$sp,-108		# move back to top of stack @12/ @12/
		addi	$t0,$t0,20		# increment the $t0 by 20 before we head back @20/ @40/
		
		jr	$ra			# return	
		
	col4PreMoveCopy:
		addi	$sp,$sp,100		# tempArray1 starts at index 100 in the stack;
		move	$t0,$zero		# intialize $t0 to 0;
		move	$t1,$zero		# intialize $t1 to 0;
		
	col4StartMove:
		lw	$s0,0($sp)		# get the word from first index in tempArray1 @100/ @104/ @108/ @112 @116
		jal	col4FinishMove
		
		# return here
		add	$sp,$sp,4		# move to next index in our tempArray @104/ @108/ @112 @116
		addi	$t1,$t1,4		# increase our place holder in tempArray @4/ @8/ @12 @16
		bne	$t1,20,col4StartMove 	# @4 @8/
		
		addi	$sp,$sp,-120
		bnez	$t7,secondMove
		b whileLoop		
		
	col4FinishMove:
		addi	$sp,$sp,12		# @112/ @116/ @120/ @116
		sub	$sp,$sp,$t1		# set sp back to 0 @112/ @112/ @112/ @104
		addi	$sp,$sp,-100		# move sp to front of array @12/ @12/ @12/ @4
		add	$sp,$sp,$t0		# add the value of $t0, to skip over values we have added @12/ @32/ @44 @64
		sw	$s0,0($sp)		# save the word
		sub	$sp,$sp,$t0		# move back to head of the stack @12/ @12/ @4 @4
		addi	$sp,$sp,88		# move back to top of arrayTemp @100/ @100/ @100 @100
		add	$sp,$sp,$t1		# move the pointer back to the location in tempArray before we came @100/ @104 @108 @112
		addi	$t0,$t0,20		# increment the $t0 by 20 before we head back @20/ @40/ @60 @80
		
		jr	$ra			# return
		
		
####################################### MOVE COL FIVE ##############################################	

	############################### COLUMN FIVE IS PICKED FIRST ###########################

	moveCol5:
		addi	$sp,$sp,16		# column 5 starts at 5th spot in the stack
		move	$t0,$zero		# intialize $t0 to 0;
		move	$t1,$zero		# intialize $t1 to 0;
	mover5:
		lw	$s0,0($sp)		# get word at current position
		addi	$sp,$sp,-16		# set stack pointer to 0 before the jump
		jal	save5			# jump to save
		# return from save here
		addi	$t1,$t1,4		# increase the $t1 by 4 to mark one new element added to tempArray
		add	$sp,$sp,$t0		# add our $t0 value to access next element in the column
		bne	$t0,100,mover5
		
		addi	$sp,$sp,-116
		b	move_Col
	save5:
		sub	$sp,$sp,$t0		# set sp back to 0
		addi	$sp,$sp,100		# move sp to front of tempArray1
		add	$sp,$sp,$t1		# add the value of $t1, to skip over values we have added 
		sw	$s0,0($sp)		# save the word
		addi	$sp,$sp,-84		# move back to top of stack
		addi	$t0,$t0,20		# increment the $t0 by 20 before we head back
		
		jr	$ra			# return
		
	############################### COLUMN FIVE IS PICKED SECOND ###########################

	col5PreMove:
		addi	$sp,$sp,16		# column 4 starts at fourth spot in the stack
		move	$t0,$zero		# intialize $t0 to 0;
		move	$t1,$zero		# intialize $t1 to 0;
	col5PreMover:
		lw	$s0,0($sp)		# get word at current position @16/ @36/ @56/
		addi	$sp,$sp,-16		# set stack pointer to 0 before the jump @0/ @20/ @40/
		jal	col5PreMoveSave			# jump to save
		
		# return from save here
		addi	$t1,$t1,4		# increase the $t1 by 4 to mark one new element added to tempArray @4/ @8/
		add	$sp,$sp,$t0		# add our $t0 value to access next element in the column @36/ @56/
		bne	$t0,100,col5PreMover
		
		addi	$sp,$sp,-116		# set our $sp back to 0;
		b	col5PreMoveCopy
		
	col5PreMoveSave:
		sub	$sp,$sp,$t0		# set sp back to +0@0/ -20@0/ -40@0/
		addi	$sp,$sp,120		# move sp to front of tempArray1 @120/ @120/ @120/ 
		add	$sp,$sp,$t1		# add the value of $t1, to skip over values we have added +0@120/ +4@124/
		sw	$s0,0($sp)		# save the word
		sub	$sp,$sp,$t1		# @120/, @120/
		addi	$sp,$sp,-104		# move back to top of stack @16/ @16/
		addi	$t0,$t0,20		# increment the $t0 by 20 before we head back @20/ @40/
		
		jr	$ra			# return	
		
	col5PreMoveCopy:
		addi	$sp,$sp,100		# tempArray1 starts at index 100 in the stack;
		move	$t0,$zero		# intialize $t0 to 0;
		move	$t1,$zero		# intialize $t1 to 0;
		
	col5StartMove:
		lw	$s0,0($sp)		# get the word from first index in tempArray1 @100/ @104/ @108/ @112 @116
		jal	col5FinishMove
		
		# return here
		add	$sp,$sp,4		# move to next index in our tempArray @104/ @108/ @112 @116
		addi	$t1,$t1,4		# increase our place holder in tempArray @4/ @8/ @12 @16
		
		bne	$t1,20,col5StartMove 	# @4 @8/
		
		addi	$sp,$sp,-120
		bnez	$t7,secondMove
		b whileLoop		
		
	col5FinishMove:
		addi	$sp,$sp,16		# @112/ @116/ @120/ @116
		sub	$sp,$sp,$t1		# set sp back to 0 @112/ @112/ @112/ @104
		addi	$sp,$sp,-100		# move sp to front of array @12/ @12/ @12/ @4
		add	$sp,$sp,$t0		# add the value of $t0, to skip over values we have added @12/ @32/ @44 @64
		sw	$s0,0($sp)		# save the word
		sub	$sp,$sp,$t0		# move back to head of the stack @12/ @12/ @4 @4
		addi	$sp,$sp,84		# move back to top of arrayTemp @100/ @100/ @100 @100
		add	$sp,$sp,$t1		# move the pointer back to the location in tempArray before we came @100/ @104 @108 @112
		addi	$t0,$t0,20		# increment the $t0 by 20 before we head back @20/ @40/ @60 @80
		
		jr	$ra			# return	
		
	##################################### SECOND COPY ############################	
	
															
	secondMove:
		move	$t7,$zero
		beq	$a2,1,secondMove1
		beq	$a2,2,secondMove2
		beq	$a2,3,secondMove3
		beq	$a2,4,secondMove4
		beq	$a2,5,secondMove5	
		
	secondMove1:
		j	col1PreMoveCopy																			
	secondMove2:
		j	col2PreMoveCopy	
	secondMove3:		
		j	col3PreMoveCopy				
	secondMove4:
		j	col4PreMoveCopy		
	secondMove5:																																																																																																													
		j	col5PreMoveCopy																																																																																																																																																																																																																								
																																																																																																																																																																																																																																																																																																																																																																																																																																															
#------------------------------------------------------------------------------------------------#
#------------------------------------------- MOVE ROW -------------------------------------------#
#------------------------------------------------------------------------------------------------#

	moveRow:
		li	$v0,4					# 
		la	$a0,moveRowMessage1			# "Which Row would you like to switch, Enter a number 1-5: "
		syscall
		li	$v0,5
		syscall
		
		move	$a2,$zero				# make sure $a3 is empty;
		move	$a2,$v0					# assign the row value to $a3;
		beq	$v0,1,moveRow1
		beq	$v0,2,moveRow2
		beq	$v0,3,moveRow3
		beq	$v0,4,moveRow4
		beq	$v0,5,moveRow5
		
	move_Row:
		li	$v0,4					#
		la	$a0,moveRowMessage2			# "Which Row would you like to switch with, Enter a number 1-5: "
		syscall
		li	$v0,5
		syscall
		
		beq	$v0,1,preCopyToRow1
		beq	$v0,2,preCopyToRow2
		beq	$v0,3,preCopyToRow3
		beq	$v0,4,preCopyToRow4
		beq	$v0,5,preCopyToRow5
		
		
####################################### MOVE ROW ONE ###############################################

	moveRow1:
		jal	copyToTemp		# function call to save the current Arrays value in $s registers;
		addi	$sp,$sp,100		# advance stack pointer to start of tempArray1;
		jal	saveTemp		# save the values of $s0-4 to tempArray;
		addi	$sp,$sp,-100		# move stack pointer back to top of the stack;
		b	move_Row		# branch back to menu to find out which row to switch with.;

	preCopyToRow1:
		jal	copyToTemp		# save the current Array's values in $s0-4;
		addi	$sp,$sp,120		# advance stack pointer to beginning of tempArray2;
		jal	saveTemp		# save values of $s0-4 in tempArray2;
		addi	$sp,$sp,-120		# reposition stack pointer to top of stack;
		jal	getCopy			# get the values saved in tempArray1 and;
		jal	saveTemp		# save them in this array;
		
		b	a2Value			# find out which array tempArray2 values are going;
		
		
####################################### MOVE ROW TWO ###############################################
	
	moveRow2:
		addi	$sp,$sp,20
		jal	copyToTemp
		addi	$sp,$sp,80
		jal	saveTemp
		addi	$sp,$sp,-100
		b	move_Row	
		
	preCopyToRow2:
		addi	$sp,$sp,20		# move $sp to start of this array;
		jal	copyToTemp		# copy these values to $s;	
		addi	$sp,$sp,100		# move stack pointer up to start of tempArray2;
		jal	saveTemp		# save the values in tempArray2
		addi	$sp,$sp,-120		# 
		jal	getCopy			
		addi	$sp,$sp,20
		jal	saveTemp		# save them in this array;
		addi	$sp,$sp,-20
		
		b	a2Value				


####################################### MOVE ROW THREE #############################################
	
	moveRow3:
		addi	$sp,$sp,40
		jal	copyToTemp
		addi	$sp,$sp,60
		jal	saveTemp
		addi	$sp,$sp,-100
		b	move_Row
		
	preCopyToRow3:
		addi	$sp,$sp,40
		jal	copyToTemp		
		addi	$sp,$sp,80
		jal	saveTemp
		addi	$sp,$sp,-120		# return from here the current values of Row are now saved in tempArray2
		jal	getCopy			# values of tempArray1 now saved in array1
		addi	$sp,$sp,40
		jal	saveTemp		# save them in this array;
		addi	$sp,$sp,-40		
		
		b	a2Value	
			
####################################### MOVE ROW FOUR ##############################################

	moveRow4:
		addi	$sp,$sp,60
		jal	copyToTemp
		addi	$sp,$sp,40
		jal	saveTemp
		addi	$sp,$sp,-100
		b	move_Row
		
	preCopyToRow4:
		addi	$sp,$sp,60
		jal	copyToTemp		
		addi	$sp,$sp,60
		jal	saveTemp
		addi	$sp,$sp,-120		# return from here the current values of Row are now saved in tempArray2
		jal	getCopy			# values of tempArray1 now saved in array1
		addi	$sp,$sp,60
		jal	saveTemp		# save them in this array;
		addi	$sp,$sp,-60
		
		b	a2Value		
		
		
####################################### MOVE ROW FIVE ##############################################		
		
	moveRow5:
		addi	$sp,$sp,80
		jal	copyToTemp
		addi	$sp,$sp,20
		jal	saveTemp
		addi	$sp,$sp,-100
		b	move_Row
		
	preCopyToRow5:
		addi	$sp,$sp,80
		jal	copyToTemp		
		addi	$sp,$sp,40
		jal	saveTemp
		addi	$sp,$sp,-120		# return from here the current values of Row are now saved in tempArray2
		jal	getCopy			
		addi	$sp,$sp,80
		jal	saveTemp		# save them in this array;
		addi	$sp,$sp,-80
		
		b	a2Value		
		
				
								
#------------------------------------------------------------------------------------------------#
#---------------------------------------- PRINT FUNCTION ----------------------------------------#
#------------------------------------------------------------------------------------------------#
	printArray:
		addi	$t1,$zero,25		# initialize counter
		li	$v0,4
		la	$a0,printMessage
		syscall
		li	$v0,4
		la	$a0,newLine
		syscall
		b	printTest
	new_Line:
		li	$v0,4
		la	$a0,newLine
		syscall
		
	printLoop:
		lw	$s0,0($sp)
		addi	$sp,$sp,4
		li	$v0,1
		move	$a0,$s0
		syscall
		li	$v0,4
		la	$a0,space
		syscall
		subi	$t1,$t1,1
		beq	$t1,5,new_Line
		beq	$t1,10,new_Line
		beq	$t1,15,new_Line
		beq	$t1,20,new_Line
		beq	$t1,25,new_Line
		
	printTest:
		bnez	$t1,printLoop
		
		li	$v0,4
		la	$a0,newLine
		jr 	$ra

#------------------------------------------------------------------------------------------------#
#---------------------------------------- ARRAY FUNCTION ----------------------------------------#	
#------------------------------------------------------------------------------------------------#	
	getArray:
		addi	$t1,$zero,25		# register for end of forLoop;
		b	forTest
		
	forLoop:
	################## Get User Input ###############
		li	$v0,4		# String;
		la	$a0,message	# print;
		syscall
		li	$v0,1
		addi	$a1,$t1,-25
		mul	$a1,$a1,-1
		mflo	$a1
		move	$a0,$a1
		syscall
		li	$v0,4
		la	$a0,message2
		syscall
		li	$v0,5		# get integer;
		syscall
	#################################################
	
			
		sw	$v0,0($sp)	# store contents of $v0 at current $sp;
		addi	$sp,$sp,4	# move stack pointer up 4 bytes;
		
		subi	$t1,$t1,1	# decrease counter by 1
		
	forTest:
		bnez	$t1,forLoop	
		
	############ if $t1 == 0 ############
		jr	$ra		# return to main
		
		
		
#------------------------------------------------------------------------------------------------#
#--------------------------------------- TEMPORRARY ARRAY ---------------------------------------#
#------------------------------------------------------------------------------------------------#	

	copyToTemp:
		lw	$s0,0($sp)
		lw	$s1,4($sp)
		lw	$s2,8($sp)
		lw	$s3,12($sp)
		lw	$s4,16($sp)
		jr	$ra	
		
	saveTemp:
		sw	$s0,0($sp)
		sw	$s1,4($sp)
		sw	$s2,8($sp)
		sw	$s3,12($sp)
		sw	$s4,16($sp)
		jr	$ra	
		
		
		
	getCopy:
		addi	$sp,$sp,100		# get the values from the first array in tempArray1
		lw	$s0,0($sp)		
		lw	$s1,4($sp)
		lw	$s2,8($sp)
		lw	$s3,12($sp)
		lw	$s4,16($sp)
		addi	$sp,$sp,-100		# reposition stack pointer back to top of stack
		jr	$ra
		
		
	getCopy2:
		addi	$sp,$sp,120		# get values from tempArray2
		lw	$s0,0($sp)
		lw	$s1,4($sp)
		lw	$s2,8($sp)
		lw	$s3,12($sp)
		lw	$s4,16($sp)
		addi	$sp,$sp,-120		# reposition stack pointer to top of stack;
		jr	$ra
		
	copyTo3:
		sw	$s0,0($sp)
		sw	$s1,4($sp)
		sw	$s2,8($sp)
		sw	$s3,12($sp)
		sw	$s4,16($sp)
		jr	$ra
		
		
	a2Value:
		beq	$a2,1,vOne
		beq	$a2,2,vTwo
		beq	$a2,3,vThree
		beq	$a2,4,vFour
		beq	$a2,5,vFive
		
		

	###############################################################################

	vOne:
		jal	getCopy2
		jal	copyTo3
		b	whileLoop
	vTwo:
		jal	getCopy2
		addi	$sp,$sp,20
		jal	copyTo3
		addi	$sp,$sp,-20
		b	whileLoop
	vThree:
		jal	getCopy2
		addi	$sp,$sp,40
		jal	copyTo3
		addi	$sp,$sp,-40
		b	whileLoop
	vFour:
		jal	getCopy2
		addi	$sp,$sp,60
		jal	copyTo3
		addi	$sp,$sp,-60
		b	whileLoop
	vFive:
		jal	getCopy2
		addi	$sp,$sp,80
		jal	copyTo3
		addi	$sp,$sp,-80
		b	whileLoop
		

		
		