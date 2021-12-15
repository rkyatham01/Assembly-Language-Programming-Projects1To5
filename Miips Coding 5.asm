############## Rishith Kyatham ##############

.text:
.globl create_term
create_term:
li $t2, 0
beq $a0, $t2, Returnthenegativeone #if the coef is 0
blt $a1, $t2, Returnthenegativeone #if the exp is less than 0 

move $t0, $a0 #moving whats in $a0 (coefficient) to $t0
li $t1, 12
move $a0, $t1 #gonna store 12 bytes
li $v0, 9
syscall
move $a0,$t0 #moves it back
sw $a0, 0($v0)
sw $a1, 4($v0)
li $t2, 0 
sw $t2, 8($v0) 
move $a0, $t0 #moves back $t0 into $a0 after allocating memory in the heap

move $t3,$v0 #gets the address of allocated memory and moves it

#now do the checks they ask
j ReturntheaddressofTerm

ReturntheaddressofTerm:
move $v0, $t3 #moves it back
jr $ra

Returnthenegativeone:
li $v0, -1
jr $ra

.globl create_polynomial
create_polynomial:
li $t0, 0 # a counter
li $t9, 0 # the size of pairs
li $t6, 0 #another counter for outer for loop for Sorting
move $t2, $a0
j SizeOfPair

############################
#Putting the size in t9
#FINDS THE SIZE OF PAIRS
SizeOfPair:
lw $t1, 4($t2)
li $t3, -1
beq $t1, $t3, CheckIfItsRightOne #if its = -1
addi $t9, $t9, 1 #adds 1 to the Size
addi $t2, $t2, 8 #goes to next iteration
j SizeOfPair

CheckIfItsRightOne:
lw $t1, 0($t2)
li $t3, 0
beq $t1, $t3, BeforeBubbleSort
j ElseDoThisAndReturn

ElseDoThisAndReturn:
addi $t9, $t9, 1 #adds 1 to the Size
addi $t2, $t2, 8 #goes to next iteration
j SizeOfPair

BeforeBubbleSort:
move $t2, $a0
li $t0, 1
li $t6, 1 #another counter for outer for loop for Sorting
j Bubblesort
#############################

##################################
#FOR SORTING ONLY
Bubblesort:
lw $t1, 4($t2) #gets 4
lw $t3, 12($t2) #gets 9

bgt $t3, $t1, SwapHere #if $t3 is greater than $t1
addi $t0, $t0, 1
beq $t0, $t9, SecondForLoop #if it reaches end then the pairs are sorted now
addi $t2, $t2, 8 #iteratting
j Bubblesort

DoThisAndThenGoBack:
addi $t0, $t0, 1 #adding to iteration
addi $t2, $t2, 8
beq $t0, $t9, SecondForLoop #if it reaches end then the pairs are sorted now
j Bubblesort

SwapHere:
move $t4, $t3
sw $t1, 12($t2) #swapping Here
sw $t4, 4($t2)  #swapping Here

lw $t1, 0($t2) #gets the coeff
lw $t3, 8($t2) #gets the coeff
move $t4, $t3
sw $t1, 8($t2) #swapping Here
sw $t4, 0($t2)  #swapping Here
j DoThisAndThenGoBack


SecondForLoop:
move $t2, $a0 #resets the address and loops again Sorting
addi $t6, $t6, 1
beq $t9, $t6, IfNHasTheseConditions
li $t0, 1
j Bubblesort
#######################################
#######################################
#Checks Conditions Of N
#t9 still has the Size
IfNHasTheseConditions:
li $t0, 0
bgt $a1, $t9, SettingSizeToN #if N is greater than the # of pairs in the array
beq $a1, $t0, SettingSizeToN
blt $a1, $t0, SettingSizeToN
j AfterBubbleSort #else it continues if it is in range of 0 < N < # of pairs

SettingSizeToN: #setting the size to N
move $a1, $t9
j AfterBubbleSort

##########################################

AfterBubbleSort:
move $t2, $a0 #move the address back
move $t0, $a0 #moves the address into $t3 too
li $t3, 1 #resetting the counters
li $t6, 1 #resetting the counters
j RemoveTheDuplicates

##########################################
#Removes The Duplicates In the Selected N

RemoveTheDuplicates:
lw $t1, 0($t2)
addi $t0, $t0, 8 #gets the next coefficient
lw $t7, 0($t0) 
beq $t1, $t7, BeforeChecksIfExponentsEqual #if coeffients equal, checks if exponents are equal
addi $t3, $t3, 1 #add to the counter by 1 
beq $t3, $t9, OuterForLoop #Checks if the counter is at N selected bc checks N-1 times
j RemoveTheDuplicates

