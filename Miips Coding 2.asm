################# Rishith Kyatham #################

.text
.globl to_upper
to_upper:
loop1:
lb $t0, 0($a0) #Loading index 0 of character
beq $t0, $0, end
li $t1, 97
bge $t0, $t1, greaterthn
sb $t0, 0($a0)
addi $a0, $a0, 1
j loop1

greaterthn:
li $t1, 122
ble $t0, $t1, subtract
j notsubtract

subtract:
addi $t0, $t0, -32 #converts Character from lower case to upper case
sb $t0, 0($a0) #stores it back after performing lower to upper case
addi $a0, $a0, 1 #goes to the next index
j to_upper

notsubtract:
addi $a0,$a0,1
j loop1

end:
jr $ra

.globl remove
remove:

li $t2, 0
li $t3, 0
move $t4, $a0
j loop3

loop3:
lb $t1, 0($t4)
beq $t1, $0, checknow
addi $t3, $t3, 1
addi $t4,$t4, 1
j loop3

checknow:
bge $a1, $t3, end2
li $t5, 0
blt $a1, $t5, end2

loop2:
lb $t1, 0($a0)
beq $t1, $0, end1
beq $t2, $a1, remove2
addi $a0, $a0, 1
addi $t2, $t2, 1
j loop2

remove2:
lb $t1, 1($a0)
sb $t1, 0($a0)
lb $t1, 0($a0)
beq $t1, $0, end1
addi $a0, $a0, 1
j remove2

end1:
li $v0, 1
jr $ra

end2:
li $v0, -1
jr $ra

.globl getRandomInt
getRandomInt:
 labelcheck:
 move $a1, $a0 # now $a1 has the N
 li $t1, 0
 ble $a1, $t1, dothis #if N <= 0 , then go to dothis
 j functions #otherwise, jump to functions
 
functions:

li $v0, 42
syscall
move $v0, $a0
li $v1, 1
jr $ra
 
 dothis:
 li $v0, -1 #here $v0 would be -1
 li $v1, 0 # here $v1 would be 0
 jr $ra  
 
.globl cpyElems

cpyElems:
lb $t0, 0($a0) #takes the base address of the source string
j checknow2

checknow2:
li $t1, 0
blt $a1, $t1, finaljmp2 #checks if index is non-negative integer index
li $t3, 0 #creates a counter
j theloop

theloop:
lb $t0, 0($a0) #takes the base address of the source string
beq $t3, $a1, thenextloop #when the index = the counter, we load the
#character from there to the $a2 base address
beq $t0, $0, finaljmp2 #When it reaches null, it gives empty string
addi $a0, $a0, 1 #iterates to the next character
addi $t3, $t3, 1 #adds 1 to the counter every loop
j theloop

thenextloop:
sb $t0, 0($a2) #stores it into first character of $a2 
addi $a2, $a2, 1
move $v0, $a2 #returns the next address of the destination string in $v0
j finaljmp2

finaljmp2:
 jr $ra

.globl genKey
genKey:
move $t7, $a1
move $t3, $a0
move $t6, $a0
lb $t0, 0($t3) #alphabet
lb $t2, 0($a1) #the key
j loop10

loop10:
lb $t0, 0($t3)
sb $t0, 0($a1)
li $t4, 25 #counter is 25
beq $t0, $0, keyfunction
addi $t3, $t3, 1 #goes to the next index
addi $a1, $a1, 1 #goes to the next index
j loop10

keyfunction: #Now key contains A-Z
move $a0, $t4 #counter is bound here
move $a1, $a0
li $v0, 42
syscall
move $t1, $a0 #moves random index # to $t1

move $a1, $t7

add $a1, $a1, $t1
lb $t9, 0($a1) #Loads the index at counter
move $a1, $t6 #resets the index counter
add $a1, $a1, $t4
lb $t8, 0($a1) #loads the last index
move $a1, $t6 #resets the index counter

add $a1, $a1, $t4 #goes to the N-1 index
sb $t9, 0($a1) #stores the N element at last element (swap)
move $a1, $t6 #resets the index counter
add $a1, $a1, $t1 # goes to random index
sb $t8, 0($a1) #stores the last element at N (swap)
move $a1, $t6 #resets the index counter

addi $t4, $t4, -1  #now you go down 1 
beq $t4, $zero, finalrun #when loop should end
j keyfunction

finalrun:
jr $ra

.globl contains
contains:
lb $t0, 0($a0) #takes the base address of the string (null-terminated)
li $t2, 0 #loads a index

loop7:
lb $t0, 0($a0) #loads
beq $t0, $a1, finaljr
beq $t0, $0, finaljr2  
addi $a0, $a0, 1 #for iterating
addi $t2, $t2, 1 #increasing index by 1
j loop7

finaljr:
move $v0, $t2
jr $ra

finaljr2:
li $v0, -1
jr $ra
 
.globl pair_exists
pair_exists:

lb $t0, 0($a2) #loads base address
move $t4, $a2

