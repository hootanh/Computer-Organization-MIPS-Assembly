# Hootan Hosseinzadeganbushehri

.data

.text
main:
# Calculating the sum of range [1, 6]

# range
li $t4, 6
# sum
move $t5, $0

inc:
add $t5, $t5, $t4
addi $t4, $t4, -1
bgt $t4, 0, inc  # repeat if $t4 is bigger than 0

# end program
li $v0, 1
move $a0, $t5
syscall
#jr $ra

