.text
.global main

main:

# Loading the sent letter
checkReceiveReady:
        lw      $1, 0x70003($0)
        andi    $1, $1, 0x1
        beqz    $1, checkReceiveReady

lw      $2, 0x70001($0)

# Sending it back
checkTransmitReady:
        lw      $1, 0x70003($0)
        andi    $1, $1, 0x2
        beqz    $1, checkTransmitReady

sw      $2, 0x70000($0)


j       main
