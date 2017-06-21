# mipstest.asm
# David_Harris@hmc.edu 9 November 2005
#
# Test the MIPS processor: run 190 ns
# add, sub, and, or, slt, addi, lw, sw, beq, j, ANDI
# If successful, it should write the value 7 to address 84
# Assembly Description Address Machine
main: addi $2, $0, 5	# initialize $2 = 5		0 20020005
addi $3, $0, 12			# initialize $3 = 12	4 2003000c
addi $7, $3, -9			# initialize $7 = 3		8 2067fff7
addi $6, $0, 7			# initialize $6 = 7		c 20060007
or $4, $7, $2			# $4 <= 3 or 5 = 7		10 00e22025
andi $5, $3, 7			# $5 <= 12 and 7 = 4	14 30650007		***********
add $5, $5, $4			# $5 = 4 + 7 = 11		18 00a42820
beq $5, $7, end			# shouldn’t be taken	1c 10a7000a
slt $4, $3, $4			# $4 = 12 < 7 = 0		20 0064202a
beq $4, $0, around		# should be taken		24 10800001
addi $5, $0, 0			# shouldn’t happen		28 20050000
around: slt $4, $7, $2	# $4 = 3 < 5 = 1		2c 00e2202a
add $7, $4, $5			# $7 = 1 + 11 = 12		30 00853820
sub $7, $7, $2			# $7 = 12 - 5 = 7		34 00e23822
sw $7, 68($3)			# [80] = 7				38 ac670044
lw $2, 80($0)			# $2 = [80] = 7			3c 8c020050
j end					# should be taken		40 08000011
addi $2, $0, 1			# shouldn’t happen		44 20020001
end: sw $2, 84($0)		# write adr 84 = 7		48 ac020054

# Andi	I	12	-	And immediate	N
