/*
TASK. Write a tiny program numseq.c that takes one command line string of only digits as input. The program then prints the length of the longest sequence of consecutive decimal numbers in this string. For instance, if the user inputs 19101114482 then the program should print 3 on the screen since 9, 10, and 11 form the longest sequence. Structure and test your program well.
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

int substringInt(const char* str, int startIndex, int numSize) {
    char res[numSize];
    strncpy(res, str + startIndex, numSize);
    res[numSize] = '\0';
    return atoi(res);
}

int toIncreaseNumSize(int cur) {
    return (int)log10((double)cur) != (int)log10((double)(cur+1));
}

int countNumSeq(const char* str) {
    int slen = strlen(str);
    
    // trivial cases
    if (slen == 0) return 0;
    if (slen == 1) return 1;

    int toptally = 0;
    int tally = 0;
    int cur = 0;
    int prev = 0;

    for (int numSize = 1; numSize < (slen / 2); numSize++)
    {
        int curNumSize = numSize;
        for (int i = 0; i < slen; i += curNumSize)
        {
            cur = substringInt(str, i, curNumSize);
            if (toIncreaseNumSize(cur)) {
                i--;
                curNumSize++;
            }

            if (cur == prev + 1) tally++;
            else if (i > 0) {
                if (tally > toptally) toptally = tally;
                tally = 0;
            }

            prev = cur;
        }
        if (tally != 0 && tally > toptally) {
            toptally = tally;
            tally = 0;
        }

        prev = 0;
        cur = 0;
    }

    return toptally;
}

int main(int n, char** args) {
    int res = 0;
    if (n == 2) res = countNumSeq(args[1]);
    else printf("Only provide one argument.");
    printf("%d\n", res);
    return 0;
}