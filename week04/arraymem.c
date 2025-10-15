/*
TASK. Write a tiny program arraymem.c that declares two void pointer arrays a and b with 10 elements each. Initialise the arrays in a way that each of the pointers in a holds the address of its corresponding pointer in b (i.e. with the same array index) and vice versa. Print the two arrays and convince yourself that arrays are indeed stored in continuous memory locations.
*/

#include <stdlib.h>
#include <stdio.h>

#define ARR_LENGTH 10

int main(void) {
    void *a[ARR_LENGTH];
    void *b[ARR_LENGTH];

    for (size_t i = 0; i < (size_t)ARR_LENGTH; i++)
    {
        a[i] = &b[i];
        b[i] = &a[i];
    }

    for (size_t i = 0; i < (size_t)ARR_LENGTH; i++)
    {
        printf("a[%zu] has pointer %p\nb[%zu] has pointer %p\n", i, a[i], i, b[i]);
    }
    
    return 0;
}