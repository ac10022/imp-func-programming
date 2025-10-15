/*
TASK. Write a tiny program ring.c that declares a void pointer array of 8 elements. Initialise each pointer element with its own memory address. Copy-in your procedure shuffle(…) from the task above that randomly permutates the values of the pointers in the array. Then write a procedure cycle(…) that checks if the pointers in the array point to each other in such a way that one can reach all elements of the array by sequentially following pointer links starting at any element (i.e. forming a pointer cycle). Print out how often you have to shuffle, on average, until you see the first pointer cycle occurring? Test your program well.
*/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <stdbool.h>
#include <stddef.h>

#define ARRAY_LEN 8
#define TEST_COUNT 100000

void swap(void **arr, int index1, int index2) {
    void* temp = arr[index1];
    arr[index1] = arr[index2];
    arr[index2] = temp;
}

void shuffle(void **arr, int len) {
    while (len > 1) {
        int j = (rand() % len);
        len--;
        swap(arr, len, j);
    }
}

void printArray(void **arr, int len) {
    printf("\n");
    for (int i = 0; i < len; i++)
        printf("a[%d] -> %p -> (actual address) -> %p\n", i, arr[i], &arr[i]);
    printf("\n");
}

bool truthFold(bool* arr, int len) {
    for (int i = 0; i < len; i++)
        if (!arr[i]) return false;
    return true;
}

bool checkCyclicPointers(void **arr, int len) {
    bool reached[len];
    for (int i = 0; i < len; i++)
        reached[i] = false;
    
    void* ptr = arr[0];
    void** base = arr;

    for (int i = 0; i < len; i++)
    {
        ptrdiff_t index = (void **)ptr - base;
        if (reached[index]) return false; // already visited before
        reached[index] = true;
        ptr = *(void **)ptr;
    }

    return truthFold(reached, len);
}

int orderCyclic(void **a) {
    int tally = 0;

    bool ordered = false;
    while (!ordered) {
        tally++;
        shuffle(a, ARRAY_LEN);
        ordered = checkCyclicPointers(a, ARRAY_LEN);
    }

    //printArray(a, ARRAY_LEN);
    
    printf("Took %d shuffles to generate a cyclic list.\n", tally);
    return tally;
}

int averageList(int* arr, int len) {
    int tally = 0;
    for (int i = 0; i < len; i++)
        tally += arr[i];
    return tally / len;
}

int main(void) {
    srand(time(NULL)); // seed random
    
    // initialise
    void *a[ARRAY_LEN];
    for (int i = 0; i < ARRAY_LEN; i++)
        a[i] = &a[i];

    int tests[TEST_COUNT];

    for (int i = 0; i < TEST_COUNT; i++)
        tests[i] = orderCyclic(a);
    
    printf("On average takes %d shuffles to generate a cyclic list.\n", averageList(tests, TEST_COUNT));
    
    return 0;
}