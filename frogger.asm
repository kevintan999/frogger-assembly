#####################################################################
#
# CSC258H5S Fall 2021 Assembly Final Project
# University of Toronto, St. George
#
# Student: Kaiwen Tan 1005937676
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 512
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3/4/5 (choose the one the applies)
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. Have objects in different rows move at different speeds.
# 2. After final player death, display game over/retry screen. Restart the game if the “retry” option is chosen.
# 3. (fill in the feature, if any)
# 4. Display the player’s score at the top of the screen. (hard)
# 5.  
#
# Any additional information that the TA needs to know:
# - press "ESC" to exit program at any time
# - Game over screen: press "w" to restart, press "ESC" to exit program, 
#
#####################################################################
.data
	displayAddress: .word 0x10008000
	frogStart: .word 3,7
	carArray1: .word 0,1,4,5
	carArray2: .word 0,3,7
	
	logArray1: .word 0,1,4,5
	logArray2: .word 0,3,4,7
	logArray3: .word 0,2,4,6
	
	endArray: .space 7
	
	scoreString: .asciiz "The current score is: "
	gameOverString: .asciiz "Game over! Your score will be reset. Press W to continue, press ESC to exit game"
	yourScoreString: .asciiz "Your score this game was: "
	nextLine: .asciiz "\n"  
	
	currentScore: .word 0
.text

li $s6, 0 # clock counter
li $s7, 0 # clock counter
li $s5, 0
li $s4, 0
li $s3, 0


li $s2, 0 #counter for amount of frogs that finished
li $s1, 3 #counter for lives


main:

	lw $s0, displayAddress # $t0 stores the base address for display

	lw $t0, 0xffff0000 
	beq $t0, 0x0, Draw
	lw $t0, 0xffff0004
	beq $t0, 0x77, MovedUp 
	beq $t0, 0x61, MovedLeft 
	beq $t0, 0x73, MovedDown 
	beq $t0, 0x64, MovedRight 
	beq $t0, 0x1b, Exit 
	j Draw
	
MovedUp:
	la $t9, frogStart 
	lw $t1, 4($t9) 
 	blez $t1, Draw 
	addi $t1, $t1, -1 
	sw $t1, 4($t9) 
	
	beqz $t1, reachedFinal ######################## hit checkpoint
	j skipReachedFinal
	reachedFinal: 
	li $v0, 31
	li $a0, 72
	li $a1, 250
	li $a2, 88 ########instrument
	li $a3, 127
	syscall
	
	li $t6, 3 ###################### for resetting frog
	li $t7, 7
	sw $t6, 0($t9)
	sw $t7, 4($t9)

	skipReachedFinal:
	
	
	#################adding sound
	li $v0, 31
	li $a0, 60
	li $a1, 250
	li $a2, 88 ########instrument
	li $a3, 70
	syscall
	
	
	####################Printing Score
	
	lw $t1, currentScore # loadss current score
	addi $t1, $t1, 100
	sw $t1, currentScore
	
	la $a0, scoreString
	li $v0, 4
	syscall 
	
	li $a0, 0
	add $a0, $a0, $t1
	li $v0, 1
	syscall
	
	la $a0, nextLine #prints \n
	li $v0, 4
	syscall
	
	
	j Draw
MovedDown:
	la $t9, frogStart
	lw $t1, 4($t9) 
	addi $t2, $t1, -6 
 	bgtz $t2, Draw 
	addi $t1, $t1, 1 
	sw $t1, 4($t9) 
		#################adding sound
	li $v0, 31
	li $a0, 60
	li $a1, 250
	li $a2, 88 ########instrument
	li $a3, 70
	syscall
	j Draw
	

MovedLeft:
	la $t9, frogStart 
	lw $t1, 0($t9) 
 	blez $t1, Draw 
	addi $t1, $t1, -1 
	sw $t1, 0($t9)
		#################adding sound
	li $v0, 31
	li $a0, 60
	li $a1, 250
	li $a2, 88 ########instrument
	li $a3, 70
	syscall
	j Draw


