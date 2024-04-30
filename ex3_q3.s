# XOR to invert, 0xFF or 0xFFFF FFFF
.text
.global main

main:
        checkButtonPressed:
                lw      $4, 0x73001($0)
                beqz    $4, checkButtonPressed
        
        # Loading the values of the Buttons in
        andi    $1, $4, 0x01
        andi    $2, $4, 0x02
        andi    $3, $4, 0x04
        
        # Get switch value
        lw      $4, 0x73000($0)
        
        # If button one is not pressed, check button two
        beqz    $1, buttonOneNotPressed
        # Do nothing
        j displayRegisters
        
        buttonOneNotPressed:
        # If button two is not pressed, check button two
        beqz    $2, buttonTwoNotPressed
        
        # Invert the switch value
        xori    $4, $4, 0xFFFF
        j displayRegisters
        
        buttonTwoNotPressed:
        # If button three is not pressed, Just display the registers
        beqz    $3, displayRegisters
        # Exit the program
        jr $ra
        
        displayRegisters:

        # Checking if the value is a multiple of 4
        remi    $5, $4, 4
        bnez    $5, notMultiple
        
        # lighting up the lower lights if multiple of 4
        addi    $5, $0, 0x0000FFFF
        sw      $5, 0x7300A($0)
        j       writeSsd

        notMultiple:
        addi    $5, $0, 0x0
        sw      $5, 0x7300A($0)

        writeSsd:
        addi    $5, $0, 4
        writeSsdLoop:
                sw      $4, 0x73005($5)
                divi    $4, $4, 16
                subi    $5, $5, 1
                bnez    $5, writeSsdLoop
        j       main
