############## Rishith Kyatham ##############

.text:
.globl create_person
create_person:
move $t9, $a0
lw $t0, 16($a0) #loads in current number of nodes  0
lw $t1, 8($a0) #loads the size of each node 12
lw $t3, 0($a0) #total number of nodes 5
li $t5, 0
li $t7, 0 # a counter
bge $t0, $t5, Allocatespacebeforecheck
j Nofreenodesavailable

Allocatespacebeforecheck:
blt $t0, $t3, Allocatespace #2nd check for whether its between the valid  or not
j Nofreenodesavailable

Allocatespace:
addi $a0,$a0, 36
mult $t0, $t1 #size of each node * current # of nodes
mflo $t2 #recieve here #0
add $a0, $a0, $t2
move $t8, $a0
j PlaceZeroesinnow

PlaceZeroesinnow:
li $t6, 0
sb $t6, 0($a0)
addi $t7, $t7, 1 #move counter by 1
beq $t1, $t7, Addressofanode #going until size of node = counter
j PlaceZeroesinnow

Addressofanode:
addi $t0, $t0, 1 #adds 1 to current # of nodes each iteration
sb $t0, 16($t9)
move $v0, $t8 #returns the node address
jr $ra

Nofreenodesavailable:
li $v0, -1
 jr $ra

.globl is_person_exists
is_person_exists:
addi $sp, $sp, -4
sw $a0, 0($sp)
lw $t0, 0($a0) #points to starting of network
lw $t2, 16($a0) #loads current # of nodes
lw $t3, 8($a0) #size of node
addi $a0, $a0, 36 #adds 36 to get to the node array of bytes
li $t5, 0 # setting up a counter
li $t1, 0 # a counter
j multiplymethod

multiplymethod:
mult $t3, $t2 #size of each node * current # of nodes
mflo $t4 #you get here the number of bytes you iterate through
j Ispersonsloop

Ispersonsloop:
beq $a1, $a0, check #if the addresses are equal then it checks
add $a0, $a0, $t3   #or else it adds the size of node to it to go to next node
add $t5, $t5, $t3 #adding counter with size of node too
beq $t4, $t5, Doesnotexist #does not exist condition
j Ispersonsloop	#go until this condition

check:
move $t6, $a0 #move for temp test
move $t7, $a1 #move for temp test
lb $t8, 0($t6)
lb $t9, 0($t7)
addi $t1, $t1, 1
beq $t1, $t3, Doesexist
beq $t8, $t9, check
j loopbeforeback

loopbeforeback:
add $a0, $a0, $t3
add $t5, $t5, $t3
j Ispersonsloop

Doesnotexist:  #first choice
lw $a0, 0($sp)
addi $sp, $sp, 4
li $v0, 0
jr $ra

Doesexist: #second choice
lw $a0, 0($sp)
addi $sp, $sp, 4
li $v0, 1
jr $ra

.globl is_person_name_exists
is_person_name_exists:
addi $sp, $sp, -8
sw $a0, 0($sp)
sw $a1, 4($sp)
lb $t3, 16($a0) #current # of nodes
lb $t2, 8($a0) #size of node
addi $a0, $a0, 36 #adds 36 to get to the node array of bytes
move $t5, $a1 #moves intitial address at starting buffer of string into $t5
move $t8, $a0
li $t6, 0 #counter
li $t7, 0
j Personnameloop

Personnameloop:
lb $t0, 0($t8) 
lb $t1, 0($a1) 
beq $t0, $t1, beforechecking
#if it doesn't find, below what to do
addi $t8, $t8, 1 #address by 1
addi $t6, $t6, 1 #increase counter by 1
beq $t6, $t2, addingtoaddress 
j Personnameloop

addingtoaddress:
add $a0, $a0, $t2 #adds size to address
move $t8, $a0
li $t6, 0 #reset the counter
move $a1, $t5
addi $t7, $t7, 1
beq $t3, $t7, Doesnotexistpersonname
j Personnameloop

beforechecking:
move $t9, $t8
j checkthis

checkthis:
lb $t0, 0($t8)
lb $t1, 0($a1)
bne, $t0, $t1, addingtoaddress
beqz $t1, Doesexistpersonname
addi $t8, $t8, 1
addi $a1, $a1, 1
j checkthis

Doesexistpersonname:  #first choice
li $v0, 1
move $v1, $t9
lw $a0, 0($sp)
lw $a1, 4($sp)
addi $sp, $sp, 8
jr $ra