BeforeChecksIfExponentsEqual:
beq $t2, $t0, DoThisAndGoBack #if the addresses are equal, then move on
j ChecksIfExponentsEqual

DoThisAndGoBack:
addi $t3, $t3, 1 #add to counter and send it right back
j RemoveTheDuplicates

ChecksIfExponentsEqual:
lw $t1, 4($t2) #loads the exponents
lw $t7, 4($t0) #loads the exponents
beq $t1, $t7, IfExponentsEqualThan #if exponents equal, do this
j ElseDoThisAndReturn2

ElseDoThisAndReturn2:
addi $t3, $t3, 1 #add to the counter by 1
beq $t3, $t9, OuterForLoop #Checks if the counter is at N selected bc checks N-1 times
j RemoveTheDuplicates

IfExponentsEqualThan:
li $t5, 0
sw $t5, 0($t0) #stores 0 there
sw $t5, 4($t0) #stores 0 there
addi $t3, $t3, 1 #add to the counter by 1
beq $t3, $a1, OuterForLoop #Checks if the counter is at N selected bc checks N-1 times
j RemoveTheDuplicates


#Here is the outer forloop counter
OuterForLoop:
addi $t6, $t6, 1 #N-1 times so starts at 1
beq $t6, $t9, DoneDeletingDuplicates
addi $t2, $t2, 8
move $t0, $a0 #moves the address back to check again
li $t3, 0 #resets $t3 back before going
j RemoveTheDuplicates


########################################################
#t9 still has the size
DoneDeletingDuplicates:
move $t2, $a0 #move the address back
move $t0, $a0 #moves the address into $t3 too
li $t3, 1 #resetting the counters
li $t6, 1 #resetting the counters

beq $a1, $t3, DoneMergingCoefficients#if a1 for say is 1, then theirs no merging, 
j LoopThatMerges

########################################################
#Loop that Merges
LoopThatMerges:
lw $t1, 4($t2)
addi $t0, $t0, 8 #gets the next exponent
lw $t7, 4($t0) 
beq $t1, $t7, BeforeCheckingExponentsCheckAddresses #if exponents are equal, you add
addi $t3, $t3, 1 #add to the counter by 1 
beq $t3, $a1, OuterForLoopThatMerges #Checks if the counter is at N selected bc checks N-1 times
j LoopThatMerges

BeforeCheckingExponentsCheckAddresses:
beq $t2, $t0, DoThisAndGoBack2 #if the addresses are equal, then move on
j AddThePairsTogetherHere

DoThisAndGoBack2:
addi $t3, $t3, 1 #add to counter and send it right back
beq $t3, $a1, OuterForLoopThatMerges #Checks if the counter is at N selected bc checks N-1 times
j LoopThatMerges

AddThePairsTogetherHere:
li $t5, 0
lw $t1, 0($t2)
lw $t7, 0($t0)
sw $t5, 0($t0) #stores 0 there
sw $t5, 4($t0) #stores 0 there
add $t1, $t1, $t7 #adds the coefficients
sw $t1, 0($t2)
addi $t3, $t3, 1 #add to the counter by 1
beq $t3, $t9, OuterForLoopThatMerges #Checks if the counter is at N selected bc checks N-1 times
j LoopThatMerges

OuterForLoopThatMerges:
addi $t6, $t6, 1 #N-1 times so starts at 1
beq $t6, $a1, DoneMergingCoefficients
addi $t2, $t2, 8
move $t0, $a0 #moves the address back to check again
li $t3, 0 #resets $t3 back before going
j LoopThatMerges

########################################################

DoneMergingCoefficients:
move $t2, $a0 #move the address back
li $t3, 0 # counter that keeps up with Valid terms
li $t5, 0 #Another counter for getting to size
li $t6, 0 #A counter for storing first head address
addi $sp, $sp, -4
sw $ra, 0($sp)
j CheckingIterationOfValidTerms
#t9 still has the Size


########################################################
#Checking Iteration of the amount of Valid Terms
CheckingIterationOfValidTerms:
lw $t1, 0($t2) #gets coefficient
lw $t4, 4($t2) #gets the exponent
li $t0, 0
beq $t1, $t0, DoThisAndComeBackToo  #if coefficient is 0
blt $t4, $t0, DoThisAndComeBackToo #if exponent < 0 
j YouHaveAValidTerm

