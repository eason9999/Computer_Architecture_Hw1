.data
nums:
.word 14, 8, 123  # 測試資料 num = 14, 8, 123
nums_end:  # 標記nums 陣列結束位址
input_str:
.string "Input: num = "  # 定義字串 "Input: num = "
output_str:
.string " Output: "  # 定義字串 "Output: "
.text

main:
# 初始化指標
la t0, nums  # 將 nums 陣列的起始位址載入 t0
la t1, nums_end  # 載入nums 陣列結束位址
sub t1, t1, t0  # 計算位元組差
srai t6, t1, 2  # 除以 4 (每個 word 4 bytes) 得到元素數量
li t2, 0  # i = 0，初始化index i

loop_outer:
beq t2, t6, done_outer  # 如果 i == size，跳出外層迴圈

addi t0, t0, 4  # nums 指標向後移動 4 bytes (int 大小)
addi t2, t2, 1  # i++

lw t3, -4(t0)  # 取得 nums[i]，載入到 t3 (num)，注意這裡用 -4 偏移
mv t4, t3  # 保存原始的 num 到 t4，以便後續顯示
jal ra, my_popcnt   # 呼叫 my_popcnt，步驟數存到 a1

# 顯示string "Input: num = "
la a0, input_str  # 載入 "Input: num = "
li a7, 4  # 系統呼叫編號 4 (print string)
ecall  # 執行系統呼叫

# 顯示原始的 num
mv a0, t4  # 將原始 num 傳給 a0 (syscall 1: print integer)
li a7, 1  # 系統呼叫編號 1 (print integer)
ecall  # 顯示數字

# 顯示字串 " Output: "
la a0, output_str # 載入 " Output: "
li a7, 4 # 系統呼叫編號 4 (print string)
ecall # 執行系統呼叫

# 顯示步驟數
mv a0 a1 # 將步驟數 (a1) 傳給 a0
li a7, 1 # 系統呼叫編號 1 (print integer)
ecall # 顯示步驟數

# 換行
li a0, 0x0A # 換行 (0x0A 是換行字符)
li a7, 11 # 系統呼叫編號 11 (print char)
ecall

# 移到下一個測試資料
j loop_outer # 返回外層迴圈

done_outer:
# 結束程式
li a7, 10 # 系統呼叫編號 10 (exit)
ecall

my_popcnt:

# u = (u & 0x55555555) + ((u >> 1) & 0x55555555)
li s0, 0x55555555        # 加載掩碼 0x55555555
and s1, s0, t3           # s1 = u & 0x55555555
srli s2, t3, 1           # s2 = u >> 1
and s2, s2, s0           # s2 = (u >> 1) & 0x55555555
add a1, s2, s1           # a1 = (u & 0x55555555) + ((u >> 1) & 0x55555555)

# u = (u & 0x33333333) + ((u >> 2) & 0x33333333)
li s0, 0x33333333        # 加載掩碼 0x33333333
and s1, s0, a1           # s1 = u & 0x33333333
srli s2, a1, 2           # s1 = u >> 2
and s2, s2, s0           # s2 = (u >> 2) & 0x33333333
add a1, s2, s1           # a1 = (u & 0x33333333) + ((u >> 2) & 0x33333333)

# u = (u & 0x0F0F0F0F) + ((u >> 4) & 0x0F0F0F0F)
li s0, 0x0F0F0F0F        # 加載掩碼 0x0F0F0F0F
and s1, s0, a1           # s1 = u & 0x0F0F0F0F
srli s2, a1, 4           # s1 = u >> 4
and s2, s2, s0           # s2 = (u >> 4) & 0x0F0F0F0F
add a1, s2, s1           # a1 = (u & 0x0F0F0F0F) + ((u >> 4) & 0x0F0F0F0F)

# u = (u & 0x00FF00FF) + ((u >> 8) & 0x00FF00FF)
li s0, 0x00FF00FF        # 加載掩碼 0x00FF00FF
and s1, s0, a1           # s1 = u & 0x00FF00FF
srli s2, a1, 8           # s1 = u >> 8
and s2, s2, s0           # s2 = (u >> 8) & 0x00FF00FF
add a1, s2, s1           # a1 = (u & 0x00FF00FF) + ((u >> 8) & 0x00FF00FF)

# u = (u & 0x0000FFFF) + ((u >> 16) & 0x0000FFFF)
li s0, 0x0000FFFF        # 加載掩碼 0x0000FFFF
and s1, s0, a1           # a0 = u & 0x0000FFFF
srli s2, a1, 16          # s1 = u >> 16
and s2, s2, s0           # s2 = (u >> 16) & 0x0000FFFF
add a1, s2, s1           # a1 = (u & 0x0000FFFF) + ((u >> 16) & 0x0000FFFF)

length:
    li s0, 0          # s0 = clz = 0

    # if ((num >> 16) == 0)
    srli s1, t3, 16   # s1 = num >> 16
    bnez s1, check_24 # 如果 num >> 16 不等于0，跳到 check_24
    addi s0, s0, 16   # clz += 16
    slli t3, t3, 16   # num <<= 16

check_24:
    # if ((num >> 24) == 0)
    srli s1, t3, 24   # t1 = num >> 24
    bnez s1, check_28 # 如果 num >> 24 不等于0，跳到 check_28
    addi s0, s0, 8    # clz += 8
    slli t3, t3, 8    # num <<= 8

check_28:
    # if ((num >> 28) == 0)
    srli s1, t3, 28   # t1 = num >> 28
    bnez s1, check_30 # 如果 num >> 28 不等于0，跳到 check_30
    addi s0, s0, 4    # clz += 4
    slli t3, t3, 4    # num <<= 4

check_30:
    # if ((num >> 30) == 0)
    srli s1, t3, 30   # t1 = num >> 30
    bnez s1, check_31 # 如果 num >> 30 不等于0，跳到 check_31
    addi s0, s0, 2    # clz += 2
    slli t3, t3, 2    # num <<= 2

check_31:
    # if ((num >> 31) == 0)
    srli s1, t3, 31   # t1 = num >> 31
    bnez s1 done         # 如果 num >> 31 不等于0，跳到 done
    addi s0, s0, 1    # clz += 1

done:
    li s1, 31         # t1 = 31
    sub a0, s1, s0    # a0 = 31 - clz (返回值)
    add a1, a0, a1

ret                      # 返回主程式