Doesnotexistpersonname:  #second choice
li $v0, 0
lw $a0, 0($sp)
lw $a1, 4($sp)
addi $sp, $sp, 8
jr $ra

.globl add_person_property
add_person_property:
#a0 is Network
#a1 is person (node)
#a2 is prop_name(char)
#a3 is prop_val (char)
addi $sp, $sp, -8 #opens the stack
sw $ra, 4($sp) # stores my return value into the stack
sw $a3, 0($sp) 

#violation 1 check
checkconditionone:
move $t2, $a0 #moves to intial address back to normal in $t2
addi $a0, $a0, 24
lb $t0, 0($a0) #gets NAME
lb $t1, 0($a2)
beq $t0, $t1, Nextcharactercheck
j Violationoneviolated

Nextcharactercheck:
addi $a0, $a0, 1 #goes to check 'A' with 'A'
lb $t0, 0($a0) #gets 'A'
lb $t1, 1($a2)
beq $t0, $t1, Nextcharactercheck2
j Violationoneviolated

Nextcharactercheck2:
addi $a0, $a0, 1 #goes to check 'M' with 'M'
lb $t0, 0($a0) #gets 'M'
lb $t1, 2($a2)
beq $t0, $t1, Nextcharactercheck3
j Violationoneviolated

Nextcharactercheck3:
addi $a0, $a0, 1
lb $t0, 0($a0)#gets 'E'
lb $t1, 3($a2)
beq $t0, $t1, beforeGoestochecksecondviolation
j Violationoneviolated

beforeGoestochecksecondviolation:
move $a0, $t2 #move back a0 to intial
j Goestochecksecondviolation

Goestochecksecondviolation:
addi $sp, $sp, -8
sw $a1, 0($sp)
sw $ra, 4($sp)
jal is_person_exists #result is in $v0
lw $a1, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $t3, $v0 #result is in $t3 0 or not
li $t1, 0
beq $t3, $t1, Violationtwoviolated #if its 0 then, it fails
li $t1, 1
beq $t3, $t1, CheckforViolation3
#ends here never reaches more

#t2 still has the intial $a0 so keep that
#a0 has been reset at this point
#can use registers 
#Violation 3 check
CheckforViolation3:
lb $t0, 8($a0) #gets size of node
li $t3, 0 # a counter
j looptofindcharactersinpropval

looptofindcharactersinpropval:
lb $t1, 0($a3) #prop_val String
beqz $t1, checksthisconditionhere #goes until String null terimates
addi $t3, $t3, 1 #adds to counter #would be the number of characters in prop_val
addi $a3, $a3, 1 #goes to next character
j looptofindcharactersinpropval

checksthisconditionhere:
blt $t3, $t0, CheckforViolationfour #if no. of characters < Network Size of Node, then no violation
j Violationthreeviolated #otherwise violation occurs 

CheckforViolationfour:
lw $a3, 0($sp)
addi $sp, $sp, 4
addi $sp, $sp, -8
sw $a1, 0($sp)
sw $ra, 4($sp)
move $a1, $a3
jal is_person_name_exists
lw $a1, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $t5, $v0
li $t6, 0
beq $t5, $t6, beforetheloop
li $t6, 1
beq $t5, $t6, Violationfourviolated
#never reaches here

beforetheloop:
move $t0, $a3
move $t1, $a1
j Loopthataddson

Loopthataddson:
#can use t0 t1 t2 t3
lb $t2, 0($t0)
sb $t2, 0($t1)
addi $t0, $t0, 1
addi $t1, $t1, 1
beqz $t2, Addedsuccesfully
j Loopthataddson
Addedsuccesfully:

#storing a3 into a1
lw $ra, 0($sp) #returns the address back to this method
addi $sp, $sp, 4 #opens the stack
li $v0, 1
jr $ra

Violationoneviolated:
#lw $ra, 0($sp) #returns the address back to this method
addi $sp, $sp, 4 #opens the stack
li $v0, 0
jr $ra

Violationtwoviolated:
#lw $ra, 0($sp) #returns the address back to this method
addi $sp, $sp, 4 #opens the stack
li $v0, -1
jr $ra

Violationthreeviolated:
#lw $ra, 0($sp) #returns the address back to this method
addi $sp, $sp, 4 #opens the stack
li $v0, -2
jr $ra

Violationfourviolated:
#lw $ra, 0($sp) #returns the address back to this method
addi $sp, $sp, 4 #opens the stack
li $v0, -3
jr $ra
 