DoThisAndComeBackToo:
addi $t5, $t5, 1
beq $t5, $a1, ThereAreNoTermsThatAreValid #Go Through N Times
addi $t2, $t2, 8 #iterates to next Node
j CheckingIterationOfValidTerms

YouHaveAValidTerm:
lw $t1, 0($t2) #gets coefficient
lw $t4, 4($t2) #gets the exponent
addi $sp, $sp, -24
sw $t0, 0($sp)
sw $t1, 4($sp)
sw $t2, 8($sp)
sw $t3, 12($sp)
sw $a0, 16($sp)
sw $a1, 20($sp)

move $a0, $t1 #moves the coefficient into this
move $a1, $t4 #moves the exponent into this
jal create_term #calling the function
lw $t0, 0($sp)
lw $t1, 4($sp)
lw $t2, 8($sp)
lw $t3, 12($sp)
lw $a0, 16($sp)
lw $a1, 20($sp)
addi $sp, $sp, 24
move $t9,$v0
#t9 now has the head address
addi $t5, $t5, 1
addi $t6, $t6, 1
addi $t2, $t2, 8 #iterates to next node
beq $t5, $a1, LastThingToDoBeforeReturning #equals the Size selected
j TheActualLoopBecauseNowWeHaveAddress

TheActualLoopBecauseNowWeHaveAddress:
lw $t1, 0($t2) #gets coefficient
lw $t4, 4($t2) #gets the exponent
addi $sp, $sp, -24
sw $t0, 0($sp)
sw $t1, 4($sp)
sw $t2, 8($sp)
sw $t3, 12($sp)
sw $a0, 16($sp)
sw $a1, 20($sp)

move $a0, $t1 #moves the coefficient into this
move $a1, $t4 #moves the exponent into this
jal create_term #calling the function
lw $t0, 0($sp)
lw $t1, 4($sp)
lw $t2, 8($sp)
lw $t3, 12($sp)
lw $a0, 16($sp)
lw $a1, 20($sp)
addi $sp, $sp, 24
move $t8,$v0 #putting this address in t8
li $t0, -1
beq $v0, $t0, ThanYouIgnoreThis
j OtherWiseItsValidSoYouPutInHeap

ThanYouIgnoreThis:
addi $t5, $t5, 1
beq $t5, $a1, LastThingToDoBeforeReturning #equals the Size selected
addi $t2, $t2, 8 #iterates to next Node
j TheActualLoopBecauseNowWeHaveAddress

OtherWiseItsValidSoYouPutInHeap:
addi $v0, $v0, -4 #go back and place the address down
sw $t8, 0($v0) #placing the address down
addi $v0, $v0, 4 #puts it back

addi $t6, $t6, 1 #t6 has the valid # of terms
addi $t5, $t5, 1
beq $t5, $a1, LastThingToDoBeforeReturning #equals the Size selected
addi $t2, $t2, 8 #iterates to next Node
j TheActualLoopBecauseNowWeHaveAddress

#t9 has the address of the head
#t6 has the valid # of terms
###########################################
#Last Thing You DO before returning
LastThingToDoBeforeReturning:
move $t1, $a0 #temporary move 
li $a0, 8
li $v0, 9
syscall #gives you the polynomial struct
sw $t9, 0($v0) #stores the first valid head address
sw $t6, 4($v0) #stores the valid # of terms

lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra
#############################################

ThereAreNoTermsThatAreValid:
li $v0, 0
lw $ra, 0($sp)
addi $sp, $sp, -4
jr $ra

.globl add_polynomial
add_polynomial:
addi $sp, $sp, -4
sw $ra, 0($sp)
li $t4, 0 # a counter for size of pair 1
li $t5, 0 # a counter for size of pair 2

lw $t0, 0($a0) #gets the address of base address of the first pair

GetsTheFirstPair:
lw $t1, 0($t0) #gets the first coefficinet
lw $t2, 4($t0) #gets the first exponent
lw $t3, 8($t0) #check if the address is 0 or not
addi $sp, $sp, -4 #increasing Stack everytime you are adding a coefficient
sw $t2, 0($sp)
addi $sp, $sp, -4 #increasing Stack everytime you are adding a exponent
sw $t1, 0($sp)
addi $t4, $t4, 1 #increasing counter by 1
beqz $t3, GoToSecondPairNow
addi $t0, $t0, 12 #Iterates to the next coefficient and exponent
j GetsTheFirstPair