loop9:
lb $t5, 0($t4) #loads the base address for the condition check
beq $t5, $0, loop8 #start if it does exist b/c doesnotexist does not get called
li $t6, 65
blt $t5, $t6, doesnotexist
li $t6, 90
bgt $t5, $t6, doesnotexist
addi $t4, $t4, 1 #to iterate
j loop9

loop8:
lb $t0, 0($a2) #first index
lb $t1, 1($a2) #the next index
beq $t0, $a0, testforthis #if character is $a0, then go to testforthis
beq $t0, $a1, testforthis2 #if character is $a1, then go to testforthis2
beq $t0, $0, doesnotexist
addi $a2, $a2, 1 #for iterrating 
j loop8

testforthis:
beq $t1, $a1, finalcodee
j iterates

testforthis2:
beq $t1, $a0, finalcodee
j iterates

iterates:
addi $a2, $a2, 1 #for iterrating 
j loop8

finalcodee:
li $v0, 1
jr $ra

doesnotexist:
li $v0, 0
jr $ra

.globl encrypt
encrypt:
addi $sp, $sp, -16 #allocate space in stack
sw $s0, 0($sp) #arguement 0
sw $s1, 4($sp) #arguement 1
sw $s2, 8($sp) #arguement 2
sw $ra, 12($sp) #preserve the return address
jal to_upper #now after this s0 has the output stored
move $s0, $a0 #plaintext
move $s1, $a1 #cipherkey
move $s2, $a2 #ciphertext

move $a0, $s0
move $t8, $s0

checkthatsit:
lb $t0, 0($t8)
li $t1, 65
blt $t0, $t1, failedencrypt
li $t1, 90
bgt $t0, $t1, failedencrypt
li $t1, 32 # space
beq $t0, $t1, ignorethecase
beq $t0, $0, loop20
addi $t8, $t8, 1
j checkthatsit
#done with initial conditions
ignorethecase:
addi $t8, $t8, 1
j checkthatsit

loop20: #Contains takes a string and a char 
#and if it finds it, returns the index of where it is located
lb $t1, 0($s1)
lb $t2, 1($s1) #s1 is the cyper key
beq $t0, $t1, labelfree
beq $t0, $t2, labelfree2
#else statement
beqz $t1, passedencrypt
beqz $t2, passedencrypt
addi $s1, $s1, 2
j loop20

labelfree:
 sb $t2, 0($s2)
 addi $s2, $s2, 1
 addi $s0, $s0, 1
 j loop20
 
 labelfree2:
 sb $t1, 0($s2)
 addi $s2, $s2, 1
 addi $s0, $s0, 1 
j loop20

failedencrypt:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $ra 12($sp)
addi $sp, $sp, 16
li $v0, 0
jr $ra

passedencrypt:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $ra 12($sp)
addi $sp, $sp, 16
li $v0, 1
jr $ra

.globl decipher_key_with_chosen_plaintext
decipher_key_with_chosen_plaintext:
j endingchoices #tried but didn't work
#lb $t0, 0($a0)
#lb $t1, 0($a1)
#lb $t2, 0($a2) #the key your inputting into
#move $t3, $a2 #empty string is moved to $t3 so we can always reference first index
#move $t4, $a2 #temporary


endingchoices:
jr $ra
#j loop12

#loop12:
#lb $t0, 0($a0)
#lb $t1, 0($a1)
#lb $t2, 0($a2)
#beq $t1, $0, endgame5
#move $t4, $t3 #resets index
#j loop13

#loop13:
#lb $t5, 0($t4) #takes the base address of the string (null-terminated)
#beq $t5, $t0, checkforsecond #check if every string in $t4 is equal to $t5 (in string)
#beq $t5, $0, inString #then its not in string
#addi $t4, $t4, 1 #increasing index by 1
#j loop13

#inString:
#sb $t0, 0($a2)
#sb $t1, 0($t4)
#addi $a2, $a2, 1 #index increase
#move $t4, $t3 #resets index
#loop14:
#lb $t5, 0($t4) #takes the base address of the string (null-terminated)
#beq $t5, $t1, checkyes #check if every string in $t4 is equal to $t5 (in string)
#beq $t5, $0, inString2 #then its in string
#addi $t4, $t4, 1 #increasing index by 1
#j loop14

#checkforsecond:
#move $t4, $t3 #resets index
#loop15:
#lb $t5, 0($t4) #takes the base address of the string (null-terminated)
#beq $t5, $t1, checkforsecond2 #check if every string in $t4 is equal to $t5 (in string)
#beq $t5, $0, secondisin #then its not in string
#addi $t4, $t4, 1 #increasing index by 1
#j loop15

#checkforsecond2:
#addi $a1, $a1, 1
#addi $a0, $a0, 1
#j loop12

#secondisin:
#sb $t2, 0($a2)
#sb $t2, 0($t4)
#addi $a2, $a2, 1
#addi $a1, $a1, 1
#addi $a0, $a0, 1
#j loop12

#checkyes:
#addi $a1, $a1, 1
#addi $a0, $a0, 1
#j loop12

#inString2:
#sb $t1, 0($a2)
#sb $t1, 0($t4)
#addi $a2, $a2, 1
#addi $a1, $a1, 1
#addi $a0, $a0, 1
#j loop12