.globl get_person
get_person:
addi $sp, $sp, -4
sw $ra, 0($sp)
jal is_person_name_exists
move $t5 , $v0
li $t4, 0
beq $t5, $t4, notexists
li $t4, 1 
beq $t5, $t4, exists
#does not reach here

exists:
move $v0, $v1
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

notexists:
li $v0, 0
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

.globl is_relation_exists
is_relation_exists:
lb $t0, 20($a0)
li $t2, 0
beq $t0, $t2, RelationDoesNotexistforedges #conditio
lb $t0, 4($a0) #current # of edgesn
lb $t1, 12($a0) #size of each edge
lb $t8, 0($a0) #total # of nodes
lb $t9, 8($a0)  #size of each node
j multiplytofindhowmuchtoadd

multiplytofindhowmuchtoadd: 
mult $t8, $t9
mflo $t8
j ContinueCodenow

ContinueCodenow:
add $a0, $a0, $t8
addi $a0, $a0, 36
li $t5, 0 #counter
li $t6, 0 #counter
j multiplythis

multiplythis:
mult $t0, $t1
mflo $t2 #receives the value of $t0 * $t1
move $t3 ,$a0 #saves the start of $a0 in set of edges
j StartscheckingforPerson1

StartscheckingforPerson1:
lw $t4, 0($t3)
beq $t4, $a1, ChecksNode1 #checks here
beq $t4, $a2, ChecksNode2 #checks here

addi $t3, $t3, 4
addi $t6, $t6, 4
beq $t6, $t1, Aftereachiteration #each iteration here
j StartscheckingforPerson1

Aftereachiteration:
move $a0, $t3 #ifnotequal
li $t6, 0
add $t5, $t5, $t1 #adds size of each iteration
beq $t5, $t2, RelationDoesNotexistforedges #does not exist if it gets here
j StartscheckingforPerson1

ChecksNode1:
lw $t7, 4($t3)
beq $t7, $a2, Relationexistsforedges
move $t3,$a0
add $t3, $t3, $t1
j Aftereachiteration

ChecksNode2:
lw $t7, 4($t3)
beq $t7, $a1, Relationexistsforedges
move $t3,$a0
add $t3, $t3, $t1
j Aftereachiteration

Relationexistsforedges:
li $v0, 1
jr $ra
  
RelationDoesNotexistforedges:
li $v0, 0
jr $ra
  
.globl add_relation
add_relation:
#you are taking $a0 Network
#you are taking $a1 as Node1
#you are taking $a2 as Node2
addi $sp, $sp, -4
sw $ra, 0($sp)
j CheckConditionOne


CheckConditionOne:
addi $sp, $sp, -8
sw $a0, 0($sp)
sw $a1, 4($sp)
jal is_person_exists #calls to check the first person is in or not
lw $a0, 0($sp)
lw $a1, 4($sp)
addi $sp, $sp, 8
move $t0 , $v0 
li $t1, 0
beq $t0, $t1, ConditionOneFailed


addi $sp, $sp, -8
sw $a0, 0($sp)
sw $a1, 4($sp)
move $a1, $a2
jal is_person_exists #calls to check the second person is in or not
lw $a0, 0($sp)
lw $a1, 4($sp)
addi $sp, $sp, 8
move $t0, $v0
li $t1, 0
beq $t0, $t1, ConditionOneFailed
j CheckConditionTwo

CheckConditionTwo:
lb $t0, 20($a0)
lb $t1, 4($a0)
bge $t0, $t1, ConditionTwoFailed    #if current # of edges >= #total # of edges
j CheckConditionThree

CheckConditionThree:
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
jal is_relation_exists
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
addi $sp, $sp, 12
move $t0, $v0
li $t1, 1
beq $t0, $t1, ConditionThreeFailed  #if relationship exists, then u get fail
j CheckConditionFour

CheckConditionFour:
beq $a1, $a2, ConditionFourFailed
j PassedConditions

PassedConditions:
lb $t0, 0($a0) #total # of nodes
lb $t1, 8($a0) #size of each node 
lb $t2, 12($a0) #size of each edge
lb $t3, 20($a0) #current # of edges
j MultiplyforaddingNodes

MultiplyforaddingNodes:
mult $t0, $t1
mflo $t0 #putting size * total # of nodes in $t0
j MultiplyforaddingToGetEdgePointer

MultiplyforaddingToGetEdgePointer:
mult $t2, $t3
mflo $t2 #putting size of each edge * current # of edges in this
move $t9, $a0 #don't touch the $t9 bc it has $a0
j Addingtogettothatspot

