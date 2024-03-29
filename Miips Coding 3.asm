######### Rishith Kyatham ##########

.text
.globl initialize
initialize:
#opening a file
li $v0, 13 #to open the file
move $t6, $a1 #moving for temporary
li $a1, 0 #to open the file in read mode
li $a2, 0 #ignored and is 0
syscall
move $t0, $v0 #to save the file descriptor

#reading a file :
#reads first character as rows
readingfirstcharacterAndFileName:
li $v0, 14 #syscall for reading from file
move $a0, $t0
move $a1, $t6 #moving back
li $a2, 1 # reads the first
syscall #moves input test file by 1

lb $t1, 0($a1)
li $t2, 49
bge $t1, $t2, checkstheothercase #checks if $t1 is greater than or equal to 0
j ending2

checkstheothercase:
li $t2, 57
ble $t1, $t2, checkpassed #checks if $t1 is less than or equal to 9
j ending2

checkpassed:
addi $t1, $t1, -48 #making it an integer
sw $t1, 0($a1) #storing the integer
addi $a1, $a1, 4 #moving the buffer 
j readingnextcharactername

readingnextcharactername:
li $v0, 14 #syscall for reading from file
li $a2, 1 # reads the second character
syscall #moves input test file by 1
lb $t1, 0($a1)
li $t2, 49
li $t2, 13
beq $t1, $t2, ifitsr #syscalltwice if $t1 is \r
li $t2, 10
beq $t1, $t2, ifitsn #syscall once if $t1 is \n
j ending2 #if its not within the range

ifitsr: #syscall twice if $t1 is \r to read over the next 2 characters
li $v0, 14
li $a2, 1
syscall
li $t5, 0 #set it as 0
sw $t5, 0($a1)#need to set it as 0
li $v0, 14
li $a2, 1
syscall
j checkingnorrandskiplines

ifitsn: #syscall once if $t1 is \n to read over the next 2 characters
li $v0, 14
li $a2, 1
li $t5, 0 #set it as 0
sw $t5, 0($a1)#need to set it as 0
syscall
j checkingnorrandskiplines

checkingnorrandskiplines:
lb $t1, 0($a1)
li $t2, 49
bge $t1, $t2, checkstheothercase2 #checks if $t1 is greater than or equal to 0
j ending2

checkstheothercase2:
li $t2, 57
ble $t1, $t2, checkpassed2 #checks if $t1 is less than or equal to 9
j ending2

checkpassed2:
lb $t1, 0($a1)
addi $t1, $t1, -48 #making it an integer
sw $t1, 0($a1) #storing the integer
addi $a1, $a1, 4 #moving the buffer 
j checkingnorrandskiplines2

checkingnorrandskiplines2:
li $v0, 14 #syscall for reading from file
li $a2, 1 # reads the second character
syscall #moves input test file by 1
lb $t1, 0($a1)
li $t2, 13
beq $t1, $t2, ifitsr2 #syscalltwice if $t1 is \r
li $t2, 10
beq $t1, $t2, ifitsn2 #syscall once if $t1 is \n
j ending2 #if its not within the range

ifitsr2: #syscall twice if $t1 is \r to read over the next 2 characters
li $v0, 14
li $a2, 1
syscall
li $t5, 0 #set it as 0
sw $t5, 0($a1)#need to set it as 0
li $v0, 14
li $a2, 1
syscall
j loopforcheckingthematricesandstuffnow

ifitsn2: #syscall once if $t1 is \n to read over the next 2 characters
li $v0, 14
li $a2, 1
li $t5, 0 #set it as 0
sw $t5, 0($a1)#need to set it as 0
syscall
j loopforcheckingthematricesandstuffnow

loopforcheckingthematricesandstuffnow:
lb $t1, 0($a1)
li $t2, 48
bge $t1, $t2, checkstheothercase3 #checks if $t1 is greater than or equal to 0
beqz $v0, closethefile #when it reaches the end, $v0 would be 0
j ending2

checkstheothercase3:
li $t2, 57
ble $t1, $t2, checkpassed3 #checks if $t1 is less than or equal to 9
j ending2

