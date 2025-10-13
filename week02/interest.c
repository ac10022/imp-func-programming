/*
TASK. Write a tiny program count.c that requires two strings as command line arguments and then prints at how many positions the second string appears within the first string. For instance, if the user inputs hahaha and aha then the program should print 2 on the screen. Again, structure and test your program well.
*/

#include <string.h>
#include <stdio.h>

#define STR_MAX_LEN 256


int count(char* longer, char* contained) {
    int contLen = strlen(contained);
    int lonLen = strlen(longer);
    int tally = 0;
    
    for (size_t i = 0; i < lonLen - contLen + 1; i++)
    {
        int matches = 0;
        for (size_t j = 0; j < contLen; j++)
        {
            if (*(longer + i + j) == *(contained + j)) matches++;
        }
        if (matches == contLen) tally++;
    }
    return tally;
}

void takeStrUserInput(const char* message, char* dest) {
    printf("%s", message);
    scanf("%255s", dest);
}

int main(void) {
    char longer[STR_MAX_LEN];
    char contained[STR_MAX_LEN];

    takeStrUserInput("Enter the longer string:\n", longer);
    takeStrUserInput("Enter the shorter, contained string:\n", contained);

    int res = count(longer, contained);
    printf("The contained string appears %d times in the longer string.\n", res);
    return 0;
}