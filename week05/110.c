/*
TASK. An elementary cellular automaton consists of a 1D array with possible states 0 and 1 per element and a set of rules that maps from this array to a new array. The rule to determine the state of an element in the next generation depends only on the current state of the element and its two immediate neighbors. In 2004, Matthew Cook proved that a particular cellular automaton called ‘Rule 110’ is capable of universal computation. Research the ‘Rule 110’ automaton and write a small program 110.c that calculates and prints the evolution of the array line-by-line. As illustrated on the next slide. Test your program well.
*/

#include <stdio.h>

#define START_STATE 32768
#define MSB (-2147483648)

// we can represent the current state of 32 bits using a 32 bit integer

int stepState(int state) {
    int new_state = 0;
    for (int i = 31; i >= 0; i--) // for all 32 bits in the curr state
    {
        int l_index = (i == 0) ? 31 : (i - 1); // index of bit on the left of cur bit
        int r_index = (i == 31) ? 0 : (i + 1); // index of bit on the right of cur bit

        int l = (state & (1ULL << l_index)) >> l_index; // get bit on left of cur bit
        int c = (state & (1ULL << i)) >> i; // get cur bit
        int r = (state & (1ULL << r_index)) >> r_index; // get bit on right of cur bit

        int index = (l << 2) | (c << 1) | r; // marge bits together to 3 contiguous bits
        int new_bit = (110 >> index) & 1; // apply rule (110) and take the lsb

        new_state |= ((int)new_bit << i); // push new bit onto new state
    }
    return new_state;
}

void printState(int state) {
    for (int i = 31; i >= 0; i--) {
        int bit = (state >> i) & 1;
        printf("%d", bit);
    }
    printf("\n");
}

int main(void) {
    int state = START_STATE;
    printState(state);
    for (int i = 0; i < 15; i++)
    {
        state = stepState(state);
        printState(state);
    }
    return 0;
}