MovedRight:
	la $t9, frogStart 
	lw $t1, 0($t9) 
	addi $t2, $t1, -6 
 	bgtz $t2, Draw 
	addi $t1, $t1, 1 
	sw $t1, 0($t9) 
		#################adding sound
	li $v0, 31
	li $a0, 60
	li $a1, 250
	li $a2, 88 ########instrument
	li $a3, 70
	syscall
	j Draw
	
	
		

OnLog:

	
	
	

Draw:
############################################################################ Drawing flat terrain




DrawMapFinishline:
	li $a0, 0
	li $a1, 0
	li $a2, 0x8c9b3c # $t1 stores the white colour code\
	
	loopDrawMapFinishLine: beq $a0, 8, loopDrawMapFinishLineEnd
		jal draw_square
		
		addi $a0, $a0, 1
		j loopDrawMapFinishLine
	loopDrawMapFinishLineEnd:
	
	
	
	
	
DrawMapSafeZone:
	li $a0, 0
	li $a1, 4
	li $a2, 0x8c9b3c # $t1 stores the magenta colour code\
	loopDrawMapSafeZone: beq $a0, 8, loopDrawMapSafeZoneEnd
		jal draw_square
		addi $a0, $a0, 1
		j loopDrawMapSafeZone
	loopDrawMapSafeZoneEnd:

DrawMapStartZone:
	li $a0, 0
	li $a1, 7
	li $a2, 0x8c9b3c # $t1 stores the magenta colour code\
	loopDrawMapStartZone: beq $a0, 8, loopDrawMapStartZoneEnd
		jal draw_square
		addi $a0, $a0, 1
		j loopDrawMapStartZone
	loopDrawMapStartZoneEnd:
	
############################################################################ Waters 
DrawMapWater1:
	li $a0, 0
	li $a1, 1
	li $a2, 0x503520 # $t1 stores the blue colour code\
	loopDrawMapWater1: beq $a0, 8, loopDrawMapWater1End
		jal draw_square
		addi $a0, $a0, 1
		j loopDrawMapWater1
	loopDrawMapWater1End:	
	
DrawMapWater2:
	li $a0, 0
	li $a1, 2
	li $a2, 0x503520 # $t1 stores the blue colour code
	loopDrawMapWater2: beq $a0, 8, loopDrawMapWater2End
		jal draw_square
		addi $a0, $a0, 1
		j loopDrawMapWater2
	loopDrawMapWater2End:
	
DrawMapWater3:
	li $a0, 0
	li $a1, 3
	li $a2, 0x503520 # $t1 stores the blue colour code\
	loopDrawMapWater3: beq $a0, 8, loopDrawMapWater3End
		jal draw_square
		addi $a0, $a0, 1
		j loopDrawMapWater3
	loopDrawMapWater3End:

############################################################################ Roads
DrawMapRoad1:
	li $a0, 0
	li $a1, 5
	li $a2, 0x260205 # $t1 stores the blue colour code\
	loopDrawMapRoad1: beq $a0, 8, loopDrawMapRoad1End
		jal draw_square
		addi $a0, $a0, 1
		j loopDrawMapRoad1
	loopDrawMapRoad1End:	
	
DrawMapRoad2:
	li $a0, 0
	li $a1, 6
	li $a2, 0x260205 # $t1 stores the blue colour code\
	loopDrawMapRoad2: beq $a0, 8, loopDrawMapRoad2End
		jal draw_square
		addi $a0, $a0, 1
		j loopDrawMapRoad2
	loopDrawMapRoad2End:
############################################################################ Draw Cars
	#carArray1: 0,1,4,5    size of 4       starts at y=5

DrawCarRow1: 

li $t6, 0	
LoopCarRow1:beq $t6, 16,LoopCarRow1End
	la $t2, carArray1
	li $t3, 0
	add $t3, $t6, $t2 # added on top of 
	
	lw $t4, ($t3)

	li $a0, 0
	add $a0, $a0, $t4 #set argument for x coordinate
	li $a1, 5 # set argument for y coordinate
	li $a2, 0xffffff #set color for square
	jal draw_square
	
	la $t5, frogStart #get memory location of frogstart
	lw $t9, 0($t5) #x value for frogStart
	lw $t8, 4($t5) #yvalue for frogstart
	
	bne $t9, $a0, frogCheckPassed
	bne $t8, $a1, frogCheckPassed
	jal ResetFrog ########frog hit something
	
	frogCheckPassed:
	
	         
	
	add $t6, $t6, 4
	j LoopCarRow1
