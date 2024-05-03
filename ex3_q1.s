.text
.global main

main:
        # Printing abcdefghijklmnopqrstuvwxyz
        addi    $2, $0, 'a'                                  # Setting the first char to print
        printLowercaseLoop:                                  # Loop for printing the lowercase letters
                checkTransmitReadyLower:                     # Checking if SP2 is ready to transmit
                        lw      $4, 0x71003($0)
                        andi    $4, $4, 0x2                  # Transmiting flag is the second bit
                        beqz    $4, checkTransmitReadyLower  # Will be 1 if it is ready to transmit
                sw      $2, 0x71000($0)                      # Writing the current char to SP
                addi    $2, $2, 1                            # Incrementing the character to write
                seqi    $3, $2, '{'                          # Checking if 'z' has been printed ('{' is next on the ASCII table)
                beqz    $3, printLowercaseLoop               # Looping if there are still more characters to write
        
        # Printing ABCDEFGHIJKLMNOPQRSTUVWXYZ
        addi    $2, $0, 'A'                                   # Setting the first char to print
        printUppercaseLoop:                                   # Loop for printing the lowercase letters
                checkTransmitReadyUpper:                      # Checking if SP2 is ready to transmit
                        lw      $4, 0x71003($0)
                        andi    $4, $4, 0x2                   # Transmiting flag is the second bit
                        beqz    $4, checkTransmitReadyUpper   # Will be 1 if it is ready to transmit
                sw      $2, 0x71000($0)                       # Writing the current char to SP
                addi    $2, $2, 1                             # Incrementing the character to write
                seqi    $3, $2, '[' # End character after 'Z' # Checking if 'Z' has been printed ('[' is next on the ASCII table)
                beqz    $3, printUppercaseLoop                # Looping if there are still more characters to write

        jr $ra                                                # Exit gracefully
