.data
nums:
.word 14, 8, 123 # 測試資料 num = 14, 8, 123
nums_end:                   # 標記數組結束位置
size:
.word 3 # 確認測試資料的數量是5個
input_str:
.string "Input: num = " # 定義字串 "Input: num = "
output_str:
.string " Output: " # 定義字串 "Output: "

.text
.globl main

main:
# 初始化指標和大小
la t0, nums             # 將 nums 陣列的起始位址載入 t0
la t1, nums_end         # 載入數組結束地址
sub t1, t1, t0          # 計算字節差
srai t1, t1, 2          # 除以 4 (每個 word 4 字節) 得到元素數量
lw t1, size # 取得測試資料的大小，確認 size 是 5
li t2, 0 # i = 0，初始化索引

loop_outer:
lw t6, size # 重新載入 size 到 t6
beq t2, t6, done_outer # 如果 i == size，跳出外層迴圈

lw t3, 0(t0) # 取得 nums[i]，載入到 t3 (num)
mv t4, t3 # 保存原始的 num 到 t4，以便後續顯示
jal ra, numberOfSteps # 呼叫 numberOfSteps 函式，步驟數存到 a1

# 顯示字串 "Input: num = "
la a0, input_str # 載入 "Input: num = "
li a7, 4 # 系統呼叫代碼 4 (print string)
ecall # 執行系統呼叫

# 顯示原始的 num
mv a0, t4 # 將原始 num 傳給 a0 (syscall 1: print integer)
li a7, 1 # 系統呼叫代碼 1 (print integer)
ecall # 顯示數字

# 顯示字串 " Output: "
la a0, output_str # 載入 " Output: "
li a7, 4 # 系統呼叫代碼 4 (print string)
ecall # 執行系統呼叫

# 顯示步驟數
mv a0, a1 # 將步驟數 (a1) 傳給 a0
li a7, 1 # 系統呼叫代碼 1 (print integer)
ecall # 顯示步驟數

# 換行
li a0, 0x0A # 換行 (0x0A 是換行字符)
li a7, 11 # 系統呼叫代碼 11 (print char)
ecall
# 移到下一個測試資料
addi t0, t0, 4 # nums 指標向後移動 4 bytes (int 大小)
addi t2, t2, 1 # i++

j loop_outer # 返回外層迴圈

done_outer:
# 結束程式
li a7, 10 # 系統呼叫代碼 10 (exit)
ecall

# numberOfSteps 函式
numberOfSteps:
li t1, 0 # count = 0
loop_inner:
beqz t3, done_inner # 如果 num == 0，跳出內層迴圈

andi t5, t3, 1 # 使用 t5 檢查 num 是否為奇數，避免修改 t2
beqz t5, even # 如果 num 是偶數，跳到 even

# 如果是奇數，num = num - 1
addi t3, t3, -1
j update_count # 跳到更新步驟計數

even:
# 如果是偶數，num = num / 2
srli t3, t3, 1 # 右移一位等於除以 2

update_count:
# count++
addi t1, t1, 1
j loop_inner # 返回內層迴圈

done_inner:
mv a1, t1 # 將步驟數存入 a1 作為返回值
ret # 返回主程式