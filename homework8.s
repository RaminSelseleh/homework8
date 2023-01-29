/*
 * Ramin Selseleh
 * Homework8
 * theia
 */

 .global main
main:

    @ enter name
	MOV R0, #1
	MOV R2, #15
	MOV R7, #4
	LDR R1, =name
	SWI 0

   @ Prompt to enter a string of up to 40 characters
	MOV R0, #1
	LDR R2, =input
	LDR R1, =prompt
	SUB R2, R2, R1
	MOV R7, #4
	SWI 0

 @ Read character input
	MOV R0, #0
	LDR R1, =input
	MOV R2, #41
	MOV R7, #3
	SWI 0


/*
    * Register usage
    * R3 = byte pointer/counter for loop1
    * R4 = Address of input
    * R6 = Address of output1 data area
    */

    MOV R3, #0
	LDR R4, =input		@ Get 1st character location
	LDR R6, =output

    @ start of loop
loop:
    @ load r0 with input and buffer
    LDRB R0, [R4, R3] 

    @ if it hits enter write and move on to next program
    CMP R0, #10
    BEQ write

    @  if [char] < 123 in ascii go to check if its lower case
    CMP R0, #123
    BLT lowCheck

    @ if [char] <= 127 ascii store then get next character
    CMP r0, #127
    BLE skip

    @ check to see whether it needs to be lower or upper case
lowCheck:
    @ if [char] < #96 go to next check 
    CMP r0, #96
    BLT check

    @ if not less then 96, check, if [char] <=122
    CMP r0, #122
    @ then it is lower case so change to upper
    BLE toUpper


    @ if [char] < #91, then could be upper case
check:
    CMP R0, #91
    blt upperCheck

    @ if <= #96, then it is control char so save and get next
    CMP R0, #96
    ble skip

upperCheck:
    @ if < #65 save and get next
    CMP R0, #65
    blt skip

    @ if [char] <= #90, then change to lower case
    CMP R0, #90
    ble toLower

    @ change lower to upper then store
toUpper:
	SUB	R0, #('a'-'A')
    STRB R0, [R6, R3]
    B next

    @ change upper to lower then store
toLower:
    ADD R0, R0, #32
    STRB R0, [R6, R3]
    B next

    @ gets next char
next:
    ADD R3, R3, #1
    B loop


    @ stores and gets next char
skip:
    STRB R0, [R6, R3]
    ADD R3, R3, #1
    B loop

write:
    @ display the new output
	MOV R0, #1
	LDR R1, =output
	MOV R2, #41
	MOV R7, #4
    SWI 0
	




/*
    * Register usage
    * R3 = counter 1 for input
    * R8 = counter 2 for output
    * R4 = Address of input
    * R10 = Address of output2 
    */

	LDR R4, =input         
    MOV R8, #0             @ buffer or counter fo output
	LDR R10, =output2


@ getting length of char
size:
    @ load r9 with input and buffer
    LDRB R9, [R4, R3]

    @ check for null character / if its end of string
	CMP R9, #0
	BEQ swap

    @ else get next char
	ADD R3, R3, #1
	b size

    @ where we reverse the string
swap:
    @ look through char backwards
	SUB R3, R3, #1

    @load data into r9
	LDRB R9, [R4, R3]

    @ store each char in output string
	STRB R9, [R10, R8]

    @ if no more char, then print the string, else get next char until we hit end of string or null
	CMP R3, #0
	BEQ print
	ADD R8, R8, #1
	b swap


print:
    @ printing the reverse string
	ADD R8, R8, #1
	LDRB R9, [R4, R8]
    MOV R0, #1
    MOV R2, #41
    LDR R1, =output2
    MOV R7, #4
    SWI 0




exit: @ exit syscall
    @ space at the end
	MOV R0, #1
	MOV R2, #1
	MOV R7, #4
	LDR R1, =spac
	SWI 0
    MOV R7, #1
    SWI 0

.data
name:
.ascii "Ramin Selseleh\n"
prompt:
	.ascii "Enter 1 to 40 characters: "
input:
.space 41
output:
.space 41
output2:
.space 41
spac:
.ascii "\n"




