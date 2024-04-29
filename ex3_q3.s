# XOR to invert, 0xFF or 0xFFFF FFFF
.text
.global main

main:

checkButtonPressed:
        lw      $4, 0x73001($0)
        beqz    $4, 0
        j       checkButtonPressed

# Loading the values of the switches in
andi    $1, $4, 0x01
andi    $2, $4, 0x02
andi    $3, $4, 0x04

# Get switch value
lw      $4, 0x73000

beqz    $1, buttonTwoNotPressed
# Do nothing
j displayRegisters

buttonOneNotPressed:
beqz    $2, buttonThreeNotPressed

# Invert the switch value
xori    $4, $4, 0xFFFF

j displayRegisters

buttonTwoNotPressed:
beqz    $3, displayRegisters
j displayRegisters

# Exit the program
jr $ra

displayRegisters:

remi    $5, $4, 4
bnez    $5, main

addi    $5, $5, 0xFFFFFFFF
sw      $5, 0x7300A($0)

j       main


