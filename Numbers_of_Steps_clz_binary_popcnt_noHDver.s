.data
nums:
.word 14, 8, 123  # Test data nums = 14, 8, 123
input_str:
.string "Input: num = "  # Defines the string "Input: num = "
output_str:
.string " Output: "  # Defines the string "Output: "

.text
main:
# Initialize pointers and array size
li t6, 3     # Number of elements in nums (optimized: hardcoded)
li t2, 0  # i = 0
la t0, nums  # Load nums array start address

loop_outer:
beq t2, t6, done_outer  # If i == size, exit the outer loop
addi t0, t0, 4  # Move the nums pointer forward by 4 bytes (size of an int)
addi t2, t2, 1  # Increment i
lw t3, -4(t0)  # Load nums[i] into t3 (num), note the -4 offset
addi x0,x0,0 #NOP
mv t4, t3  # Save the original num into t4 for later display
jal ra, my_popcnt  # Call my_popcnt, step count is stored in a1

# Display the string "Input: num = "
la a0, input_str  # Load the address of "Input: num = "
li a7, 4  # Syscall number 4 (print string)
addi x0,x0,0 #NOP
addi x0,x0,0 #NOP
addi x0,x0,0 #NOP
ecall  # Execute syscall

# Display the original num
mv a0, t4  # Move the original num into a0 (syscall 1: print integer)
li a7, 1  # Syscall number 1 (print integer)
addi x0,x0,0 #NOP
addi x0,x0,0 #NOP
addi x0,x0,0 #NOP
ecall  # Display the number

# Display the string " Output: "
la a0, output_str  # Load the address of " Output: "
li a7, 4  # Syscall number 4 (print string)
addi x0,x0,0 #NOP
addi x0,x0,0 #NOP
addi x0,x0,0 #NOP
ecall  # Execute syscall

# Display the step count
mv a0, a1  # Move the step count (a1) into a0
li a7, 1  # Syscall number 1 (print integer)
addi x0,x0,0 #NOP
addi x0,x0,0 #NOP
addi x0,x0,0 #NOP
ecall  # Display the step count

# Print a newline
li a0, 0x0A  # Newline (0x0A is the newline character)
li a7, 11  # Syscall number 11 (print char)
addi x0,x0,0 #NOP
addi x0,x0,0 #NOP
addi x0,x0,0 #NOP
ecall

# Move to the next test data
j loop_outer  # Jump back to the outer loop

done_outer:
# Exit the program
li a7, 10  # Syscall number 10 (exit)
addi x0,x0,0 #NOP
addi x0,x0,0 #NOP
addi x0,x0,0 #NOP
ecall

my_popcnt:
# u = (u & 0x55555555) + ((u >> 1) & 0x55555555)
li s0, 0x55555555        # Load mask 0x55555555
and s1, s0, t3           # s1 = u & 0x55555555
srli s2, t3, 1           # s2 = u >> 1
and s2, s2, s0           # s2 = (u >> 1) & 0x55555555
add a1, s2, s1           # a1 = (u & 0x55555555) + ((u >> 1) & 0x55555555)

# u = (u & 0x33333333) + ((u >> 2) & 0x33333333)
li s0, 0x33333333        # Load mask 0x33333333
and s1, s0, a1           # s1 = u & 0x33333333
srli s2, a1, 2           # s2 = u >> 2
and s2, s2, s0           # s2 = (u >> 2) & 0x33333333
add a1, s2, s1           # a1 = (u & 0x33333333) + ((u >> 2) & 0x33333333)

# u = (u & 0x0F0F0F0F) + ((u >> 4) & 0x0F0F0F0F)
li s0, 0x0F0F0F0F        # Load mask 0x0F0F0F0F
and s1, s0, a1           # s1 = u & 0x0F0F0F0F
srli s2, a1, 4           # s2 = u >> 4
and s2, s2, s0           # s2 = (u >> 4) & 0x0F0F0F0F
add a1, s2, s1           # a1 = (u & 0x0F0F0F0F) + ((u >> 4) & 0x0F0F0F0F)

# u = (u & 0x00FF00FF) + ((u >> 8) & 0x00FF00FF)
li s0, 0x00FF00FF        # Load mask 0x00FF00FF
and s1, s0, a1           # s1 = u & 0x00FF00FF
srli s2, a1, 8           # s2 = u >> 8
and s2, s2, s0           # s2 = (u >> 8) & 0x00FF00FF
add a1, s2, s1           # a1 = (u & 0x00FF00FF) + ((u >> 8) & 0x00FF00FF)

# u = (u & 0x0000FFFF) + ((u >> 16) & 0x0000FFFF)
li s0, 0x0000FFFF        # Load mask 0x0000FFFF
and s1, s0, a1           # s1 = u & 0x0000FFFF
srli s2, a1, 16          # s2 = u >> 16
and s2, s2, s0           # s2 = (u >> 16) & 0x0000FFFF
add a1, s2, s1           # a1 = (u & 0x0000FFFF) + ((u >> 16) & 0x0000FFFF)

my_clz:
li s0, 0  # s0 = clz = 0

# if ((num >> 16) == 0)
srli s1, t3, 16  # s1 = num >> 16
addi x0,x0,0 # NOP
addi x0,x0,0 # NOP
bnez s1, check_24  # If num >> 16 is not 0, jump to check_24
addi s0, s0, 16  # clz += 16
slli t3, t3, 16  # num <<= 16

check_24:
# if ((num >> 24) == 0)
srli s1, t3, 24  # s1 = num >> 24
addi x0,x0,0 # NOP
addi x0,x0,0 # NOP
bnez s1, check_28  # If num >> 24 is not 0, jump to check_28
addi s0, s0, 8  # clz += 8
slli t3, t3, 8  # num <<= 8

check_28:
# if ((num >> 28) == 0)
srli s1, t3, 28  # s1 = num >> 28
addi x0,x0,0 # NOP
addi x0,x0,0 # NOP
bnez s1, check_30  # If num >> 28 is not 0, jump to check_30
addi s0, s0, 4  # clz += 4
slli t3, t3, 4  # num <<= 4

check_30:
# if ((num >> 30) == 0)
srli s1, t3, 30  # s1 = num >> 30
addi x0,x0,0 # NOP
addi x0,x0,0 # NOP
bnez s1, check_31  # If num >> 30 is not 0, jump to check_31
addi s0, s0, 2  # clz += 2
slli t3, t3, 2  # num <<= 2

check_31:
# if ((num >> 31) == 0)
srli s1, t3, 31  # s1 = num >> 31
addi x0,x0,0 # NOP
addi x0,x0,0 # NOP
bnez s1, done  # If num >> 31 is not 0, jump to done
addi s0, s0, 1  # clz += 1

done:
li s1, 31  # s1 = 31
addi x0,x0,0 # NOP
sub a0, s1, s0  # a0 = 31 - clz (return value)
add a1, a0, a1  # Add clz result to popcnt result

ret  # Return to main program