GoToSecondPairNow:
lw $t0, 0($a1) #gets the address of base address of the Second pair
j GettingSecondPairIntoStack

GettingSecondPairIntoStack:
lw $t1, 0($t0) #gets the first coefficinet
lw $t2, 4($t0) #gets the first exponent
lw $t3, 8($t0) #check if the address is 0 or not
addi $sp, $sp, -4 #increasing Stack everytime you are adding a coefficient
sw $t2, 0($sp)
addi $sp, $sp, -4 #increasing Stack everytime you are adding a exponent
sw $t1, 0($sp)
addi $t5, $t5, 1 #increasing counter by 1
beqz $t3, DoneWithSecondPair
addi $t0, $t0, 12 #Iterates to the next coefficient and exponent
j GettingSecondPairIntoStack

DoneWithSecondPair:
move $t8, $sp #temporary
j BeforeCallingTheBigFunctions

#t4 still has the total size of pair1
#t5 still has the total size of pair2
#t8 has the Stack Pointer
BeforeCallingTheBigFunctions:
li $t9, 0
add $t9, $t5, $t4 #t9 has the total size

move $a0, $t8 #passing it into $a0 
j BeforeBubbleSortAdd

BeforeBubbleSortAdd:
move $t2, $a0
li $t0, 1
li $t6, 1 #another counter for outer for loop for Sorting
j BubblesortForAdd

##################################
#FOR SORTING ONLY
BubblesortForAdd:
lw $t1, 4($t2) #gets 4
lw $t3, 12($t2) #gets 9

bgt $t3, $t1, SwapHereAdd #if $t3 is greater than $t1
addi $t0, $t0, 1
beq $t0, $t9, SecondForLoopAdd #if it reaches end then the pairs are sorted now
addi $t2, $t2, 8 #iteratting
j BubblesortForAdd

DoThisAndThenGoBackForAdd:
addi $t0, $t0, 1 #adding to iteration
addi $t2, $t2, 8
beq $t0, $t9, SecondForLoopAdd #if it reaches end then the pairs are sorted now
j BubblesortForAdd

SwapHereAdd:
move $t4, $t3
sw $t1, 12($t2) #swapping Here
sw $t4, 4($t2)  #swapping Here

lw $t1, 0($t2) #gets the coeff
lw $t3, 8($t2) #gets the coeff
move $t4, $t3
sw $t1, 8($t2) #swapping Here
sw $t4, 0($t2)  #swapping Here
j DoThisAndThenGoBackForAdd

SecondForLoopAdd:
move $t2, $a0 #resets the address and loops again Sorting
addi $t6, $t6, 1
beq $t9, $t6, AfterBubbleSortForAdd
li $t0, 1
j BubblesortForAdd

#Sorts Nicely
AfterBubbleSortForAdd:
move $t2, $a0 #move the address back
move $t0, $a0 #moves the address into $t3 too
li $t3, 1 #resetting the counters
li $t6, 1 #resetting the counters
move $a1, $t9 #puts $t9 in $a1
j LoopThatMergesForAdd

########################################################
#Loop that Merges
LoopThatMergesForAdd:
lw $t1, 4($t2)
addi $t0, $t0, 8 #gets the next exponent
lw $t7, 4($t0) 
beq $t1, $t7, BeforeCheckingExponentsCheckAddressesForAdd #if exponents are equal, you add
addi $t3, $t3, 1 #add to the counter by 1 
beq $t3, $a1, OuterForLoopThatMergesForAdd #Checks if the counter is at N selected bc checks N-1 times
j LoopThatMergesForAdd

BeforeCheckingExponentsCheckAddressesForAdd:
beq $t2, $t0, DoThisAndGoBack2ForAdd #if the addresses are equal, then move on
j AddThePairsTogetherHereForAdd

DoThisAndGoBack2ForAdd:
addi $t3, $t3, 1 #add to counter and send it right back
beq $t3, $a1, OuterForLoopThatMergesForAdd #Checks if the counter is at N selected bc checks N-1 times
j LoopThatMergesForAdd

AddThePairsTogetherHereForAdd:
li $t5, 0
lw $t1, 0($t2)
lw $t7, 0($t0)
sw $t5, 0($t0) #stores 0 there
sw $t5, 4($t0) #stores 0 there
add $t1, $t1, $t7 #adds the coefficients
sw $t1, 0($t2)
addi $t3, $t3, 1 #add to the counter by 1
beq $t3, $t9, OuterForLoopThatMergesForAdd #Checks if the counter is at N selected bc checks N-1 times
j LoopThatMergesForAdd

