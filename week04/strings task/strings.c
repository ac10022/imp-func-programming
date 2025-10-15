/* Custom versions of standard string functions. */
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

// Find the length of a string, assuming it has a null terminator (like strlen).
int length(const char s[]) {
    // we will tally up until we reach the null terminator \0
    // set current char to first char of s and initialise a tally at 0
    char cur = s[0];
    int tally = 0;

    // while the current char is not the null terminator
    while (cur != '\0') {
        // increment the tally, also acts as an index
        tally++;
        // change the current char to the next char
        cur = s[tally];
    }

    // returns how many chars until the null terminator, i.e. the str length
    return tally;
}

// Copy string s into the character array t (like strcpy).
void copy(char t[], const char s[]) {
    int tlen = length(t);
    if (t != 0) {
        // empty t
        for (int i = 0; i < tlen; i++)
            t[i] = '\0';
    }

    int slen = length(s);
    for (int i = 0; i < slen; i++)
        t[i] = s[i]; // for each char in s, copy this into t
}

// Compare two strings, returning negative, zero or positive (like strcmp).
int compare(const char s[], const char t[]) {
    int slen = length(s);
    int tlen = length(t);

    // if s is longer than t, it is immediately 'greater' as \0 is the lowest char value
    if (tlen < slen) return 1;
    // if t is longer than s, it is immediately 'greater' as \0 is the lowest char value
    if (slen < tlen) return -1;

    // initialise 'current' characters
    char scur = 0x0;
    char tcur = 0x0;

    for (int i = 0; i < slen; i++)
    {
        // set current characters to those found at this current i index in each string
        scur = s[i];
        tcur = t[i];
        
        // check whether one is greater than the other, if so return the corresponding comparison code
        if (scur > tcur) return 1;
        if (tcur > scur) return -1;
    }

    // if no character has been greater than any other, than the strings must be equal, return 0
    return 0;
}

// Join string s to the end of string t (like strcat).
void append(char t[], const char s[]) {
    int tlen = length(t);
    int slen = length(s);

    // starting at the character succeeding the last in t, place the characters of s into t in order
    for (int i = tlen; i < tlen + slen; i++)
        t[i] = s[i - tlen];
    
    // finish with null terminator
    t[tlen + slen] = '\0';
}

// Find the (first) position of s in t, or return -1 (like strstr).
int find(const char t[], const char s[]) {
    int tlen = length(t);
    int slen = length(s);

    // string not long enough to contain substring, so immediately interrupt
    if (slen > tlen) return -1;

    // bool for whether the substring has been found
    int found = 0;
    // for each index of the given string, check the next slen characters to see if they all match those in the actual substring
    for (int i = 0; i < tlen - slen + 1; i++)
    {
        found = 1;
        for (int j = 0; j < slen; j++)
        {
            if (t[i + j] != s[j]) found = 0; // if characters do not match, this cannot be the substring
        }
        if (found == 1) return i; // if all characters matched, we found the substring, so return this i index
    }

    // if we check the whole string and no substring match, return -1
    return -1;
}

// -----------------------------------------------------------------------------
// Tests and user interface

// Custom assert function to replace the one in assert.h. Reports the test
// number, not the line number.
void assert(bool b) {
    static int testNumber = 0;
    testNumber++;
    if (! b) {
        printf("Test %d failed\n", testNumber);
        exit(1);
    }
}

// Tests 1 to 5
void testLength() {
    assert(length("") == 0);
    assert(length("c") == 1);
    assert(length("ca") == 2);
    assert(length("cat") == 3);
    char s[] = "dog";
    assert(length(s) == 3);
}

// Tests 6 to 9
void testCopy() {
    char t[10];
    copy(t, "cat");
    assert(t[0] == 'c' && t[1] =='a' && t[2] == 't' && t[3] =='\0');
    copy(t, "at");
    assert(t[0] == 'a' && t[1] =='t' && t[2] =='\0');
    copy(t, "t");
    assert(t[0] == 't' && t[1] =='\0');
    copy(t, "");
    assert(t[0] == '\0');
}

// Tests 10 to 17
void testCompare() {
    assert(compare("cat", "dog") < 0);
    assert(compare("dog", "cat") > 0);
    assert(compare("cat", "cat") == 0);
    assert(compare("an", "ant") < 0);
    assert(compare("ant", "an") > 0);
    assert(compare("", "a") < 0);
    assert(compare("a", "") > 0);
    assert(compare("", "") == 0);
}

// Tests 18 to 20
void testAppend() {
    char t[10] = {'c', 'a', 't', '\0', 'x'};
    append(t, "");
    assert(t[0]=='c' && t[1]=='a' && t[2]=='t' && t[3]=='\0' && t[4]=='x');
    char u[10] = {'c', 'a', '\0', 'x', 'x'};
    append(u, "t");
    assert(u[0]=='c' && u[1]=='a' && u[2]=='t' && u[3]=='\0' && u[4]=='x');
    char v[10] = {'\0', 'x', 'x', 'x', 'x'};
    append(v, "cat");
    assert(v[0]=='c' && v[1]=='a' && v[2]=='t' && v[3] =='\0' && v[4]=='x');
}

// Tests 21 to 25
void testFind() {
    assert(find("cat", "cat") == 0);
    assert(find("cat", "c") == 0);
    assert(find("cat", "t") == 2);
    assert(find("cat", "x") == -1);
    assert(find("banana", "an") == 1);
}

// Test the functions.
int main() {
    testLength();
    testCopy();
    testCompare();
    testAppend();
    testFind();
    printf("Tests all pass.");
    return 0;
}