Addingtogettothatspot:
add $t9, $t9, $t0
add $t9, $t9, $t2 #gets you to the address of the first node you want too add
addi $t9, $t9, 36
sw $a1, 0($t9) #you store the first node into it
sw $a2, 4($t9) #you store the second node into it
li $t5, 0
sw $t5, 8($t9)
#add to counter 
move $t7,$a0
addi $t7, $t7, 20
lb $t8, 0($t7)
addi $t8, $t8, 1
sw $t8, 0($t7)

j EverythingpassedAndWorked

EverythingpassedAndWorked:
lw $ra, 0($sp)
addi $sp, $sp, 4
li $v0, 1
jr $ra

ConditionOneFailed:
lw $ra, 0($sp)
addi $sp, $sp, 4
li $v0, 0
jr $ra

ConditionTwoFailed:
lw $ra, 0($sp)
addi $sp, $sp, 4
li $v0, -1
jr $ra

ConditionThreeFailed:
lw $ra, 0($sp)
addi $sp, $sp, 4
li $v0, -2
jr $ra

ConditionFourFailed:
lw $ra, 0($sp)
addi $sp, $sp, 4
li $v0, -3
jr $ra

.globl add_relation_property
add_relation_property:
#Takes a network of a0,  node of $a1,  node of $a2, String node of prop_name 
addi $sp, $sp, -4
sw $ra, 0($sp)

addi $sp, $sp, -12
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
jal is_relation_exists #calls function to see if relationship exists or not
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
addi $sp, $sp, 12
move $t0, $v0
li $t1, 0
beq $t0, $t1, Condition1Failed #if condition 1 fails
j CheckforCondition2Fail

CheckforCondition2Fail:
move $t0, $a0 #moving so can iterate through
move $t1, $a3
addi $t0, $t0, 29 #adds 28 
j ChecknowThroughIterating

ChecknowThroughIterating:
lb $t2, 0($t0)
lb $t3, 0($t1)
beqz $t3, BeforeConditionPassed
bne $t2, $t3, Condition2Failed
addi $t0, $t0, 1
addi $t1, $t1, 1 
j ChecknowThroughIterating

#Function to get the address
BeforeConditionPassed:
lb $t0, 20($a0)
li $t2, 0
beq $t0, $t2, RelationDoesNotexistforedges2 #conditio
lb $t0, 4($a0) #current # of edgesn
lb $t1, 12($a0) #size of each edge
lb $t8, 0($a0) #total # of nodes
lb $t9, 8($a0)  #size of each node
j multiplytofindhowmuchtoadd2

multiplytofindhowmuchtoadd2: 
mult $t8, $t9
mflo $t8
j ContinueCodenow2

ContinueCodenow2:
add $a0, $a0, $t8
li $t5, 0 #counter
li $t6, 0 #counter
j multiplythis2

multiplythis2:
mult $t0, $t1
mflo $t2 #receives the value of $t0 * $t1
move $t3 ,$a0 #saves the start of $a0 in set of edges
j StartscheckingforPerson2

StartscheckingforPerson2:
lw $t4, 0($t3)
beq $t4, $a1, ChecksNode3 #checks here
beq $t4, $a2, ChecksNode4 #checks here

addi $t3, $t3, 4
addi $t6, $t6, 4
beq $t6, $t1, Aftereachiteration2 #each iteration here
j StartscheckingforPerson2

Aftereachiteration2:
move $a0, $t3 #ifnotequal
li $t6, 0
add $t5, $t5, $t1 #adds size of each iteration
beq $t5, $t2, RelationDoesNotexistforedges2 #does not exist if it gets here
j StartscheckingforPerson2

ChecksNode3:
lw $t7, 4($t3)
beq $t7, $a2, Relationexistsforedges2
move $t3,$a0
add $t3, $t3, $t1
j Aftereachiteration2

ChecksNode4:
lw $t7, 4($t3)
beq $t7, $a1, Relationexistsforedges2
move $t3,$a0
add $t3, $t3, $t1
j Aftereachiteration2

Relationexistsforedges2:
#t3 would be the address
addi $t3, $t3, 8
li $t5, 1
sw $t5, 0($t3)
j ConditionpassedSoGottaSetProperty

RelationDoesNotexistforedges2:
jr $ra
#will never reach here

#you will never get this because we know relationship exists

ConditionpassedSoGottaSetProperty:
lw $ra, 0($sp)
addi $sp, $sp, 4
li $v0, 1 
jr $ra

