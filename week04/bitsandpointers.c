/*
TASK. Write a tiny program bitsum.c that requires a positive integer as a command line argument represented in your program as an unsigned int and then prints the number of bits that are 1 in its representation. For instance, if the user inputs 132 then the program should print 2 on the screen. Structure and test your program well.
*/

#include <stdlib.h>
#include <stdio.h>

unsigned int strToUnsignedInt(char* input) {
    unsigned int res = strtoul(input, NULL, 10);
    return res;
}

int main(int n, char *args[]) {
    unsigned int input = strToUnsignedInt(*(args + 1));
    int tally = 0;
    while (input >>= 1) {
        if ((input & (unsigned int)1) == (unsigned int)1) tally++;
    }
    printf("Number of 1s in input: %d\n", tally);
    return 0;
}