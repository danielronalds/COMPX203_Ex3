# Lists the available commands
@default:
  @just --list

# Compiles and link the first question srec
compile_1:
  wasm ex3_q1.s
  wlink -o ex3_q1.srec ex3_q1.o