Condition1Failed:
lw $ra, 0($sp)
addi $sp, $sp, 4
li $v0, 0
jr $ra

Condition2Failed:
lw $ra, 0($sp)
addi $sp, $sp, 4
li $v0, -1
jr $ra

.globl is_friend_of_friend
is_friend_of_friend:
addi $sp, $sp, -12
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $ra, 8($sp)
j ChecksConditionOne


ChecksConditionOne:
addi $sp, $sp, -8
sw $a0, 0($sp)
sw $a1, 4($sp)
jal get_person #calls to check the first person is in or not
lw $a0, 0($sp)
lw $a1, 4($sp)
addi $sp, $sp, 8
move $s0 , $v0 #puts the address of node1 in here 
li $t1, 0
beq $s0, $t1, NeitherpersonName1NorPersonwithName2Exists

addi $sp, $sp, -8
sw $a0, 0($sp)
sw $a1, 4($sp)
move $a1, $a2
jal get_person #calls to check the second person is in or not
lw $a0, 0($sp)
lw $a1, 4($sp)
addi $sp, $sp, 8
move $s1, $v0 ##puts the address of node2 in here 
li $t1, 0
beq $s1, $t1, NeitherpersonName1NorPersonwithName2Exists
j CheckForfailsmore

CheckForfailsmore:
addi $sp, $sp, -48
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $t1, 12($sp)
sw $t2, 16($sp)
sw $t3, 20($sp)
sw $t4, 24($sp)
sw $t5, 28($sp)
sw $t6, 32($sp)
sw $t7, 36($sp)
sw $t8, 40($sp)
sw $t9, 44($sp)
move $a1, $s0 #1st arguement
move $a2, $s1 #passing the address of the common friend
jal FunctionthatsCalled #calls function to see if relationship exists or not
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
lw $t1, 12($sp)
lw $t2, 16($sp)
lw $t3, 20($sp)
lw $t4, 24($sp)
lw $t5, 28($sp)
lw $t6, 32($sp)
lw $t7, 36($sp)
lw $t8, 40($sp)
lw $t9, 44($sp)
addi $sp, $sp, 48

beqz $v0, MainFunction
j checkifitsFriends

checkifitsFriends:
lw $t0, 8($v1)
li $t1, 1
beq $t0, $t1, ApersonWithName1IsNotfriendOffriendOfapersonWithname2
j MainFunction

MainFunction:
#s0 and s1 has node1 addresss and node3 addresss
lb $t0, 20($a0) #current # of edges
lb $t1, 12($a0) #size of each edge
lb $t2, 0($a0) #total # of nodes
lb $t3, 8($a0)  #size of each node
j MultiplytofindhowmuchtoAdds

MultiplytofindhowmuchtoAdds: 
mult $t2, $t3
mflo $t2 #total # of nodes * size of each node
j MultiplytofindhowmuchtoAdds2

MultiplytofindhowmuchtoAdds2:
lb $t3, 4($a0) #total # of edges
mult $t3, $t1
mflo $t3 #total # edges * size of each edge

j StartsIteratingThroughLoop

StartsIteratingThroughLoop:
move $t4, $a0
addi $t4, $t4, 36
add $t4, $t4, $t2 #gets to the starting of the edge address
li $t5, 0 #a counter
j GoestoMainLoop

GoestoMainLoop:
lb $t6, 8($t4) #if the 3rd node is 0 then you go to the next one
beqz $t6, GotoNextEdge
lw $t6, 0($t4)
beq $t6, $s0, CheckthisNow #checking if node 1 us at that spot
lw $t6, 4($t4)
beq $t6, $s0, CheckthisNow2 #checking if node 1 us at that spot
j GotoNextEdge

GotoNextEdge:
add $t4, $t4, $t1 #adds the size of each edge
add $t5, $t5, $t1
beq $t5, $t3, ApersonWithName1IsNotfriendOffriendOfapersonWithname2#exit loop
j GoestoMainLoop

CheckthisNow:
lw $t6, 4($t4) #this would be the common friend
j FirstOneisEqual

CheckthisNow2:
lw $t6, 0($t4)#this would be the common friend
j SecondOneisEqual

