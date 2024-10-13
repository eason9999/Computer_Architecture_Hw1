.data
nums:
.word 14, 8, 123  # Test data nums
input_str:
.string "Input: num = "  
output_str:
.string " Output: "  

.text
main:
la t0, nums  # Load nums array start address
li t6, 3     # Number of elements in nums (optimized: hardcoded)
li t2, 0  # i = 0

loop_outer:
    beq t2, t6, done_outer # If i == size, exit the outer loop

    addi t0, t0, 4        # Move the nums pointer forward by 4 bytes (size of an int)
    addi t2, t2, 1        # i++

    lw t3, -4(t0)         # Get nums[i], load it into t3 (num), using -4 offset
    mv t4, t3             # Save the original num into t4 for later display
    jal ra, my_popcnt      # Call my_popcnt, store the step count in a1

# Display string "Input: num = "
    la a0, input_str      # Load "Input: num = "
    li a7, 4              # System call number 4 (print string)
    ecall                 # Execute system call

# Display the original num
    mv a0, t4             # Pass the original num to a0 (syscall 1: print integer)
    li a7, 1              # System call number 1 (print integer)
    ecall                 # Display the number

# Display string " Output: "
    la a0, output_str     # Load " Output: "
    li a7, 4              # System call number 4 (print string)
    ecall                 # Execute system call

# Display the step count
    mv a0, a1             # Pass the step count (a1) to a0
    li a7, 1              # System call number 1 (print integer)
    ecall                 # Display the step count

# New line
    li a0, 0x0A           # New line (0x0A is the newline character)
    li a7, 11             # System call number 11 (print character)
    ecall

# Move to the next test data
    j loop_outer          # Return to the outer loop

done_outer:
# End program
    li a7, 10             # System call number 10 (exit)
    ecall

my_popcnt:
# u = (u & 0x55555555) + ((u >> 1) & 0x55555555)
    li s0, 0x55555555     # Load mask 0x55555555
    and s1, s0, t3        # s1 = u & 0x55555555
    srli s2, t3, 1        # s2 = u >> 1
    and s2, s2, s0        # s2 = (u >> 1) & 0x55555555
    add a1, s2, s1        # a1 = (u & 0x55555555) + ((u >> 1) & 0x55555555)

# u = (u & 0x33333333) + ((u >> 2) & 0x33333333)
    li s0, 0x33333333     # Load mask 0x33333333
    and s1, s0, a1        # s1 = u & 0x33333333
    srli s2, a1, 2        # s2 = u >> 2 
    and s2, s2, s0        # s2 = (u >> 2) & 0x33333333
    add a1, s2, s1        # a1 = (u & 0x33333333) + ((u >> 2) & 0x33333333)

# u = (u & 0x0F0F0F0F) + ((u >> 4) & 0x0F0F0F0F)
    li s0, 0x0F0F0F0F     # Load mask 0x0F0F0F0F
    and s1, s0, a1        # s1 = u & 0x0F0F0F0F
    srli s2, a1, 4        # s2 = u >> 4 
    and s2, s2, s0        # s2 = (u >> 4) & 0x0F0F0F0F
    add a1, s2, s1        # a1 = (u & 0x0F0F0F0F) + ((u >> 4) & 0x0F0F0F0F)

# u = (u & 0x00FF00FF) + ((u >> 8) & 0x00FF00FF)
    li s0, 0x00FF00FF     # Load mask 0x00FF00FF
    and s1, s0, a1        # s1 = u & 0x00FF00FF
    srli s2, a1, 8        # s2= u >> 8 
    and s2, s2, s0        # s2 = (u >> 8) & 0x00FF00FF
    add a1, s2, s1        # a1 = (u & 0x00FF00FF) + ((u >> 8) & 0x00FF00FF)

# u = (u & 0x0000FFFF) + ((u >> 16) & 0x0000FFFF)
    li s0, 0x0000FFFF     # Load mask 0x0000FFFF
    and s1, s0, a1        # s1 = u & 0x0000FFFF
    srli s2, a1, 16       # s2= u >> 16 
    and s2, s2, s0        # s2 = (u >> 16) & 0x0000FFFF
    add a1, s2, s1        # a1 = (u & 0x0000FFFF) + ((u >> 16) & 0x0000FFFF)

length:
    li s1, 0              # s1 = count = 0
    li s0, 31             # s0 = i = 31
    li s2, 1              # s2 = 1
    beqz t3, all_zeros     # If x is 0, jump to all_zeros
    
clz_loop:    
    sll s3, s2, s0         # s3 = 1 << i 
    and s3, t3, s3         # s3 = x & (1 << i) 
    bne s3, zero, end_loop # If s3 != 0, jump to end_loop 

    addi s1, s1, 1          # count++
    addi s0, s0, -1         # i--
    bge s0, zero, clz_loop  # If i >= 0, continue loop

all_zeros:
    li s1, 32               # If x is 0, count = 32

end_loop:
    li s2, 31               # s2 = 31 
    sub a0, s2, s1          # a0 = 31 - clz (return value)
    add a1, a0, a1

ret                         # Return to main program