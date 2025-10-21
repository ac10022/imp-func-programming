/*
TASK. Write a tiny program histogram.c that can take an arbitrary number of command line argument strings as input and prints for each of the actually occurring letters of the alphabet how often it appeared across these strings. For instance, if the user inputs ab aac then the program should print a=3;b=1;c=1 on the screen. Structure and test your program well.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void countChars(int* tallyArray, const char* str) {
    size_t len = strlen(str);
    char cur = 0x0;
    int arrIndex = 0;
    for (size_t i = 0; i < len; i++)
    {
        cur = *(str + i);
        if (cur >= 'a' && cur <= 'z') {
            arrIndex = cur - 'a';
            tallyArray[arrIndex]++;
        }
        else if (cur >= 'A' && cur <= 'Z') {
            arrIndex = cur - 'A';
            tallyArray[arrIndex]++;
        }
    }
}

void printCharCounter(int* tallyArray) {
    for (int i = 0; i < 26; i++)
    {
        int charCount = tallyArray[i];
        if (charCount != 0) {
            printf("%c: %d\n", (char)('a' + i), charCount);
        }
    }
}

int main(int n, char **args) {
    // declare int array filled with 0
    int *charCount = (int*)malloc(26 * sizeof(int));

    for (int i = 0; i < 26; i++)
        charCount[i] = 0;
    
    for (int i = 1; i < n; i++)
        countChars(charCount, args[i]);
    
    printCharCounter(charCount);
}