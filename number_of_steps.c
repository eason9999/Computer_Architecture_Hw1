#include <stdio.h>
#include <stdint.h>
int length(uint32_t num) {
    uint32_t clz = 0;
    if ((num >> 16) == 0) {
        clz += 16;
        num <<= 16;
    }
    if ((num >> 24) == 0) {
        clz += 8;
        num <<= 8;
    }
    if ((num >> 28) == 0) {
        clz += 4;
        num <<= 4;
    }
    if ((num >> 30) == 0) {
        clz += 2;
        num <<= 2;
    }
    if ((num >> 31) == 0) {
        clz += 1;
    }
    return 31 - clz;
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
        int result = test_data[i] ? my_popcnt(test_data[i]) + length(test_data[i]) : 0;
        printf("Input num = %d Output = %d\n",test_data[i],result);
    }

    return 0;
}   