LoopCarRow1End:

bne $s6, 60, CarUpdateSkip1 ######################update skip 1
li $a0, 4
la $a1, carArray1
jal ArrayForward

li $s6, 0

CarUpdateSkip1:


#######################
	#carArray2: 0,3,4,7
DrawCarRow2:

li $t6, 0
LoopCarRow2:beq $t6, 12,LoopCarRow2End
	la $t2, carArray2
	li $t3, 0
	add $t3, $t6, $t2 # added on top of 
	
	lw $t4, ($t3)

	li $a0, 0
	add $a0, $a0, $t4 #set argument for x coordinate
	li $a1, 6 # set argument for y coordinate
	li $a2, 0xffffff #set color for square
	jal draw_square
	
	la $t5, frogStart #get memory location of frogstart
	lw $t9, 0($t5) #x value for frogStart
	lw $t8, 4($t5) #yvalue for frogstart
	
	bne $t9, $a0, frogCheckPassed2
	bne $t8, $a1, frogCheckPassed2
	jal ResetFrog
	
	frogCheckPassed2:
	
	add $t6, $t6, 4
	j LoopCarRow2
LoopCarRow2End:

bne $s7, 120, CarUpdateSkip2 ######################update skip 1
li $a0, 3
la $a1, carArray2
jal ArrayForward

li $s7, 0 
CarUpdateSkip2:


############################################################################ Draw logs

DrawLogRow1: 

li $t6, 0	
LoopLogRow1:beq $t6, 16,LoopLogRow1End
	la $t2, logArray1
	li $t3, 0
	add $t3, $t6, $t2 # added on top of 
	
	lw $t4, ($t3)

	li $a0, 0
	add $a0, $a0, $t4 #set argument for x coordinate
	li $a1, 1 # set argument for y coordinate
	li $a2, 0x3ea185 #set color for square
	jal draw_square
	
	la $t5, frogStart #get memory location of frogstart
	lw $t9, 0($t5) #x value for frogStart
	lw $t8, 4($t5) #yvalue for frogstart
	
	bne $t9, $a0, frogCheckPassed3
	bne $t8, $a1, frogCheckPassed3
	jal ResetFrog
	
	frogCheckPassed3:

	
	
	add $t6, $t6, 4
	j LoopLogRow1
LoopLogRow1End:


bne $s5, 120, LogUpdateSkip1 ######################update skip 1
li $a0, 4
la $a1, logArray1
jal ArrayBackward

li $s5, 0 
LogUpdateSkip1:

#######################

DrawLogRow2: 

li $t6, 0	
LoopLogRow2:beq $t6, 16,LoopLogRow2End
	la $t2, logArray2
	li $t3, 0
	add $t3, $t6, $t2 # added on top of 
	
	lw $t4, ($t3)

	li $a0, 0
	add $a0, $a0, $t4 #set argument for x coordinate
	li $a1, 2 # set argument for y coordinate
	li $a2, 0x3ea185 #set color for square
	jal draw_square

	la $t5, frogStart #get memory location of frogstart
	lw $t9, 0($t5) #x value for frogStart
	lw $t8, 4($t5) #yvalue for frogstart
	
	bne $t9, $a0, frogCheckPassed4
	bne $t8, $a1, frogCheckPassed4
	jal ResetFrog
	
	frogCheckPassed4:
	
	add $t6, $t6, 4
	j LoopLogRow2
	

LoopLogRow2End:


bne $s4, 90, LogUpdateSkip2 ######################update skip 1
li $a0, 4
la $a1, logArray2
jal ArrayBackward

li $s4, 0 
LogUpdateSkip2:
#######################

DrawLogRow3: 

