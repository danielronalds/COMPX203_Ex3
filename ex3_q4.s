.text
.global main

main:
        jal     serialJob
        jal     parallelJob
        j       main

serialJob:
        subui   $sp, $sp, 4                 # Backing up the used registers to the stack
        sw      $2, 0($sp)
        sw      $3, 1($sp)
        sw      $4, 2($sp)
        sw      $5, 3($sp)

        # Loading the sent letter
        checkReceiveReady:
                lw      $1, 0x70003($0)
                andi    $1, $1, 0x1
                bnez    $1, characterRecieved
                jr      $ra
        
        characterRecieved:
        lw      $2, 0x70001($0)
        
        # Filtering out non-lowercase characters
        sgei    $3, $2, 'a'
        slei    $4, $2, 'z'
        and     $5, $3, $4
        
        bnez    $5, checkTransmitReady
        # Overwriting with * if not lowercase
        addi    $2, $0, '*'
        
        # Sending it back
        checkTransmitReady:
                lw      $1, 0x70003($0)
                andi    $1, $1, 0x2
                benz    $1, transmitReady
                jr      $ra
        
        transmitReady:
        sw      $2, 0x70000($0)
        
        
        lw      $2, 0($sp)
        lw      $3, 1($sp)
        lw      $4, 2($sp)
        lw      $5, 3($sp)
        addui   $sp, $sp, 4
        jr      $ra

parallelJob:
        subui   $sp, $sp, 4                 # Backing up the used registers to the stack
        sw      $2, 0($sp)
        sw      $3, 1($sp)
        sw      $4, 2($sp)
        sw      $5, 3($sp)

        checkButtonPressed:
                lw      $4, 0x73001($0)
                bnez    $4, buttonPressed
                jr      $ra
        
        buttonPressed:
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

        lw      $2, 0($sp)
        lw      $3, 1($sp)
        lw      $4, 2($sp)
        lw      $5, 3($sp)
        addui   $sp, $sp, 4
        jr      $ra