checkpassed3:
lb $t1, 0($a1)
addi $t1, $t1, -48 #making it an integer
sw $t1, 0($a1) #storing the integer
addi $a1, $a1, 4 #moving the buffer
lw $t4, 0($a1) #for input 5
bnez $t4, ending1
li $v0, 14 #syscall for reading from file
li $a2, 1 # reads the second character
syscall #moves input test file by 1
lb $t1, 0($a1)
li $t2, 13
beq $t1, $t2, ifitsr3 #syscalltwice if $t1 is \r
li $t2, 10
beq $t1, $t2, ifitsn3 #syscall once if $t1 is \n
j loopforcheckingthematricesandstuffnow

checkpassed4:
lb $t1, 0($a1)
li $t2, 13
beq $t1, $t2, ifitsr3 #syscalltwice if $t1 is \r
li $t2, 10
beq $t1, $t2, ifitsn3 #syscall once if $t1 is \n
j loopforcheckingthematricesandstuffnow

ifitsr3: #syscall twice if $t1 is \r to read over the next 2 characters
li $v0, 14
li $a2, 1
syscall
li $t5, 0 #set it as 0
sw $t5, 0($a1)#need to set it as 0
li $v0, 14
li $a2, 1
syscall
j checkpassed4

ifitsn3: #syscall once if $t1 is \n to read over the next 2 characters
li $v0, 14
li $a2, 1
li $t5, 0 #set it as 0
sw $t5, 0($a1)#need to set it as 0
syscall
j checkpassed4

#closing the file
closethefile:
li $v0, 16
move $a0,$t0 #closes the file descriptor
syscall
j ending1

#if initialization errors occur
ending1:
li $v0, 1
jr $ra

#if everything reads well
ending2:
li $t2, 0
li $t3, 84
li $t7, 0 #counter
j finish

finish:
addi $t7, $t7, 1
sw $t2, 0($t6)
addi $t6, $t6, 4
beq $t7, $t3, ending2act #if counter is 82, then exit loop
j finish

ending2act:
li $v0, -1
jr $ra
 
.globl write_file
write_file:
#putting a file in read mode
li $t8, 0 # another counter
li $t4, 0 # a counter
li $t5, 1 # another counter

li $v0, 13 #to open the file
move $t1, $a1 #moving for temporary the file descriptor
li $a1, 1 #to open the file in write mode
li $a2, 0 #ignored and is 0
syscall
move $t0, $v0 #to save the file descriptor
move $a1, $t1 #moves back the input buffer basically
lb $t2, 0($a1)
move $t7, $t2 # rows
addi $t2, $t2, 48
sw $t2, 0($a1) #moves back the input buffer basically

writingtoafile:
li $v0, 15
move $a0, $t0 #file descriptor 
li $a2, 1 #we are writing one character at a time
syscall
li $t2, 10
sw $t2, 0($a1)
li $v0, 15
li $a2, 1 #we are writing one character at a time
syscall
addi $a1, $a1, 4 #moves it to next
j nextcharacterwritten

nextcharacterwritten:
lb $t2, 0($a1) 
move $t8, $t2 #of columns
addi $t2, $t2, 48 #convert
sw $t2, 0($a1)#stores the converted ascii
li $v0, 15
li $a2, 1 #we are writing one character at a time
syscall
li $t2, 10
sw $t2, 0($a1)
li $v0, 15
li $a2, 1 #we are writing one character at a time
syscall
addi $a1, $a1, 4 #moves it to next
j aloopthatkeepsoninputtingthevalues

aloopthatkeepsoninputtingthevalues:
lw $t2, 0($a1)
addi $t2, $t2, 48
sw $t2, 0($a1) #moves back the input buffer basically
li $v0, 15
li $a2, 1 #we are writing one character at a time
syscall
addi $t4, $t4, 1
beq $t4, $t8, replacewithnhere2
addi $a1, $a1, 4 #goes to next
j aloopthatkeepsoninputtingthevalues

checkerbefore:
beq $t5, $t7, beforespecial # = to num of columns
j aloopthatkeepsoninputtingthevalues