#s0 is the address of node 1
#s1 is the address of node 2
FirstOneisEqual:
addi $sp, $sp, -48
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $t1, 12($sp)
sw $t2, 16($sp)
sw $t3, 20($sp)
sw $t4, 24($sp)
sw $t5, 28($sp)
sw $t6, 32($sp)
sw $t7, 36($sp)
sw $t8, 40($sp)
sw $t9, 44($sp)
move $a1, $t6 #1st arguement
move $a2, $s1 #passing the address of the common friend
jal FunctionthatsCalled #calls function to see if relationship exists or not
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
lw $t1, 12($sp)
lw $t2, 16($sp)
lw $t3, 20($sp)
lw $t4, 24($sp)
lw $t5, 28($sp)
lw $t6, 32($sp)
lw $t7, 36($sp)
lw $t8, 40($sp)
lw $t9, 44($sp)
addi $sp, $sp, 48

move $t5 ,$v0
move $t6, $v1
beqz $t5, GotoNextEdge
j IftheirfriendsOrBNot

SecondOneisEqual:
addi $sp, $sp, -48
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $t1, 12($sp)
sw $t2, 16($sp)
sw $t3, 20($sp)
sw $t4, 24($sp)
sw $t5, 28($sp)
sw $t6, 32($sp)
sw $t7, 36($sp)
sw $t8, 40($sp)
sw $t9, 44($sp)
move $a1, $t6 #2nd arguement
move $a2, $s1 #passing the address of the common friend
jal FunctionthatsCalled #calls function to see if relationship exists or not
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
lw $t1, 12($sp)
lw $t2, 16($sp)
lw $t3, 20($sp)
lw $t4, 24($sp)
lw $t5, 28($sp)
lw $t6, 32($sp)
lw $t7, 36($sp)
lw $t8, 40($sp)
lw $t9, 44($sp)
addi $sp, $sp, 48

move $t8 ,$v0
move $t6, $v1
beqz $t8, GotoNextEdge
j IftheirfriendsOrBNot

IftheirfriendsOrBNot:
lw $t7, 8($t6)
li $t9, 1
beq $t7, $t9, IfPersonWithName1IsAFriendoffriendOFpersonWithName2
j GoestoMainLoop

#-------------------------------
#-------------------------------
#-------------------------------
#the Function
#that is called
FunctionthatsCalled:
lb $t0, 20($a0)
li $t2, 0
beq $t0, $t2, RelationDoesNotexistforedgesy #conditio
lb $t0, 4($a0) #current # of edgesn
lb $t1, 12($a0) #size of each edge
lb $t8, 0($a0) #total # of nodes
lb $t9, 8($a0)  #size of each node
j multiplytofindhowmuchtoaddy

multiplytofindhowmuchtoaddy: 
mult $t8, $t9
mflo $t8
j ContinueCodenowy

ContinueCodenowy:
addi $a0, $a0, 36 #added
add $a0, $a0, $t8
li $t5, 0 #counter
li $t6, 0 #counter
j multiplythisy

multiplythisy:
mult $t0, $t1
mflo $t2 #receives the value of $t0 * $t1
move $t3 ,$a0 #saves the start of $a0 in set of edges
j StartscheckingforPerson1y

StartscheckingforPerson1y:
lw $t4, 0($t3)
beq $t4, $a1, ChecksNode1y #checks here
beq $t4, $a2, ChecksNode2y #checks here

addi $t3, $t3, 4
addi $t6, $t6, 4
beq $t6, $t1, Aftereachiterationy #each iteration here
j StartscheckingforPerson1y

Aftereachiterationy:
move $a0, $t3 #ifnotequal
li $t6, 0
add $t5, $t5, $t1 #adds size of each iteration
beq $t5, $t2, RelationDoesNotexistforedgesy #does not exist if it gets here
j StartscheckingforPerson1y

ChecksNode1y:
lw $t7, 4($t3)
beq $t7, $a2, Relationexistsforedgesy
move $t3,$a0
add $t3, $t3, $t1
j Aftereachiterationy

ChecksNode2y:
lw $t7, 4($t3)
beq $t7, $a1, Relationexistsforedgesy
move $t3,$a0
add $t3, $t3, $t1
j Aftereachiterationy

Relationexistsforedgesy:
li $v0, 1
move $v1, $t3
jr $ra
  
RelationDoesNotexistforedgesy:
li $v0, 0
jr $ra
#The Function ends here
#-------------------------------
#-------------------------------
#-------------------------------

NeitherpersonName1NorPersonwithName2Exists: #Conditon that fails
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
li $v0, -1
jr $ra

ApersonWithName1IsNotfriendOffriendOfapersonWithname2:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
li $v0, 0
jr $ra

IfPersonWithName1IsAFriendoffriendOFpersonWithName2:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
li $v0, 1
jr $ra
