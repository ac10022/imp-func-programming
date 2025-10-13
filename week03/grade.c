/*
TASK: Your task is to write a program in C called grade.c which takes in an integer percentage between 0 and 100 as a command line argument to the program, representing the final average mark for a degree, and prints out the corresponding grade. The program prints First for first class (a mark of 70 or more), Upper second for upper second class (60 to 69), Lower second for lower second class (50 to 59), Third for third class (40 to 49), Fail (0 to 39), or Invalid mark if the input is not a valid mark. The program should ignore borderline issues, and other outcomes (ordinary degree, certificate, diploma, aegrotat, credit transfer).
*/

#define FIRST_GRADE 70
#define UPPER_SECOND_GRADE 60
#define LOWER_SECOND_GRADE 50
#define THIRD_GRADE 40

#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>

bool validIntString(int n, char* input) {
    bool valid = true;
    while (n-- && valid) {
        char cur = *(input + n);
        if (cur < '0' || cur > '9') valid = false;
    }
    return valid;
}

int stringToInt(char* input) {
    int inputLength = strlen(input);
    int sum = 0;
    if (validIntString(inputLength, input)) {
        for (int i = 0; i < inputLength; i++)
        {
            sum = sum * 10 + (input[i] - '0');
        }
    }
    else {
        printf("Invalid entered percentage.\n");
        return -1;
    }
    return sum;
}

void printGrade(int grade) {
    if (grade > 100) {
        printf("Invalid\n");
    }
    else if (grade >= FIRST_GRADE) {
        printf("First\n");
    }
    else if (grade >= UPPER_SECOND_GRADE) {
        printf("Upper Second\n");
    }
    else if (grade >= LOWER_SECOND_GRADE) {
        printf("Lower Second\n");
    }
    else if (grade >= THIRD_GRADE) {
        printf("Third\n");
    }
    else if (grade >= 0) {
        printf("Fail\n");
    }
    else {
        printf("Invalid");
    }
}

int main(int n, char *args[]) {
    char* input = args[1];
    int parsed = stringToInt(input);
    if (parsed != -1) {
        printGrade(parsed);
    }
    return 0;
}