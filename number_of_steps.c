#include <stdio.h>

int numberOfSteps(int num) {
    int steps = 0;
    while (num > 0) {
        if (num % 2 == 0) {
            num /= 2;
        } else {
            num -= 1;
        }
        steps++;
    }
    return steps;
}

int main() {
    int test_data[] = {14, 8, 123};
    int expected_results[] = {6, 4, 12};
    
    for (int i = 0; i < 3; i++) {
        int result = numberOfSteps(test_data[i]);
        if (result == expected_results[i]) {
            printf("Test %d passed. Result: %d\n", i + 1, result);
        } else {
            printf("Test %d failed. Expected: %d, Got: %d\n", i + 1, expected_results[i], result);
        }
    }

    return 0;
}