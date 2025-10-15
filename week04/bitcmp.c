/*
TASK. Write a tiny program bitcmp.c that requires two positive integers as command line arguments. The program then represents each as an unsigned int. The program prints YES if the second integer (ignoring leading zero bits) has a bit pattern that is part of the first integer’s bit pattern, NO otherwise. For instance, if the user inputs 192 and 6 then the program should print YES on the screen (i.e. matching the bit sub-pattern 110). Test your program well.
*/

#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

bool validPosIntString(int n, char* input) {
    // only accept integers which contain exclusively digits, i.e. no decimal points
    bool valid = true;
    while (n-- && valid) {
        char cur = input[n];
        if (cur < '0' || cur > '9') valid = false;
    }
    return valid;
}

int stringToInt(char* input) {
    int inputLength = strlen(input);
    
    if (inputLength > 10) {
        // we have the input uses more digits than integer limit, this is erroneous
        return -1;
    } 
    else if (inputLength == 10 && (input[0] > '2' && input[0] <= '9')) {
        // too large for int to hold, in the case that the we still have an int too large with the given digits, it will be caught later with the overflow check.
        return -1;
    }
    else if (inputLength != 1 && input[0] == '0') {
        // not just integer 0 and has more than one digit, leading 0s disallowed
        return -1;
    }

    int sum = 0;
    // if we have a valid integer
    if (validPosIntString(inputLength, input)) {
        for (int i = 0; i < inputLength; i++)
            sum = sum * 10 + (input[i] - '0');
    }
    else {
        return -1; // else we have an invalid integer
    }

    // if the sum overflows, we were given an invalid integer
    if (sum < 0) {
        return -1; 
    }
    
    return sum;
}

void compare(char* input1, char* input2) {
    int num1 = stringToInt(input1);
    int num2 = stringToInt(input2);

    if (num1 < 0 || num2 < 0) {
        printf("Invalid arguments: all arguments must be valid 32-bit positive integers.\n");
        exit(1);
    }

    // num1 and num2 are positive at this point
    unsigned int u1 = (unsigned int)num1;
    unsigned int u2 = (unsigned int)num2;

    bool found = false;
    while (u1 >>= 1 || !found) {
        if ((u1 & u2) == u2) {
            found = true;
        }
    }

    if (found) {
        printf("YES\n");
    }
    else {
        printf("NO\n");
    }
}

int main(int n, char* args[/*n*/]) {
    if (n != 3) {
        printf("Not enough arguments: example use ./bitcmp 10 20\n");
        exit(1);
    }
    else {
        compare(args[1], args[2]);
        return 0;
    }
}