li $t6, 0	
LoopLogRow3:beq $t6, 16,LoopLogRow3End
	la $t2, logArray3
	li $t3, 0
	add $t3, $t6, $t2 # added on top of 
	
	lw $t4, ($t3)

	li $a0, 0
	add $a0, $a0, $t4 #set argument for x coordinate
	li $a1, 3 # set argument for y coordinate
	li $a2, 0x3ea185 #set color for square
	jal draw_square
	
	la $t5, frogStart #get memory location of frogstart
	lw $t9, 0($t5) #x value for frogStart
	lw $t8, 4($t5) #yvalue for frogstart
	
	bne $t9, $a0, frogCheckPassed5 #check x
	bne $t8, $a1, frogCheckPassed5 #check y
	jal ResetFrog
	
	frogCheckPassed5:
	
	add $t6, $t6, 4
	j LoopLogRow3

LoopLogRow3End:

bne $s3, 60, LogUpdateSkip3 ######################update skip 1
li $a0, 4
la $a1, logArray3
jal ArrayBackward

li $s3, 0 
LogUpdateSkip3:

####################################################################### Array forward
j exitArrayForward
ArrayForward: #a0: length of array , a1: array [1] address
	lw $t0, 0($a1) 
	addi $t0, $t0, 1 
	li $t2, 8
	bge $t0, $t2, XValueExceeded 
	blt $t0, $t2, XValueAdequate 
XValueExceeded:
	li $t0, 0
XValueAdequate:
	sw $t0, 0($a1) # save value
	addi $a0, $a0, -1
	addi $a1, $a1, 4
	bnez $a0, ArrayForward
	jr $ra
exitArrayForward:

####################################################################### Array Backwards
j exitArrayBackward
ArrayBackward: #a0: length of array , a1: array [1] addresse
	lw $t0, 0($a1) 
	addi $t0, $t0, -1 
	li $t2, 0
	blt $t0, $t2, XValueNegative 
	bge $t0, $t2, XValueAdequateNeg
XValueNegative:
	li $t0, 7
XValueAdequateNeg:
	sw $t0, 0($a1) # save value
	addi $a0, $a0, -1
	addi $a1, $a1, 4
	bnez $a0, ArrayBackward
	jr $ra
exitArrayBackward:

############################################################################ Drawing Frog
	la $t0, frogStart
	lw $a0, ($t0)
	lw $a1, 4($t0)

	jal DrawFrog
############################################################################ Frog Function
j exit_DrawFrog
DrawFrog: #a0: X location of frog, a1: y location of frog

	sll $t1, $a0, 4 #exact x coordinate
	sll $t2, $a1, 2 #exact number of rows of pixels
	sll $t2, $t2, 7 #number of pixels from origin without adding x 
	add $t3, $t1, $t2 # t3: exact pixel top left of the square
	add $t3, $t3, $s0 # t3: exact pixel top left with display address
	
	li $a2, 0xfdfe00
	
	sw $a2, 0($t3)
	sw $a2, 12($t3)
	
	sw $a2, 128($t3)
	sw $a2, 132($t3)
	sw $a2, 136($t3)
	sw $a2, 140($t3)
	
	sw $a2, 260($t3)
	sw $a2, 264($t3)
	
	sw $a2, 384($t3)
	sw $a2, 396($t3)
	
	jr $ra
exit_DrawFrog:
##############################################
j exitResetFrog
ResetFrog:
	#################adding sound
	li $v0, 31
	li $a0, 68
	li $a1, 250
	li $a2, 88 ########instrument
	li $a3, 70
	syscall
	
	li $t9, 3 #frogstartx
	li $t8, 7 #frogstarty
	la $t7, frogStart
 	sw $t9, 0($t7)
 	sw $t8, 4($t7) 
 	
 	addi $s1, $s1, -1 #losing one life
 	
 	
 	

 	beqz $s1, GameOverAlgo
 	
 	jr $ra
exitResetFrog:

##################################################################### Drawing bottom half of the screen: 
##################################################################### Drawing Logo

#j SkipDrawLogo
DrawLogo:

li $t3, 0x35de35 

li $t4, 5536
add $t4, $t4, $s0
sw $t3, ($t4) #top Left Corner of logo

