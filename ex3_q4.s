.text
.global main

main:
        subui   $sp, $sp, 1                    # Saving the return address to gracefully exit
        sw      $ra, 0($sp)  
        addi    $1, $0, 0                      # Explicitly setting the exit main flag to 0
                
        jobLoop:                               # Looping through the jobs
                jal     serialJob              # Run the serialJob
                jal     parallelJob            # Run the parallelJob
                bnez    $1, exitMain           # If $1 is not zero after parallelJob, then gracefully exit
                j       jobLoop                
        exitMain:
                lw      $ra, 0($sp)            # Popping the og return address from the stack
                addui   $sp, $sp, 1
                jr      $ra                    # Exit gracefully
                

serialJob:
        subui   $sp, $sp, 4                    # Backing up the used registers to the stack
        sw      $2, 0($sp)
        sw      $3, 1($sp)
        sw      $4, 2($sp)
        sw      $5, 3($sp)

        # Loading the sent letter
        checkReceiveReady:
                lw      $1, 0x70003($0)
                andi    $1, $1, 0x1             # recv ready flag is the first bit
                beqz    $1, exitJob             # Exiting if no character has been sent
        lw      $2, 0x70001($0)                 # Loading the character when one has been fully sent
        
        # Filtering out non-lowercase characters
        sgei    $3, $2, 'a'
        slei    $4, $2, 'z'
        and     $5, $3, $4                      # c > a && c < z -> c == Lowercase char
        bnez    $5, checkTransmitReady          # Send the char with no modification if its lowercase
        addi    $2, $0, '*'                     # Censor the char if it's not lowercase, then transmit

        # Sending the processed character
        checkTransmitReady:
                lw      $1, 0x70003($0)
                andi    $1, $1, 0x2             # The transmit ready flag is second bit
                beqz    $1, checkTransmitReady  # Loop if not ready to transmit
        sw      $2, 0x70000($0)                 # Transmit the character to SP 1

        addi    $1, $0, 0                       # Setting $1 to zero, as we don't want to exit
        j       exitJob

parallelJob:
        subui   $sp, $sp, 4                    # Backing up the used registers to the stack
        sw      $2, 0($sp)
        sw      $3, 1($sp)
        sw      $4, 2($sp)
        sw      $5, 3($sp)

        checkButtonPressed:
                lw      $4, 0x73001($0)        # Loading in the value of the buttons
                beqz    $4, exitJob            # Exiting if the buttons haven't been pressed
        
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
        beqz    $3, displayRegisters           # If button two is not pressed, Just display the registers
        addi    $1, $0, 1                      # If button two is pressed, set the exit flag to 1
        j       exitJob                        # Exit the subroutine
        
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
        addi    $1, $0, 0                       # Setting $1 to zero, as we don't want to exit
        j       exitJob                        # Exiting the subroutine 


# Subroutine that handles exiting a job (Handling the stack)
exitJob:
        lw      $2, 0($sp)                      # Cleaning up the stack
        lw      $3, 1($sp)
        lw      $4, 2($sp)
        lw      $5, 3($sp)
        addui   $sp, $sp, 4
        jr       $ra                            # Exiting the subroutine
