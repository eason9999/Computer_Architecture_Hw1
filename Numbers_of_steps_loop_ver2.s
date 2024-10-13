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
la s0, nums  # Load nums array start address
li s1, 3     # Number of elements in nums (optimized: hardcoded)
li t0, 0  # i = 0

loop_outer:
beq t0, s1, done_outer  # Exit if i == size
lw t3, 0(s0)  # Load nums[i] into t3
addi s0, s0, 4  # Move nums pointer
addi t0, t0, 1  # i++
mv a1, t3  # Save original num
jal ra, numberOfSteps  # Call numberOfSteps, result in a1

# Print "Input: num = ", num, " Output: ", and step count in one go
la a0, input_str  # Load "Input: num = " string
li a7, 4  # Syscall 4: print string
ecall
mv a0, a1  # Move original num into a0
li a7, 1  # Syscall 1: print integer
ecall
la a0, output_str  # Load " Output: " string
li a7, 4  # Syscall 4: print string
ecall
mv a0, a2  # Move step count into a0
li a7, 1  # Syscall 1: print integer
ecall
li a0, 0x0A  # Print newline
li a7, 11  # Syscall 11: print char
ecall

j loop_outer  # Repeat for next element

done_outer:
li a7, 10  # Syscall 10: exit program
ecall

numberOfSteps:
li a2, 0  # count = 0

loop_inner:
andi t5, t3, 1  # Check if num is odd
sub t3, t3, t5  # If odd, subtract 1
add a2, a2, t5  # If odd, count + 1(t5),else, count+0(5)
srli t3, t3, 1
beqz t3, done_inner  # Exit if num == 0
addi a2, a2, 1  # Increment count
j loop_inner  # Jump to update count

done_inner:
ret