beforespecial:
li $t7, 1
j specialconditionyay

specialconditionyay:
lb $t2, 0($a1)
addi $t2, $t2, 48
sw $t2, 0($a1) #moves back the input buffer basically
li $v0, 15
li $a2, 1 #we are writing one character at a time
syscall
addi $a1, $a1, 4 #goes to next
beq $t8, $t7, closethefile2
addi $t7, $t7, 1
j specialconditionyay

replacewithnhere2:
li $t2, 10
sw $t2, 0($a1)
li $v0, 15
li $a2, 1 #we are writing one character at a time
syscall
li $t4, 0
addi $t5, $t5, 1 
addi $a1, $a1, 4 #moves it to next
j checkerbefore

closethefile2:
li $t2, 10
sw $t2, 0($a1)
li $v0, 15
li $a2, 1 #we are writing one character at a time
syscall
li $v0, 16
move $a0,$t0 #closes the file descriptor
syscall
j finalwrited

finalwrited:
jr $ra

.globl rotate_clkws_90
rotate_clkws_90:
#opens the thing
#replacing a1 with a0

li $v0, 13 #to open the file
move $t1, $a0 #moving for temporary the file descriptor
move $a0, $a1
li $a1, 1 #to open the file in write mode
li $a2, 0 #ignored and is 0
syscall
move $t0, $v0 #to save the file descriptor
move $a1, $t1 #moves back the input buffer basically

firsttwocharacters:
#rotating the rows and columns
lw $t3, 4($a1)
move $t9, $t3
lw $t4, 0($a1)
move $t8, $t4
addi $t3, $t3, 48 #making it into ascii to call it
sw $t3, 0($a1)
li $v0, 15
move $a0, $t0
move $a1, $t1 #moves back the input buffer basically
li $a2, 1 #we are writing one character at a time
syscall
li $t3, 10
sw $t3, 0($a1)
li $v0, 15
#move $a0, $t0
li $a2, 1 #we are writing one character at a time
syscall
addi $a1, $a1, 4
addi $t4, $t4, 48 #making it into ascii to call it
sw $t4, 0($a1)
li $v0, 15
li $a2, 1 #we are writing one character at a time
syscall
li $t4, 10
sw $t4, 0($a1)
li $v0, 15
li $a2, 1 #we are writing one character at a time
syscall
addi $a1, $a1, 4
j equationforbaseadress

equationforbaseadress:
#t8 is the # of rows (2)
#t9 is the # of columns (3)
li $t0, 1
sub $t3, $t8, $t0
mult $t3, $t9 #(row-1) * columns
mflo $t3
li $t0, 4
mult $t3, $t0 #(row-1) * columns * 4, address of the bottom left corner element
mflo $t3 #12
li $t0, 4
mult $t9, $t0
mflo $t4 #gets the value of $t4 to 12 in this case
#addi $t2, $t8, -1
#div $t3, $t2
#mflo $t4 # 12 / row-1 = 12
li $t6, 0 #counter for rows
li $t7, 0 #counter for columns
j resetsthething

resetsthething:
add $a1, $a1, $t3
j loopthatstarts

resetsthething2:
li $t6, 0
li $t5, 10
sw $t5, 0($a1)
li $v0, 15
li $a2, 1 #we are writing one character at a time
syscall
addi $t7, $t7, 1 #adding to counters
beq $t7, $t9, closedafile
add $a1, $a1, $t3
addi $a1, $a1, 4
j loopthatstarts

loopthatstarts:
lw $t5, 0($a1)
addi $t5, $t5, 48
sw $t5, 0($a1)
li $v0, 15
li $a2, 1 #we are writing one character at a time
syscall
addi $t6, $t6, 1
beq $t6, $t8, resetsthething2
sub $a1, $a1, $t4
j loopthatstarts

closedafile:
li $v0, 16
move $a0,$t0 #closes the file descriptor
syscall
jr $ra

.globl rotate_clkws_180
rotate_clkws_180:
#opens the thing
li $v0, 13 #to open the file
move $t1, $a0 #moving for temporary the file descriptor
move $a0, $a1
li $a1, 1 #to open the file in write mode
li $a2, 0 #ignored and is 0
syscall
move $t0, $v0 #to save the file descriptor
move $a1, $t1 #moves back the input buffer basically