############### Letter "F

sw $t3, ($t4) #top Left Corner of logo
sw $t3, 4($t4)
sw $t3, 8($t4)
sw $t3, 128($t4)
sw $t3, 256($t4)
sw $t3, 260($t4)
sw $t3, 264($t4)

sw $t3, 384($t4)
li $t3, 0x000000
sw $t3, 392($t4)
li $t3, 0x35de35
sw $t3, 512($t4)
li $t3, 0x000000
sw $t3, 516($t4)
sw $t3, 520($t4)
li $t3, 0x35de35

############### Letter R
li $t5, 0
addi $t5, $t5, 16
add $t5, $t5, $t4 ######## set top left value

sw $t3, ($t5)
sw $t3, 4($t5)
li $t3, 0x000000
sw $t3, 8($t5)
li $t3, 0x35de35
sw $t3, 128($t5)
sw $t3, 136($t5)

sw $t3, 256($t5)
sw $t3, 260($t5)
li $t3, 0x000000
sw $t3, 264($t5)
li $t3, 0x35de35

sw $t3, 384($t5)
sw $t3, 392($t5)
sw $t3, 512($t5)
sw $t3, 520($t5)


################# Letter O

li $t5, 0
addi $t5, $t5, 36  ######## set top left value
add $t5, $t5, $t4 

sw $t3, ($t5)
sw $t3, 4($t5)
sw $t3, 8($t5)

sw $t3, 128($t5)
li $t3, 0x000000
sw $t3, 132($t5)
li $t3, 0x35de35
sw $t3, 136($t5)

sw $t3, 256($t5)
sw $t3, 264($t5)

sw $t3, 384($t5)
sw $t3, 392($t5)

sw $t3, 512($t5)
sw $t3, 516($t5)
sw $t3, 520($t5)


################### Letter G 1

li $t5, 0
addi $t5, $t5, 52 
add $t5, $t5, $t4 

sw $t3, ($t5)
sw $t3, 4($t5)
sw $t3, 8($t5)

sw $t3, 128($t5)

sw $t3, 256($t5)
sw $t3, 260($t5)
sw $t3, 264($t5)

sw $t3, 384($t5)
sw $t3, 392($t5)

sw $t3, 512($t5)
sw $t3, 516($t5)
sw $t3, 520($t5)

################### Letter G 2

li $t5, 0
addi $t5, $t5, 768
add $t5, $t5, $t4 

sw $t3, ($t5)
sw $t3, 4($t5)
sw $t3, 8($t5)

sw $t3, 128($t5)
li $t3, 0x000000
sw $t3, 136($t5)
li $t3, 0x35de35

sw $t3, 256($t5)
sw $t3, 260($t5)
sw $t3, 264($t5)

sw $t3, 384($t5)
sw $t3, 392($t5)

sw $t3, 512($t5)
sw $t3, 516($t5)
sw $t3, 520($t5)


################ Letter A


addi $t5, $t5, 16

sw $t3, ($t5)
sw $t3, 4($t5)
sw $t3, 8($t5)

sw $t3, 128($t5)
sw $t3, 136($t5)

sw $t3, 256($t5)
sw $t3, 260($t5)
sw $t3, 264($t5)

sw $t3, 384($t5)
sw $t3, 392($t5)

sw $t3, 512($t5)
li $t3, 0x000000
sw $t3, 516($t5)
li $t3, 0x35de35
sw $t3, 520($t5)


################ Letter M


addi $t5, $t5, 20

sw $t3, ($t5)
li $t3, 0x000000
sw $t3, 4($t5)
li $t3, 0x35de35
sw $t3, 8($t5)

sw $t3, 128($t5)
sw $t3, 132($t5)
sw $t3, 136($t5)

sw $t3, 256($t5)
li $t3, 0x000000
sw $t3, 260($t5)
li $t3, 0x35de35
sw $t3, 264($t5)

sw $t3, 384($t5)
sw $t3, 392($t5)

sw $t3, 512($t5)
li $t3, 0x000000
sw $t3, 516($t5)
li $t3, 0x35de35
sw $t3, 520($t5)