OuterForLoopThatMergesForAdd:
addi $t6, $t6, 1 #N-1 times so starts at 1
beq $t6, $a1, DoneMergingCoefficientsForAddCheckIteration
addi $t2, $t2, 8
move $t0, $a0 #moves the address back to check again
li $t3, 0 #resets $t3 back before going
j LoopThatMergesForAdd

########################################################

DoneMergingCoefficientsForAddCheckIteration:
li $t5, 0 
move $t2,$a0
lw $t1, 0($t2) #gets coefficient
lw $t4, 4($t2) #gets the exponent
li $t0, 0
beq $t1, $t0, DoThisAndComeBackTooForAdd  #if coefficient is 0
blt $t4, $t0, DoThisAndComeBackTooForAdd #if exponent < 0 
j YouHaveAValidTermForAdd

DoThisAndComeBackTooForAdd:
addi $t5, $t5, 1
beq $t5, $a1, ThereAreNoTermsThatAreValidForAdd #Go Through N Times
addi $t2, $t2, 8 #iterates to next Node
j DoneMergingCoefficientsForAddCheckIteration

YouHaveAValidTermForAdd:
lw $t1, 0($t2) #gets coefficient
lw $t4, 4($t2) #gets the exponent
addi $sp, $sp, -24
sw $t0, 0($sp)
sw $t1, 4($sp)
sw $t2, 8($sp)
sw $t3, 12($sp)
sw $a0, 16($sp)
sw $a1, 20($sp)

move $a0, $t1 #moves the coefficient into this
move $a1, $t4 #moves the exponent into this
jal create_term #calling the function
lw $t0, 0($sp)
lw $t1, 4($sp)
lw $t2, 8($sp)
lw $t3, 12($sp)
lw $a0, 16($sp)
lw $a1, 20($sp)
addi $sp, $sp, 24
move $t9,$v0
#t9 now has the head address
addi $t5, $t5, 1
addi $t6, $t6, 1
addi $t2, $t2, 8 #iterates to next node
beq $t5, $a1, LastThingToDoBeforeReturningForAdd #equals the Size selected
j TheActualLoopBecauseNowWeHaveAddressForAdd

TheActualLoopBecauseNowWeHaveAddressForAdd:
lw $t1, 0($t2) #gets coefficient
lw $t4, 4($t2) #gets the exponent
addi $sp, $sp, -24
sw $t0, 0($sp)
sw $t1, 4($sp)
sw $t2, 8($sp)
sw $t3, 12($sp)
sw $a0, 16($sp)
sw $a1, 20($sp)

move $a0, $t1 #moves the coefficient into this
move $a1, $t4 #moves the exponent into this
jal create_term #calling the function
lw $t0, 0($sp)
lw $t1, 4($sp)
lw $t2, 8($sp)
lw $t3, 12($sp)
lw $a0, 16($sp)
lw $a1, 20($sp)
addi $sp, $sp, 24
move $t8,$v0 #putting this address in t8
li $t0, -1
beq $v0, $t0, ThanYouIgnoreThisForAdd
j OtherWiseItsValidSoYouPutInHeapForAdd

ThanYouIgnoreThisForAdd:
addi $t5, $t5, 1
beq $t5, $a1, LastThingToDoBeforeReturningForAdd #equals the Size selected
addi $t2, $t2, 8 #iterates to next Node
j TheActualLoopBecauseNowWeHaveAddressForAdd

OtherWiseItsValidSoYouPutInHeapForAdd:
addi $v0, $v0, -4 #go back and place the address down
sw $t8, 0($v0) #placing the address down
addi $v0, $v0, 4 #puts it back

addi $t6, $t6, 1 #t6 has the valid # of terms
addi $t5, $t5, 1
beq $t5, $a1, LastThingToDoBeforeReturningForAdd #equals the Size selected
addi $t2, $t2, 8 #iterates to next Node
j TheActualLoopBecauseNowWeHaveAddressForAdd


#############################

#t9 has the address of the head
#t6 has the valid # of terms
###########################################
#Last Thing You DO before returning


ThereAreNoTermsThatAreValidForAdd:
li $t0, 0
j cheaptrick

cheaptrick:
addi $sp, $sp, 4
lw $t0, 0($sp)
li $t1, 500
bgt $t0, $t1, EndsHere
addi $t0, $t0, 1
beq $t0, $t1, EndsHere
j cheaptrick

