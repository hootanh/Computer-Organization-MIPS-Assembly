#                                           ICS 51, Lab #1
# 
#                                          IMPORTATNT NOTES:
# 
#                       Write your assembly code only in the marked blocks.
# 
#                       DO NOT change anything outside the marked blocks.
# 
#                      Remember to fill in your name, student ID in the designated sections.
# 
#
j main
###############################################################
#                           Data Section
.data
# 
# Fill in your name, student ID in the designated sections.
# 
student_name: .asciiz "Hootan Hosseinzadeganbushehri"
student_id: .asciiz "****"

new_line: .asciiz "\n"
space: .asciiz " "
double_range_lbl: .asciiz "\nDouble range (Decimal Values) \nExpected output:\n1200 -690 104\nObtained output:\n"
swap_bits_lbl: .asciiz "\nSwap bits (Hexadecimal Values)\nExpected output:\n75757575 FD5775DF 064B9A83\nObtained output:\n"
count_bits_lbl: .asciiz "\nCount bits \nExpected output:\n20 24 13\nObtained output:\n"

swap_bits_test_data:  .word 0xBABABABA, 0xFEABBAEF, 0x09876543
swap_bits_expected_data:  .word 0x75757575, 0xFD5775DF, 0x064B9A83

double_range_test_data: .word 945, -345, 0, -3, 55
double_range_expected_data: .word 1200, -690, 104

hex_digits: .byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'

###############################################################
#                           Text Section
.text
# Utility function to print hexadecimal numbers
print_hex:
move $t0, $a0
li $t1, 8 # digits
lui $t2, 0xf000 # mask
mask_and_print:
# print last hex digit
and $t4, $t0, $t2 
srl $t4, $t4, 28
la    $t3, hex_digits  
add   $t3, $t3, $t4 
lb    $a0, 0($t3)            
li    $v0, 11                
syscall 
# shift 4 times
sll $t0, $t0, 4
addi $t1, $t1, -1
bgtz $t1, mask_and_print
exit:
jr $ra
###############################################################
###############################################################
###############################################################
#                            PART 1 (Count Bits)
# 
# You are given an 32-bits integer stored in $t0. Count the number of 1's
#in the given number. For example: 1111 0000 should return 4
count_bits:
move $t0, $a0 
############################## Part 1: your code begins here ###

	move $t3, $t0
	li $t0, 0
	li $t2, 0
	
main_loop:

	beq $t2, 32, loop_exit
	
	andi $t4, $t3, 1 
	beq $t4, $0, shift_0
		
	addi $t0, $t0, 1
	
shift_0:
	srl $t3, $t3, 1
	addi $t2, $t2, 1
	
	j main_loop

loop_exit:

############################## Part 1: your code ends here ###
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
#                            PART 2 (Swap Bits)
# 
# You are given an 32-bits integer stored in $t0. You need swap the bits
# at odd and even positions. i.e. b31 <-> b30, b29 <-> b28, ... , b1 <-> b0
# The result must be stored inside $t0 as well.
swap_bits:
move $t0, $a0 
############################## Part 2: your code begins here ###

	sll $t1, $t0, 1
 	srl $t2, $t0, 1
 	li $t3, 0xAAAAAAAA
 	li $t4, 0x55555555
	and $t1, $t1, $t3
 	and $t2, $t2, $t4
 	or $t0, $t1, $t2
 	
############################## Part 2: your code ends here ###
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
#                           PART 3
# 
# You are given three integers. You need to find the smallest 
# one and the largest one and multiply their sum by two and return it.
# 
# Implementation details:
# The three integers are stored in registers $t0, $t1, and $t2. You 
# need to store the answer into register $t0. It will be returned by the
# function to the caller.

double_range:
move $t0, $a0
move $t1, $a1
move $t2, $a2
############################### Part 3: your code begins here ##

	bgt $t0, $t1, elif1
	bgt $t0, $t2, elif2
	move $t3, $t0
	j max    

max:
	bgt $t1, $t2, final
	move $t4, $t2
	j main_exit
	
final:
	move $t4, $t1
	j main_exit

elif1:
	bgt $t0, $t2  elif3
	j elif2
	
elif2:
	bgt $t1, $t2, elif4
	move $t4, $t2
	move $t3, $t1
	j main_exit
	
elif3:
	move $t4, $t0    
	j elif5

elif4:
	move $t4, $t1
	move $t3, $t2 
	j main_exit

elif5:
	bgt $t1, $t2, min
	move $t3, $t1
	j main_exit
	
min:
	move $t3, $t2
	j main_exit
	
main_exit:
	add $t5, $t3, $t4
	mul $t0, $t5, 2
		      
############################### Part 3: your code ends here  ##
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
#                          Main Function 
.globl main
main:

li $v0, 4
la $a0, student_name
syscall
la $a0, new_line
syscall  
la $a0, student_id
syscall 
la $a0, new_line
syscall
la $a0, count_bits_lbl
syscall

# Testing part 2
li $s0, 3 # num of test cases
li $s1, 0
la $s2, swap_bits_test_data

test_p1:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal count_bits

move $a0, $v0        # $integer to print
li $v0, 1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p1

li $v0, 4
la $a0, new_line
syscall
la $a0, swap_bits_lbl
syscall

# Testing part 2
li $s0, 3 # num of test cases
li $s1, 0
la $s2, swap_bits_test_data

test_p2:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal swap_bits

move $a0, $v0
jal print_hex
li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p2

li $v0, 4
la $a0, new_line
syscall
la $a0, double_range_lbl
syscall


# Testing part 3
li $s0, 3 # num of test cases
li $s1, 0
la $s2, double_range_test_data

test_p3:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
lw $a1, 4($s4)
lw $a2, 8($s4)
jal double_range

move $a0, $v0        # $integer to print
li $v0, 1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p3

_end:
# end program
li $v0, 10
syscall

