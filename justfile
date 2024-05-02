# Lists the available commands
@default:
  @just --list

compile_all:
    @just compile_1
    @just compile_2
    @just compile_3
    @just compile_1

# Compiles and link the first question srec
compile_1:
  wasm ex3_q1.s
  wlink -o ex3_q1.srec ex3_q1.o

# Compiles and link the second question srec
compile_2:
  wasm ex3_q2.s
  wlink -o ex3_q2.srec ex3_q2.o

# Compiles and link the third question srec
compile_3:
  wasm ex3_q3.s
  wlink -o ex3_q3.srec ex3_q3.o

# Compiles and link the fourth question srec
compile_4:
  wasm ex3_q4.s
  wlink -o ex3_q4.srec ex3_q4.o