EndsHere:
li $v0, 0
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

LastThingToDoBeforeReturningForAdd:
#t9 has the address of the head
#t6 has the valid # of terms
###########################################
#Last Thing You DO before returning
move $t1, $a0 #temporary move 
li $a0, 8
li $v0, 9
syscall #gives you the polynomial struct
sw $t9, 0($v0) #stores the first valid head address
sw $a1, 4($v0) #stores the valid # of terms

GoToThisLoopBeforeFinal2:
addi $sp, $sp, 4
lw $t0, 0($sp)
li $t1, 500
bgt $t0, $t1, FinalProduct
j GoToThisLoopBeforeFinal2

FinalProduct:
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

.globl mult_polynomial
mult_polynomial:
addi $sp, $sp, -4
sw $ra, 0($sp)
li $t4, 0 # a counter for size of pair 1
li $t5, 0 # a counter for size of pair 2

lw $t0, 0($a0) #gets the address of base address of the first pair

GetsTheFirstPairForMult:
lw $t1, 0($t0) #gets the first coefficinet
lw $t2, 4($t0) #gets the first exponent
lw $t3, 8($t0) #check if the address is 0 or not
addi $sp, $sp, -4 #increasing Stack everytime you are adding a coefficient
sw $t2, 0($sp)
addi $sp, $sp, -4 #increasing Stack everytime you are adding a exponent
sw $t1, 0($sp)
addi $t4, $t4, 1 #increasing counter by 1
beqz $t3, GoToSecondPairNowForMult
addi $t0, $t0, 12 #Iterates to the next coefficient and exponent
j GetsTheFirstPairForMult

GoToSecondPairNowForMult:
lw $t0, 0($a1) #gets the address of base address of the Second pair
move $t7, $sp #address of 2nd pair starting
j GettingSecondPairIntoStackForMult

GettingSecondPairIntoStackForMult:
lw $t1, 0($t0) #gets the first coefficinet
lw $t2, 4($t0) #gets the first exponent
lw $t3, 8($t0) #check if the address is 0 or not
addi $sp, $sp, -4 #increasing Stack everytime you are adding a coefficient
sw $t2, 0($sp)
addi $sp, $sp, -4 #increasing Stack everytime you are adding a exponent
sw $t1, 0($sp)
addi $t5, $t5, 1 #increasing counter by 1
beqz $t3, DoneWithSecondPairForMult
addi $t0, $t0, 12 #Iterates to the next coefficient and exponent
j GettingSecondPairIntoStackForMult

DoneWithSecondPairForMult:
move $t8, $sp #temporary
move $t9, $t7 #has the address 
j BeforeCallingTheBigFunctionsForMult

#t4 still has the total size of pair1
#t5 still has the total size of pair2
#t8 has the Stack Pointer
BeforeCallingTheBigFunctionsForMult:

move $a0, $t8 #address of first pair
li $t3, 0 # a counter
li $t6, 0 # a counter

j StartTheExpanding

StartTheExpanding:
lw $t0, 4($t8)
lw $t1, 4($t7)

add $t2, $t0, $t1 #puts it in $t2
addi $sp, $sp, -4
sw $t2, 0($sp) #puts it into a new place

lw $t0, 0($t8)
lw $t1, 0($t7)

mul $t2, $t0, $t1 #puts it in $t2
addi $sp, $sp, -4
sw $t2, 0($sp)

addi $t7, $t7, 8
addi $t3, $t3, 1 #adds to the counter
beq $t3, $t5, SecondForLoopForFirstPairCheck #goes until this equals size 2
#goes Until This
j StartTheExpanding

SecondForLoopForFirstPairCheck:
addi $t6, $t6, 1
beq $t6, $t4, DoneExpanding
li $t3, 0 #else resetting counter
addi $t8, $t8, 8
move $t7, $t9 #resets the address
j StartTheExpanding

DoneExpanding:
mul $t8, $t4, $t5
move $t9, $t8
li $t0, 8
mul $t8, $t8, $t0 #amount you gotta add to back to the stack


move $t3 ,$sp #Here $t0 would have the base pointer to the address
move $t2 ,$t3
move $t0, $t3
move $a1 ,$t9
move $a0, $t3
li $t3, 1 #resetting the counters
li $t6, 1 #resetting the counters
j MergeTime
#t9 has The # of iterations

