# Idiom: Jump to next if/else label when condition is false
# Jump using negation if == or !=
# Else, express condition as X < Y
# Assume X < Y is false; get slt result
# * result == 0 EQ $0; use BEQ
# * result == 1 NE $0; use BNE
# Given: A ?? B
# -> If condition is A == B, use A bne B
# -> If condition is A != B, use A beq B
# -> If condition is A < B, use (A slt B) with beq $0
# -> If condition is A > B (B < A), use (B slt A) with beq $0
# -> If condition is A >= B (NOT A < B), use (A slt B) with BNE $0
# -> If condition is A <= B (NOT B < A), use (B slt A) with BNE $0
.macro read_int(%r)

	addi $v0, $zero ,5
	syscall
	add %r, $zero, $v0
.end_macro
.macro print_char(%r)
	add $a0, $zero, %r
	addi $v0, $zero, 11
	syscall
.end_macro
.macro exit
	addi $v0, $zero, 10
	syscall
.end_macro

main: read_int($t0) # int(read(n)) ; $t0 = n
blez $t0, exit
addi $t9, $zero, 90 # tmp = 90 ; $t9 = 90, $k0 = JUMP
slt $k0, $t9, $t0 # [JUMP to elif1 when (NOT n <= 90);
bne $k0, $zero, elif1 # if (n <= 90) {
# [JUMP to else2_1 if (not n == 90)]
if1: bne $t0, $t9, else2_1 # if (n == 90) {
if2_1: addi $t1, $zero, 'R' # m = 'R'
j after # } else {
else2_1: addi $t1, $zero, 'A' # m = 'A' // else2_1
j after # }
elif1: addi $t9, $zero, 180 # [tmp = 180]
slt $k0, $t9, $t0 # [JUMP to else1 if not n > 180 (not 180 < n)]
beq $k0, $zero, else1 # } else if (n > 180) { // elif1
addi $t1, $zero, '?' # m = '?'
j after # } else { // else1
# [JUMP to else2_2 if (not n == 180)]
else1: bne $t0, $t9, else2_2 # if (n == 180) {
addi $t1, $zero, 'S' # m = 'S'
j after # } else { // else2_2
else2_2: addi $t1, $zero, 'O' # m = 'O'
# }
# }
after: print_char($t1) # printf(m)
j main
exit: exit # exit()