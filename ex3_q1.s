.text
.global main

main:
        # Printing abcdefghijklmnopqrstuvwxyz
        addi    $2, $0, 'a'
        printLowercaseLoop:
                checkReadyLower:
                        lw      $4, 0x71003($0)
                        andi    $4, $4, 0x2
                        beqz    $4, checkReadyLower
                sw      $2, 0x71000($0)
                addi    $2, $2, 1 
                seqi    $3, $2, '{' # End character after 'z'
                beqz    $3, printLowercaseLoop
        
        # Printing ABCDEFGHIJKLMNOPQRSTUVWXYZ
        addi    $2, $0, 'A'
        printUppercaseLoop:
                checkReadyUpper:                     # Checking 
                        lw      $4, 0x71003($0)
                        andi    $4, $4, 0x2
                        beqz    $4, checkReadyUpper
                sw      $2, 0x71000($0)
                addi    $2, $2, 1 
                seqi    $3, $2, '[' # End character after 'Z'
                beqz    $3, printUppercaseLoop
        
        jr $ra