MergeTime:
########################################################
#Loop that Merges
LoopThatMergesForAddForMult:
lw $t1, 4($t2)
addi $t0, $t0, 8 #gets the next exponent
lw $t7, 4($t0) 
beq $t1, $t7, BeforeCheckingExponentsCheckAddressesForAddForMult #if exponents are equal, you add
addi $t3, $t3, 1 #add to the counter by 1 
beq $t3, $a1, OuterForLoopThatMergesForAddForMult #Checks if the counter is at N selected bc checks N-1 times
j LoopThatMergesForAddForMult

BeforeCheckingExponentsCheckAddressesForAddForMult:
beq $t2, $t0, DoThisAndGoBack2ForAddForMult #if the addresses are equal, then move on
j AddThePairsTogetherHereForAddForMult

DoThisAndGoBack2ForAddForMult:
addi $t3, $t3, 1 #add to counter and send it right back
beq $t3, $a1, OuterForLoopThatMergesForAddForMult #Checks if the counter is at N selected bc checks N-1 times
j LoopThatMergesForAddForMult

AddThePairsTogetherHereForAddForMult:
li $t5, 0
lw $t1, 0($t2)
lw $t7, 0($t0)
sw $t5, 0($t0) #stores 0 there
sw $t5, 4($t0) #stores 0 there
add $t1, $t1, $t7 #adds the coefficients
sw $t1, 0($t2)
addi $t3, $t3, 1 #add to the counter by 1
beq $t3, $t9, OuterForLoopThatMergesForAddForMult #Checks if the counter is at N selected bc checks N-1 times
j LoopThatMergesForAddForMult

OuterForLoopThatMergesForAddForMult:
addi $t6, $t6, 1 #N-1 times so starts at 1
beq $t6, $a1, BeforeBubbleSortAddMult
addi $t2, $t2, 8
move $t0, $a0 #moves the address back to check again
li $t3, 0 #resets $t3 back before going
j LoopThatMergesForAddForMult

########################################################
#Does The Bubble Sort 
BeforeBubbleSortAddMult:
move $t2, $a0
li $t0, 1
li $t6, 1 #another counter for outer for loop for Sorting
move $t2, $sp #Lol
j BubblesortForAddMult

##################################
#FOR SORTING ONLY
BubblesortForAddMult:
lw $t1, 4($t2) #gets 4
lw $t3, 12($t2) #gets 9

bgt $t3, $t1, SwapHereAddMult #if $t3 is greater than $t1
addi $t0, $t0, 1
beq $t0, $t9, SecondForLoopAddMult #if it reaches end then the pairs are sorted now
addi $t2, $t2, 8 #iteratting
j BubblesortForAddMult

DoThisAndThenGoBackForAddMult:
addi $t0, $t0, 1 #adding to iteration
addi $t2, $t2, 8
beq $t0, $t9, SecondForLoopAddMult #if it reaches end then the pairs are sorted now
j BubblesortForAddMult

SwapHereAddMult:
move $t4, $t3
sw $t1, 12($t2) #swapping Here
sw $t4, 4($t2)  #swapping Here

lw $t1, 0($t2) #gets the coeff
lw $t3, 8($t2) #gets the coeff
move $t4, $t3
sw $t1, 8($t2) #swapping Here
sw $t4, 0($t2)  #swapping Here
j DoThisAndThenGoBackForAddMult

SecondForLoopAddMult:
move $t2, $a0 #resets the address and loops again Sorting
addi $t6, $t6, 1
beq $t9, $t6, AfterBubbleSortForAddMult
li $t0, 1
j BubblesortForAddMult

#######################################################
#Putting it in the Heap
AfterBubbleSortForAddMult:
li $t5, 0 
move $t2,$sp
lw $t1, 0($t2) #gets coefficient
lw $t4, 4($t2) #gets the exponent
li $t0, 0
beq $t1, $t0, DoThisAndComeBackTooForAddForMult  #if coefficient is 0
blt $t4, $t0, DoThisAndComeBackTooForAddForMult #if exponent < 0 
j YouHaveAValidTermForAddForMult

DoThisAndComeBackTooForAddForMult:
addi $t5, $t5, 1
beq $t5, $a1, ThereAreNoTermsThatAreValidForAddForMult #Go Through N Times
addi $t2, $t2, 8 #iterates to next Node
j AfterBubbleSortForAddMult

YouHaveAValidTermForAddForMult:
lw $t1, 0($t2) #gets coefficient
lw $t4, 4($t2) #gets the exponent
addi $sp, $sp, -24
sw $t0, 0($sp)
sw $t1, 4($sp)
sw $t2, 8($sp)
sw $t3, 12($sp)
sw $a0, 16($sp)
sw $a1, 20($sp)