################ Letter E


addi $t5, $t5, 16

sw $t3, ($t5)
sw $t3, 4($t5)
sw $t3, 8($t5)

sw $t3, 128($t5)
li $t3, 0x000000
sw $t3, 136($t5)
li $t3, 0x35de35

sw $t3, 256($t5)
sw $t3, 260($t5)
sw $t3, 264($t5)

sw $t3, 384($t5)
li $t3, 0x000000
sw $t3, 392($t5)
li $t3, 0x35de35

sw $t3, 512($t5)
sw $t3, 516($t5)
sw $t3, 520($t5)
SkipDrawLogo:

##################################################################### Game over
j SkipDrawGameOver

GameOverAlgo:

DrawGameOver:


ble $s1, 0, LostThreeLife
j SkipLostThreeLife
LostThreeLife:
li $a0, 7
li $a1, 13
li $a2, 0x000000





jal draw_square
SkipLostThreeLife:


####Reset score
sw $zero, currentScore 

 


##########################################
li $t3, 0x960c1e

li $t4, 5536
add $t4, $t4, $s0
li $t5, 0
addi $t5, $t5, 0
add $t5, $t5, $t4 

sw $t3, ($t5)
sw $t3, 4($t5)
sw $t3, 8($t5)

sw $t3, 128($t5)

sw $t3, 256($t5)
sw $t3, 260($t5)
sw $t3, 264($t5)

sw $t3, 384($t5)
sw $t3, 392($t5)

sw $t3, 512($t5)
sw $t3, 516($t5)
sw $t3, 520($t5)


################ Letter A


addi $t5, $t5, 16

sw $t3, ($t5)
sw $t3, 4($t5)
sw $t3, 8($t5)

sw $t3, 128($t5)
sw $t3, 136($t5)

sw $t3, 256($t5)
sw $t3, 260($t5)
sw $t3, 264($t5)

sw $t3, 384($t5)
sw $t3, 392($t5)

sw $t3, 512($t5)
sw $t3, 520($t5)


################ Letter M


addi $t5, $t5, 20

sw $t3, ($t5)
li $t3, 0x000000
sw $t3, 4($t5)
li $t3, 0x960c1e
sw $t3, 8($t5)

sw $t3, 128($t5)
sw $t3, 132($t5)
sw $t3, 136($t5)

sw $t3, 256($t5)
sw $t3, 264($t5)

sw $t3, 384($t5)
sw $t3, 392($t5)

sw $t3, 512($t5)
li $t3, 0x000000
sw $t3, 516($t5)
li $t3, 0x960c1e
sw $t3, 520($t5)


################ Letter E


addi $t5, $t5, 16

sw $t3, ($t5)
sw $t3, 4($t5)
sw $t3, 8($t5)

sw $t3, 128($t5)


sw $t3, 256($t5)
sw $t3, 260($t5)
sw $t3, 264($t5)

sw $t3, 384($t5)
li $t3, 0x000000
sw $t3, 392($t5)
li $t3, 0x960c1e


sw $t3, 512($t5)
sw $t3, 516($t5)
sw $t3, 520($t5)




######################## Drawing "Over"
################# Letter O

li $t5, 0
addi $t5, $t5, 768   ######## set top left value
add $t5, $t5, $t4 

sw $t3, ($t5)
sw $t3, 4($t5)
sw $t3, 8($t5)

sw $t3, 128($t5)
sw $t3, 136($t5)

sw $t3, 256($t5)
li $t3, 0x000000
sw $t3, 260($t5)
li $t3, 0x960c1e
sw $t3, 264($t5)

sw $t3, 384($t5)
sw $t3, 392($t5)

sw $t3, 512($t5)
sw $t3, 516($t5)
sw $t3, 520($t5)


################# Letter V
addi $t5, $t5, 16

sw $t3, ($t5)
li $t3, 0x000000
sw $t3, 4($t5)
li $t3, 0x960c1e
sw $t3, 8($t5)

sw $t3, 128($t5)
sw $t3, 136($t5)

sw $t3, 256($t5)
li $t3, 0x000000
sw $t3, 260($t5)
li $t3, 0x960c1e
sw $t3, 264($t5)