firsttwocharactersoneeighty:
lw $t3, 0($a1)
move $t8, $t3 #number of rows
lw $t4, 4($a1)
move $t9, $t4 #number of columns
addi $t3, $t3, 48 #making it into ascii to call it
sw $t3, 0($a1)
li $v0, 15
move $a0, $t0
move $a1, $t1 #moves back the input buffer basically
li $a2, 1 #we are writing one character at a time
syscall
li $t3, 10 #used to replace with \n to go to the next character
sw $t3, 0($a1)
li $v0, 15
#move $a0, $t0
li $a2, 1 #we are writing one character at a time
syscall
addi $a1, $a1, 4
lb $t4, 0($a1)
addi $t4, $t4, 48 #making it into ascii to call it
sw $t4, 0($a1) # stores
li $v0, 15
li $a2, 1 #we are writing one character at a time
syscall
li $t4, 10
sw $t4, 0($a1)
li $v0, 15
li $a2, 1 #we are writing one character at a time
syscall
addi $a1, $a1, 4
move $t2, $a1
j theloopthatdoestheoneeightyrotation

theloopthatdoestheoneeightyrotation:
#t8 is the # of rows (2)
#t9 is the # of columns (3)
li $t0, 4
mult $t8, $t9
mflo $t3
mult $t3, $t0
mflo $t3
sub $t3, $t3, $t0 #t3 now should have 20
#t3 is the memory address of the bottom right corner

mult $t9, $t0 #columns * 4 
mflo $t4 #gets the value of $t4 to 12 in this case
li $t6, 0 #counter for rows
li $t7, 0 #counter for columns
li $t0, 0
move $t1, $t4
j nextloopfortheeigthyrotation

#t2 has the reset now

nextloopfortheeigthyrotation:
add $a1, $a1, $t3
j loopthatstartstheeightyrotation

loopthatstartstheeightyrotation:
lw $t5, 0($a1)
addi $t5, $t5, 48
sw $t5, 0($a1)
li $v0, 15
li $a2, 1 #we are writing one character at a time
syscall
addi $t7, $t7, 1
beq $t7, $t9, resetsthethingforeighty
addi $a1, $a1, -4
j loopthatstartstheeightyrotation

resetsthethingforeighty:
li $t7, 0 #resets the counter for columns
li $t5, 10
sw $t5, 0($a1)
li $v0, 15
li $a2, 1 #we are writing one character at a time
syscall
addi $t6, $t6, 1 #adding to counters
beq $t6, $t8, closedafileforoneeighty
move $a1, $t2
add $a1, $a1, $t3

mult $t0, $t1
mflo $t5
add $t4, $t4, $t5
sub $a1, $a1, $t4 #goes to -1 row
sub $t4, $t4, $t5
addi $t0, $t0, 1

j loopthatstartstheeightyrotation

closedafileforoneeighty:
li $v0, 16
move $a0,$t0 #closes the file descriptor
syscall
jr $ra

.globl rotate_clkws_270
rotate_clkws_270:
#opens the thing
#replacing a1 with a0

li $v0, 13 #to open the file
move $t1, $a0 #moving for temporary the file descriptor
move $a0, $a1
li $a1, 1 #to open the file in write mode
li $a2, 0 #ignored and is 0
syscall
move $t0, $v0 #to save the file descriptor
move $a1, $t1 #moves back the input buffer basically

firsttwocharacters2:
#rotating the rows and columns
lw $t3, 4($a1)
move $t9, $t3
lw $t4, 0($a1)
move $t8, $t4
addi $t3, $t3, 48 #making it into ascii to call it
sw $t3, 0($a1)
li $v0, 15
move $a0, $t0
move $a1, $t1 #moves back the input buffer basically
li $a2, 1 #we are writing one character at a time
syscall
li $t3, 10
sw $t3, 0($a1)
li $v0, 15
#move $a0, $t0
li $a2, 1 #we are writing one character at a time
syscall
addi $a1, $a1, 4
addi $t4, $t4, 48 #making it into ascii to call it
sw $t4, 0($a1)
li $v0, 15
li $a2, 1 #we are writing one character at a time
syscall
li $t4, 10
sw $t4, 0($a1)
li $v0, 15
li $a2, 1 #we are writing one character at a time
syscall
addi $a1, $a1, 4
lb $t5, 0($a1)
move $t1, $a1
j equationforbaseadress2

