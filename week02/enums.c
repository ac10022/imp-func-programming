/* 
TASK: Write a recursive C program that calculates the n Fibonacci number given an integer n >= 0.
*/

#include <stdio.h>

int f(int n) {
    if (n <= 0) return 0;
    if (n == 1) return 1;
    return f(n-1) + f(n-2);
}

int main(void) {
    int f_20 = f(20);
    printf("f20: %d\n", f_20);
    return 0;
}