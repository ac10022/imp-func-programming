/*
TASK. Write a tiny program addresses.c that requires an integer as a command line argument and then prints the square of this integer along with the memory addresses of all variables (including function arguments and any pointer variables) used in the program. Test your program well.
*/

#include <stdio.h>
#include <stdlib.h>

int main(int n, char* args[/*n*/]) {
    if (n != 2) {
        printf("Invalid number of arguments. Example usage: ./addresses 10");
        exit(1);
    }
    else {
        printf("%x\tn\t%d\n", &n, n);
        printf("%x\targs[0]\t%s\n", &args[0], args[0]);
        printf("%x\targs[1]\t%s\n", &args[1], args[1]);
        int input = atoi(args[1]);
        printf("%x\tinput\t%d\n", &input, input);
        int square = input * input;
        printf("%x\tsquare\t%d\n", &square, square);
    }
    return 0;
}