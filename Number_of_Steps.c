#include <stdio.h>
#include <stdint.h>
static inline int my_clz(uint32_t x) {
    int count = 0;
    for (int i = 31; i >= 0; --i) {
        if (x & (1U << i))
            break;
        count++;
    }
    return 31-count;
}

uint32_t my_popcnt (uint32_t u)
 {
      u = (u & 0x55555555) + ((u >> 1) & 0x55555555);
      u = (u & 0x33333333) + ((u >> 2) & 0x33333333);
      u = (u & 0x0F0F0F0F) + ((u >> 4) & 0x0F0F0F0F);
      u = (u & 0x00FF00FF) + ((u >> 8) & 0x00FF00FF);
      u = (u & 0x0000FFFF) + ((u >> 16) & 0x0000FFFF);
      return u;
 }
int main() {
    int test_data[] = {14, 8, 123};
    
    for (int i = 0; i < 3; i++) {
        int result = test_data[i] ? my_popcnt(test_data[i]) + my_clz(test_data[i]) : 0;
        printf("Input num = %d Output = %d\n",test_data[i],result);
    }

    return 0;
}   