.text
.global main

main:
        # Loading the sent letter
        checkReceiveReady:
                lw      $1, 0x70003($0)
                andi    $1, $1, 0x1             # recv ready flag is the first bit
                beqz    $1, checkReceiveReady   # Looping if no character has been sent
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
        j       main
