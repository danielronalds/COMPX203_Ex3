.text
.global main

main:
        checkButtonPressed:
                lw      $4, 0x73001($0)        # Loading in the value of the buttons
                beqz    $4, checkButtonPressed # If it's zero then no buttons are pressed
        
        andi    $1, $4, 0x01                   # Get the value of button 0
        andi    $2, $4, 0x02                   # Get the value of button 1
        andi    $3, $4, 0x04                   # Get the value of button 2
        lw      $4, 0x73000($0)                # Get the value of the switches
        
        
        beqz    $1, buttonZeroNotPressed       # If button zero is not pressed, check button two
        j displayRegisters                     # If button zero is pressed, just display the registers
        
        buttonZeroNotPressed:
        beqz    $2, buttonOneNotPressed        # If button one is not pressed, check button two
        xori    $4, $4, 0xFFFF                 # If button one is pressed, invert the switches value
        j displayRegisters                     # Then display the registers
        
        buttonOneNotPressed:
        beqz    $3, displayRegisters           # If button two is pressed, Just display the registers
        jr $ra                                 # If button two is pressed, Exit gracefully
        
        displayRegisters:
        remi    $5, $4, 4                      # Checking if the value of the switches if a multiple of 4
        bnez    $5, notMultiple                # Set the lights to not lightup if not a multiple of 4
        addi    $5, $0, 0x0000FFFF             # lighting up the lower lights if multiple of 4
        sw      $5, 0x7300A($0)           
        j       writeSsd                       # Writing to the SSD

        notMultiple:
        addi    $5, $0, 0x0                    # Setting the lights to not lightup
        sw      $5, 0x7300A($0)

        writeSsd:                             
        addi    $5, $0, 4                      # Setting the SSD offset. Counting backwards as they're left to right
        writeSsdLoop:                          # Looping over each SSD to write to it
                sw      $4, 0x73005($5)        # Writing to the current SSD
                divi    $4, $4, 16             # Working in hex, so dividing by 16 to get the next digit to display
                subi    $5, $5, 1              # Moving the counter offset to the next display
                bnez    $5, writeSsdLoop       # If $5 is 0 then all SSD have been written to
        j       main                           # Looping 
