/*
TASK: Write a program square.c containing a function square which squares an integer, and a function main which finds and prints the square of 42. Then extend the program so it can find and print the square of integers entered by the user.
*/

#include <stdio.h>

int square(int num) {
    return num * num;
}

int takeUserIntInput(const char* message) {
    printf("%s", message);
    int input = 0;
    scanf("%d", &input);
    return input;
}

int main(void) {
    int input = takeUserIntInput("Enter an integer to square:\n");
    int res = square(input);
    printf("%d\n", res);
    return 0;
}