equationforbaseadress2:
#t8 is the # of rows (2)
#t9 is the # of columns (3)
li $t0, 4
mult $t9, $t0
mflo $t3 #12
sub $t3, $t3, $t0 #8 (base address)
#t3 is the memory address of the top right corner
mult $t9, $t0 #columns * 4 
mflo $t4 #gets the value of $t4 to 12 in this case
li $t6, 0 #counter for rows
li $t7, 0 #counter for columns
li $t0, 1
j nextloopfortwoseventyrotation

nextloopfortwoseventyrotation:
add $a1, $a1, $t3
j loopthatstartsthetwoseventyrotation

loopthatstartsthetwoseventyrotation:
lw $t5, 0($a1)
addi $t5, $t5, 48
sw $t5, 0($a1)
li $v0, 15
li $a2, 1 #we are writing one character at a time
syscall
addi $t6, $t6, 1
beq $t6, $t8, resetsthethingfortwoseventy
add $a1, $a1, $t4
j loopthatstartsthetwoseventyrotation

resetsthethingfortwoseventy:
li $t6, 0 #resets the counter for columns
li $t5, 10
sw $t5, 0($a1)
li $v0, 15
li $a2, 1 #we are writing one character at a time
syscall
addi $t7, $t7, 1 #adding to counters
beq $t7, $t9, closedafilefortwoseventy
move $a1, $t1
add $a1, $a1, $t3

li $t5, 4
mult $t0, $t5
mflo $t5
sub $a1, $a1, $t5
addi $t0, $t0, 1
j loopthatstartsthetwoseventyrotation

closedafilefortwoseventy:
li $v0, 16
move $a0,$t0 #closes the file descriptor
syscall
jr $ra

.globl mirror
mirror:
#opens the thing
li $v0, 13 #to open the file
move $t1, $a0 #moving for temporary the file descriptor
move $a0, $a1
li $a1, 1 #to open the file in write mode
li $a2, 0 #ignored and is 0
syscall
move $t0, $v0 #to save the file descriptor
move $a1, $t1 #moves back the input buffer basically

firsttwocharofmirror:
lw $t3, 0($a1)
move $t8, $t3 #number of rows
lw $t4, 4($a1)
move $t9, $t4 #number of columns
addi $t3, $t3, 48 #making it into ascii to call it
sw $t3, 0($a1)
li $v0, 15
move $a0, $t0
move $a1, $t1 #moves back the input buffer basically
li $a2, 1 #we are writing one character at a time
syscall
li $t3, 10 #used to replace with \n to go to the next character
sw $t3, 0($a1)
li $v0, 15
#move $a0, $t0
li $a2, 1 #we are writing one character at a time
syscall
addi $a1, $a1, 4
lb $t4, 0($a1)
addi $t4, $t4, 48 #making it into ascii to call it
sw $t4, 0($a1) # stores
li $v0, 15
li $a2, 1 #we are writing one character at a time
syscall
li $t4, 10
sw $t4, 0($a1)
li $v0, 15
li $a2, 1 #we are writing one character at a time
syscall
addi $a1, $a1, 4
move $t2, $a1 # stores the original address
j equationforbaseadress3

equationforbaseadress3:
#t8 is the # of rows (2)
#t9 is the # of columns (3)
li $t0, 4
mult $t9, $t0
mflo $t3 # 3 * 4 = 12
sub $t3, $t3, $t0 # 12 - 4 = 8 is the base address we always refer too

#t3 is the memory address of the top right corner
mult $t9, $t0 #columns * 4 
mflo $t4 #gets the value of $t4 to 12 in this case
li $t6, 0 #counter for rows
li $t7, 0 #counter for columns
li $t0, 0
move $t1, $t4
j daloopforthemirrorstartsbefore