move $a0, $t1 #moves the coefficient into this
move $a1, $t4 #moves the exponent into this
jal create_term #calling the function
lw $t0, 0($sp)
lw $t1, 4($sp)
lw $t2, 8($sp)
lw $t3, 12($sp)
lw $a0, 16($sp)
lw $a1, 20($sp)
addi $sp, $sp, 24
move $t7,$v0
#t9 now has the head address
addi $t5, $t5, 1
addi $t6, $t6, 1
addi $t2, $t2, 8 #iterates to next node
beq $t5, $a1, LastThingToDoBeforeReturningForAddForMult #equals the Size selected
j BeforeTheActualLoopBecauseNowWeHaveAddressForAddForMult

BeforeTheActualLoopBecauseNowWeHaveAddressForAddForMult:
li $t6, 1
j TheActualLoopBecauseNowWeHaveAddressForAddForMult

#t7 Now has the head address
TheActualLoopBecauseNowWeHaveAddressForAddForMult:
lw $t1, 0($t2) #gets coefficient
lw $t4, 4($t2) #gets the exponent
addi $sp, $sp, -32
sw $t0, 0($sp)
sw $t1, 4($sp)
sw $t2, 8($sp)
sw $t3, 12($sp)
sw $a0, 16($sp)
sw $a1, 20($sp)
sw $t7, 24($sp)
sw $t6, 28($sp)

move $a0, $t1 #moves the coefficient into this
move $a1, $t4 #moves the exponent into this
jal create_term #calling the function
lw $t0, 0($sp)
lw $t1, 4($sp)
lw $t2, 8($sp)
lw $t3, 12($sp)
lw $a0, 16($sp)
lw $a1, 20($sp)
lw $t7, 24($sp)
lw $t6, 28($sp)
addi $sp, $sp, 32
move $t8,$v0 #putting this address in t8
li $t0, -1
beq $v0, $t0, ThanYouIgnoreThisForAddForMult
j OtherWiseItsValidSoYouPutInHeapForAddForMult

ThanYouIgnoreThisForAddForMult:
addi $t5, $t5, 1
beq $t5, $a1, LastThingToDoBeforeReturningForAddForMult #equals the Size selected
addi $t2, $t2, 8 #iterates to next Node
j TheActualLoopBecauseNowWeHaveAddressForAddForMult

OtherWiseItsValidSoYouPutInHeapForAddForMult:
addi $v0, $v0, -4 #go back and place the address down
sw $t8, 0($v0) #placing the address down
addi $v0, $v0, 4 #puts it back

addi $t6, $t6, 1 #t6 has the valid # of terms
addi $t5, $t5, 1
beq $t5, $a1, LastThingToDoBeforeReturningForAddForMult #equals the Size selected
addi $t2, $t2, 8 #iterates to next Node
j TheActualLoopBecauseNowWeHaveAddressForAddForMult


ThereAreNoTermsThatAreValidForAddForMult:
li $t0, 0 # a counter
j LoopAroundTrust

LoopAroundTrust:
addi $sp, $sp, 4
lw $t0, 0($sp)
li $t1, 500
bgt $t0, $t1, DoThisHehe2
addi $t0, $t0, 1
beq $t0, $t1, DoThisHehe2
j LoopAroundTrust

DoThisHehe2:
#li $t5, 8
#mul $t0, $t9, $t5 # 8 times size

#add $sp, $sp, $t0
#add $sp, $sp, $t0 #adds back to stack from the Expanding Done
li $v0, 0
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

LastThingToDoBeforeReturningForAddForMult:
#t9 has the address of the head
#t6 has the valid # of terms
###########################################
#Last Thing You DO before returning
#move $t1, $a0 #temporary move 
li $a0, 8
li $v0, 9
syscall #gives you the polynomial struct
sw $t7, 0($v0) #stores the first valid head address
sw $t6, 4($v0) #stores the valid # of terms
j GoToThisLoopBeforeFinal
#li $t5, 8
#mul $t0, $t9, $t5 # 8 times size

#add $sp, $sp, $t0
#add $sp, $sp, $t0
GoToThisLoopBeforeFinal:
addi $sp, $sp, 4
lw $t0, 0($sp)
li $t1, 500
bgt $t0, $t1, DoThisHehe
j GoToThisLoopBeforeFinal

DoThisHehe:
j FinalEnding

FinalEnding:
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra
