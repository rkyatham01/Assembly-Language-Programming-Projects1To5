################# Rishith Kyatham #################

.data

arg1_addr: .word 0
arg2_addr: .word 0
num_args: .word 0
invalid_arg_msg: .asciiz "One of arguments is invalid \n"
args_err_msg: .asciiz "Program requires Exactly two arguments\n"
zero: .asciiz "Zero\n"
nan: .asciiz "NaN\n"
inf_pos: .asciiz "+Inf\n"
inf_neg: .asciiz "-Inf\n"
mantissa: .asciiz ""

.text 
.globl hw_main
hw_main:
    sw $a0, num_args
    sw $a1, arg1_addr
    addi $t0, $a1, 2
    sw $t0, arg2_addr
    j start_coding_here
    
start_coding_here:

	li $t1, 2  # loads 2 into register t1
	bne $a0, $t1, arguement_err_msg #if (number of arguements is not 2, then program 
	li $t1, 1
	#prints args_err _gitmsg and terminate
	lb $t2, 0($a1) 
        lw $t3, arg2_addr #loads the second argument into $t3
	 lb $t5, 0($t3)
	 beqz $t5, invalid_args_msg
	 
	li $t5, 68
	beq $t2, $t5, stringToDecimal #if t2 is equal to "D" than go to stringToDecimal
	li $t5, 88
	beq $t2, $t5, HexStringtoDecimal #if t2 is equal to "X" than go to HexStringtoDecimal
	li $t5, 70
	beq $t2, $t5, HexStringtothirtytwobit #if t2 is equal to "F"
	#than go to HexStringtothirtytwobit
	li $t5, 76
	beq $t2, $t5, LootCardGame #if t2 is equal to L
	
	lb $t2, 1($a1)
	bne $t2, $0, invalid_args_msg
	
	j invalid_args_msg
	# to "L" goes to lootcardgame

arguement_err_msg:
	li $v0, 4 # prepares to call a string
	la $a0, args_err_msg #calls the argument error message
	syscall
	j prgrm_end #terminates program

invalid_args_msg:
	li $v0, 4
	la $a0, invalid_arg_msg #calls the argument error message
	syscall
	j prgrm_end #terminates program

stringToDecimal: #if the first arguement is D
	lw $t3, arg2_addr #loads the second argument into $t3 
	j loop #jumps to the loop to check validation of the second label
	
	loop: 
	lbu $t5, 0($t3) #stores the character in index
	beq $t5, $0 conversionStringtoDecimal#if the character is null, then the program goes 
	#to conversionStringtoDecimal
	li $t6, 48
	blt $t5, $t6, invalid_args_msg #if the character is less than 0
	li $t6, 57
	bgt $t5, $t6, invalid_args_msg #if the character is more than 9
	addi $t3,$t3, 1 #adds 1 to the base address, 
	j loop #creates an infinite loop
	
conversionStringtoDecimal:
	li $t8, 0 #sum
	lw $t3, arg2_addr #loads the second argument into $t3
	j loop2
	
	loop2:
	lbu $t5, 0($t3) #goes the character in index
	beq $t5, $0, exitloop
	li $t0, 10
	mul $t8, $t8, $t0
	li $t4, 48
	sub $t5, $t5, $t4
	addi $t3, $t3, 1 #goes to next character
	add $t8, $t8, $t5
	
	j loop2 #creates infinite loop
	
exitloop:
	move $a0, $t8 #loads the value to print  
	li $v0, 1 #gets ready to print integer
	syscall #prints integer
	j prgrm_end
	
HexStringtoDecimal:

	lw $t3, arg2_addr #loads the second argument into $t3
	lbu $t5, 0($t3) #stores the character in index
	li $t0, 48
	bne $t5, $t0, invalid_args_msg #if $t5(or index 0) is not equal to 0, than go to invalid_
	#args_msg
	addi $t3, $t3, 1 #gets the next character
	lbu $t5, 0($t3) #stores the character in index
	li $t0, 120
	bne $t5, $t0, invalid_args_msg #if $t5(or index 1) is not equal to x, than go to invalid_
	#args_msg
	addi $t3, $t3, 1 #gets the next character

	j loop3
	
	loop3:
	lbu $t5, 0($t3) #stores the character in index 3
	beqz $t5, hexToDecim #as long as the character is not null, it loops
	li $t1, 48
	blt $t5, $t1, invalid_args_msg #if the character is less than 0, gives invalid
	#message
	li $t1, 57
	bgt $t5, $t1, checkforinvalid #if the character is more than 9, goes to checkforinvalid
	li $t1, 70 
	#message
	li $t0, 1
	addi $t3, $t3, 1 #goes to next character
	j loop3 #as long as the character is not null, it loops

	checkforinvalid:
	li $t1, 65
	blt $t5, $t1, invalid_args_msg #checks now if the character is less than A and gives 
	li $t1, 70
	bgt $t5, $t1, invalid_args_msg #if the character is more than F, gives invalid
	addi $t3, $t3, 1 #moves to the next character 
	j loop3
	#invalid_args_msg if it is
	
hexToDecim: 
	lw $t3, arg2_addr #loads the second argument into $t3
	li $t8, 0 #collective sum 

	loop4:
	lbu $t5, 2($t3) #stores the character in index 2
	beqz $t5, displayHexToDecim #if the character is null, then the program goes 
	li $t0, 65
	blt $t5, $t0, labelforzerotonine
	li $t0, 65
	bge $t5, $t0, labelforAtoF
	j loop4 
	  
	loop10:
	sll $t8, $t8, 4 # used to do the power of 16^counter
    #0 - 9
    	add $t8, $t8, $t5 #adds to the collective sum every iteration
    	addi $t4, $t4, 1 #adds 1 to the counter
    	addi $t3, $t3, 1 #goes to the next character
    	j loop4 #loops again if its adderss is not null

labelforzerotonine:
	li $t0, 48
	sub $t5, $t5, $t0 #subtracts 48 to say 0 in string = 0
	j loop10
	
labelforAtoF:
	li $t0, 55
	sub $t5, $t5, $t0
	j loop10

displayHexToDecim:
	move $a0, $t8 #loads the value to print  
	li $v0, 1 #gets ready to print integer
	syscall #prints integer
	j prgrm_end

HexStringtothirtytwobit:

	lw $t3, arg2_addr #loads the second argument into $t3
	li $t6, 0 # create another counter to 0
	j loop8

	loop8:
	lbu $t2, 0($t3) #stores the character in index
	beqz $t2, doublecheckrealquick #if the character is null, then the program goes 
	li $t0, 48
	blt $t2, $t0, invalid_args_msg #if the character is less than 0, gives invalid
	#message
	li $t0, 57
	bgt $t2, $t0, checkforinvalid2 #if the character is more than 9, goes to checkforinvalid
	#message
	j loop13 
	
	loop13:
	addi $t6, $t6, 1 #adds 1 to counter in t6
	addi $t3, $t3, 1 #moves to the next character 
	j loop8 #jumps back
	
doublecheckrealquick:
	li $t0, 8
	bne $t6, $t0, invalid_args_msg #if the length is not 8, then it jumps to that
	j conversions

checkforinvalid2: 
	li $t0, 65
	blt $t2, $t0, invalid_args_msg
	li $t0, 70
	bgt $t2, $t0, invalid_args_msg #if the character is more than F, gives invalid
	j loop13
	
conversions:
	lw $t3, arg2_addr 
	li $t4, 0 #a counter set to 0
	li $t8, 0 #collective sum 
	j loop14
	
	loop14:
	lbu $t2, 0($t3) #loads the character in index 0
	blez $t2, comparisons #if the character is null, then the program goes 
	li $t0, 65
	blt $t2, $t0, labelforzerotonine2
	li $t0, 65
	bge $t2, $t0, labelforAtoF2
	j loop14 
	  
	loop15:
	sll $t8, $t8, 4 # used to do the power of 16^counter
    #0 - 9
    	add $t8, $t8, $t2 #adds to the collective sum every iteration
    	addi $t4, $t4, 1 #adds 1 to the counter
    	addi $t3, $t3, 1 #goes to the next character
    	j loop14 #loops again if its adderss is not null
	
labelforzerotonine2:
	li $t0, 48
	sub $t2, $t2, $t0 #subtracts 48 to say 0 in string = 0
	j loop15
	
labelforAtoF2:
	li $t0, 55
	sub $t2, $t2, $t0
	j loop15

comparisons:
	li $t7, 0x00000000 #special case 
	beq $t8, $t7, callingzero #compares input to $t7 in line above
	
	li $t7, 0x80000000 #2nd special case
	beq $t8, $t7, callingzero #if $t8 not equal to $t7, go to label
	
	li $t7, 0xFF800000 #3rd special case
	beq $t8, $t7, callingneginfinity #if $t8 not equal to $t7, go to label
	
	li $t7, 0x7F800000 #4th special case
	beq $t8, $t7, callingposinfinity #if $t8 not equal to $t7, go to label
	
	li $t7, 0x7F800001 #5th special case
	li $t6, 0x7FFFFFFF
	ble $t7, $t8, secondtest  #go to second test if  $t7 <= $t8
	
	li $t7, 0xFF800001 #6th special case
	li $t6, 0xFFFFFFFF
	bge $t7, $t8, secondtest2
	j conversionHexStringtoFloatPt
	
secondtest:
	ble $t8, $t6, callingNan #now if its in bounds of $t7 and $t6, callNan
	j conversionHexStringtoFloatPt
	
secondtest2:
	ble $t8, $t6, callingNan #now if its in this bounds of $t7 and $t6, callNan
	j conversionHexStringtoFloatPt
	
callingNan:
	li $v0, 4
	la $a0, nan #prints nan
	syscall
	j prgrm_end #terminates program

callingzero:
	li $v0, 4
	la $a0, zero #prints zero
	syscall
	j prgrm_end #terminates program
	
callingneginfinity:
	li $v0, 4
	la $a0, inf_neg #prints negative infinity
	syscall
	j prgrm_end #terminates program

callingposinfinity:
	li $v0, 4
	la $a0, inf_pos #prints positive infinity
	syscall
	j prgrm_end #terminates program
	
conversionHexStringtoFloatPt:
 	#t8 has the decimal we want to turn into a IEEE 754
	li $t5, 7 #basically how long loop7 runs for
	move $t0, $t8 #moves the decimal into t0
	lbu $t2, 0($t0) 
	srl $t0, $t0, 31 #gets the MSB / sign
	li $t6, 0 #creates a register to calculate sum
	li $t9, 7 #counter
	j loop7

	loop7:
	lbu $t4, 1($t0) #at 1st bit to the left of the MSB
	li $t0, 2
	mul $t6, $t6, $t0
	add $t6, $t6, $t4
	sll $t0, $t0, 1 #shifts the bit to the left
	li $t9, 1
	sub $t7, $t7, $t9
	blez $t5,loop7
	
	li $t9, 127
	sub $t6, $t6, $t9 #gives the final result of exponent
	move $a0, $t6 #moves exponent from $t6 to $a0
	li $t7, 22 # basically how long the loop8 runs for
	j loop9
	
	li $t9, 0 #sum of mantissa
	loop9:
	li $t0, 2
	mul $t9, $t9, $t0
	add $t9, $t9, $t4
	sll $t0, $t0, 1 #keeps shifting the bit to the left
	li $t9, 1
	sub $t7, $t7, $t9
	blez $t7, loop9
	
	move $a1, $t9 #moves register from $t9 into arguement $a1
	
	j callingthefunction
	
callingthefunction:
	li $v0, 1 #print int
	move $a0, $t6 # prints exponent
	syscall
	
	li $v0, 4 #prints string of Mantissa
	sw $a1, mantissa #loads address of mantissa into $a1
	syscall
	
	j prgrm_end #terminates program
	
LootCardGame:

	lw $t3, arg2_addr #loads the second argument into $t3
	li $t9, 12 # create a counter to 12
	li $t7, 0 #create a counter of 0
	li $t4, 0 # sum

	loop6:
	lbu $t5, 0($t3)
	lbu $t6, 1($t3)
	li $t0, 49
	blt $t5, $t0 invalid_args_msg #if the character is less than 1, gives invalid
	#message
	li $t0, 57
	bgt $t5, $t0, invalid_args_msg #if the character is more than 9, gives invalid
	li $t0, 80 # P
	bne $t6, $t0, invalidM
	li $t0, 80
	beq $t6,$t0, subprev
	j loop6
	bne $t9, $t0, invalid_args_msg #if the length is not 12, then it gives error
	
	loop11: 
	addi $t7, $7, 2 #adds to counter starting from 0 
	addi $t3, $t3, 2 #goes to the character after the next character
	li $t0, 2
	sub $t9, $t9, $t0 #subtracts 2 from counter each iteration
	li $t0, 12
	bgtz $t9, loop6 #as long as the character is not null, it loops
	j resultofLootCardGame 
	
addprev:
	li $t0, 48
	sub $t5, $t5, $t0
	add $t4, $t4, $t5 #if its M it adds the previous term
	j loop11

subprev: 
	li $t0, 48
	sub $t5, $t5, $t0
	sub $t4, $t4, $t5 #if its P it subtracts the previous term
	j loop11

invalidM:
	li $t0, 77 # M 
	bne $t6, $t0, invalid_args_msg # if its not equal to P now after the 
	#other conditions, than it goes to invalid_args_msg
	j addprev

resultofLootCardGame:
	move $a0, $t4 #loads the value to print  
	li $v0, 1 #gets ready to print integer
	syscall #prints integer
	j prgrm_end


prgrm_end: #terminates the program
	li $v0,10
	syscall