daloopforthemirrorstartsbefore:
add $a1, $a1, $t3
j daloopforthemirrorstartshere

daloopforthemirrorstartshere:
lw $t5, 0($a1)
addi $t5, $t5, 48
sw $t5, 0($a1)
li $v0, 15
li $a2, 1 #we are writing one character at a time
syscall
addi $t7, $t7, 1
beq $t7, $t9, resetsthethingfordamirror
addi $a1, $a1, -4
j daloopforthemirrorstartshere

resetsthethingfordamirror:
li $t7, 0 #resets the counter for columns
li $t5, 10
sw $t5, 0($a1)
li $v0, 15
li $a2, 1 #we are writing one character at a time
syscall
addi $t6, $t6, 1 #adding to counters
beq $t6, $t8, closedafilefortwoseventy
move $a1, $t2
add $a1, $a1, $t3

mult $t0, $t1
mflo $t5
add $t4, $t4, $t5
add $a1, $a1, $t4 #goes to +1 row
sub $t4, $t4, $t5
addi $t0, $t0, 1
j daloopforthemirrorstartshere


closedafileformirror:
li $v0, 16
move $a0,$t0 #closes the file descriptor
syscall
jr $ra
 jr $ra

.globl duplicate
duplicate:
lb $t0, 0($a0)
move $t9, $t0 #making $t9 the number of rows
addi $a0, $a0, 4
lb $t0, 0($a0)
move $t8, $t0 #making $t8 the number of columns
addi $a0, $a0, 4 #going to next index of buffer

li $t5, 100

li $t0, 0 #big counter for the whole thing
j counterssettingitup

counterssettingitup:
li $t7, 0 #counter for number of columns
li $t6, 1 #counter for number of rows
li $t1, 0 #your shifting the first row here
li $t3, 0#shifting second row here initially
j loopthatcalculatesdecimal

#gets the first one 10010
loopthatcalculatesdecimal:
sll $t1, $t1, 1 #shifting by 1
lb $t2, 0($a0)
add $t1, $t1, $t2
addi $t7, $t7, 1
addi $a0, $a0, 4 #moving to next buffer
beq $t7, $t8, resetacounterlol #if the counter = number of columns, go to exittheloop
j loopthatcalculatesdecimal

#gets the next one 01100
#resets counter
resetacounterlol:
li $t7, 0 # set a counter to 0
move $t4, $a0 #the next address kinda kewl
j getsthenextoneyes

#gets 111
getsthenextoneyes:
sll $t3, $t3, 1 #shifting by 1
lb $t2, 0($a0) #t2 is the 2nd address
add $t3, $t3, $t2
addi $t7, $t7, 1
addi $a0, $a0, 4 #moving to next buffer
beq $t7, $t8, comparetherowsnow #if the counter = number of columns, go to exittheloop
j getsthenextoneyes


comparetherowsnow:
addi $t6, $t6, 1
j comparetherowsnow2

continuedcompare:
beq $t6, $t9, nextiterationsyay
li $t7, 0
li $t3, 0
j getsthenextoneyes

comparetherowsnow2:
beq $t1, $t3, dontgoyet
li $t7, 0
li $t3, 0
j continuedcompare

dontgoyet:
add $t6, $t6, $t0
blt $t6, $t5, okletsdoit
sub $t6, $t6, $t0
li $t7, 0
li $t3, 0
j continuedcompare 

okletsdoit:
move $t5, $t6
j continuedcompare

#goes to the next index in $t1
nextiterationsyay:
addi $t0, $t0, 1
beq $t0, $t9, ifnoduplicaterows #if the big loop is = to 9 then
j loopneeded

loopneeded:
move $a0, $t4 #resets to the good address :)
j counterssettingitup

ifnoduplicaterows:
li $t2, 100
beq $t5, $t2, ifnoduplicaterowsforreal
move $v1, $t5 # if duplicate
li $v0, 1
jr $ra
 
 ifnoduplicaterowsforreal:
 li $v0, -1
 li $v1, 0
 jr $ra