sw $t3, 384($t5)
sw $t3, 392($t5)

sw $t3, 512($t5)
sw $t3, 516($t5)
li $t3, 0x000000
sw $t3, 520($t5)
li $t3, 0x960c1e

################# Letter E
addi $t5, $t5, 20

sw $t3, ($t5)
sw $t3, 4($t5)
sw $t3, 8($t5)

sw $t3, 128($t5)
li $t3, 0x000000
sw $t3, 132($t5)
sw $t3, 136($t5)
li $t3, 0x960c1e

sw $t3, 256($t5)
sw $t3, 260($t5)
sw $t3, 264($t5)

sw $t3, 384($t5)
li $t3, 0x000000
sw $t3, 392($t5)
li $t3, 0x960c1e

sw $t3, 512($t5)
sw $t3, 516($t5)
sw $t3, 520($t5)

################# Letter R
addi $t5, $t5, 16

sw $t3, ($t5)
sw $t3, 4($t5)
li $t3, 0x000000
sw $t3, 8($t5)
li $t3, 0x960c1e

sw $t3, 128($t5)
sw $t3, 136($t5)

sw $t3, 256($t5)
sw $t3, 260($t5)
li $t3, 0x000000
sw $t3, 264($t5)
li $t3, 0x960c1e

sw $t3, 384($t5)
sw $t3, 392($t5)

sw $t3, 512($t5)
li $t3, 0x000000
sw $t3, 516($t5)
li $t3, 0x960c1e
sw $t3, 520($t5)



##################################################Algo for game end
lw $t0, 0xffff0000 
beq $t0, 0x0, GameOverAlgo
lw $t0, 0xffff0004
beq $t0, 0x77, restart 
beq $t0, 0x1b, Exit

j GameOverAlgo
SkipDrawGameOver:


##################################################################### Lives counter
########### Draw "Lives"
ble $s1, 2, LostOneLife
li $a0, 7
li $a1, 9
jal DrawFrog
j SkipLostOneLife
LostOneLife:



li $a0, 7
li $a1, 9
li $a2, 0x000000
jal draw_square

SkipLostOneLife:



ble $s1, 1, LostTwoLife
li $a0, 7
li $a1, 11
jal DrawFrog
j SkipLostTwoLife
LostTwoLife:

li $a0, 7
li $a1, 11
li $a2, 0x000000
jal draw_square
SkipLostTwoLife:

li $a0, 7
li $a1, 13


jal DrawFrog



##################################################################### score counter
########### Draw "score"




#########################################################
j exit_draw_square
draw_square: # a0: X coordinate based on grid system, a1: Y coordinate based on grid system, a2: color

	sll $t1, $a0, 4 #exact x coordinate
	sll $t2, $a1, 2 #exact number of rows of pixels
	sll $t2, $t2, 7 #number of pixels from origin without adding x 
	add $t3, $t1, $t2 # t3: exact pixel top left of the square
	add $t3, $t3, $s0 # t3: exact pixel top left with display address

	sw $a2, 0($t3)
	sw $a2, 4($t3)
	sw $a2, 8($t3)
	sw $a2, 12($t3)
	sw $a2, 128($t3)
	sw $a2, 132($t3)
	sw $a2, 136($t3)
	sw $a2, 140($t3)
	sw $a2, 256($t3)
	sw $a2, 260($t3)
	sw $a2, 264($t3)
	sw $a2, 268($t3)
	sw $a2, 384($t3)
	sw $a2, 388($t3)
	sw $a2, 392($t3)
	sw $a2, 396($t3)

	jr $ra
exit_draw_square:



######################################################################## Draw all finishline frogs







j skipRestart ##########################restart algorithm
restart:
li $s1, 3
j main

skipRestart:



li $v0, 32
li $a0, 16
syscall

addi $s6, $s6, 1
addi $s7, $s7, 1
addi $s5, $s5, 1
addi $s4, $s4, 1
addi $s3, $s3, 1


j main # loop to top

Exit:
	li $v0, 10 # terminate the program gracefully
syscall
