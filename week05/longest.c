/*
TASK. Write a tiny program longest.c that can take an arbitrary number of command line argument strings as input. The program then prints for each of the actually occurring letters of the alphabet how long the longest occurring sequence of this letter in any one of the strings is. For instance, if the user inputs aabba aaad then the program should print a=3;b=2;d=1 on the screen. Structure and test your program well.
*/

#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

void checkArg(int* alphabet, const char* str) {
    int slen = strlen(str);
    char prev = 0x0;
    char cur = 0x0;
    int tally = 1;
    for (int i = 0; i < slen + 1; i++)
    {
        cur = str[i];
        if (cur == prev) tally++;
        else if (i != 0) {
            int ind = prev - 'a';
            if (alphabet[ind] < tally) alphabet[ind] = tally;
            tally = 1;
        }
        if (i != slen + 1) {
            prev = str[i];
        }
    }
}

void clearAlphabet(int* alphabet) {
    for (int i = 0; i < 26; i++)
    {
        alphabet[i] = 0;
    }
    
}

void printAlphabet(int* alphabet) {
    for (int i = 0; i < 26; i++)
    {
        if (alphabet[i] != 0) printf("%c: %d\n", (char)('a' + i), alphabet[i]);
    }
}

int main(int n, char** args) {
    int* alphabet = (int*)malloc(26 * sizeof(int));
    clearAlphabet(alphabet);
    for (int i = 1; i < n; i++)
    {
        checkArg(alphabet, args[i]);
    }
    printAlphabet(alphabet);
}