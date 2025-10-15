/*
TASK. Write a tiny program self.c that declares a void pointer array of 8 elements. Initialise each pointer element with its own memory address. Write a procedure shuffle(…) that randomly permutates the values of the pointers in the array. Write a procedure test(…) that checks if all pointers in the array point to themselves. Print how often (after the first shuffle) do you have to shuffle, on average, to see all pointers pointing to themselves again? Test your program well.
*/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <stdbool.h>

#define ARRAY_LEN 8
#define TEST_COUNT 10000

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
    for (int i = 0; i < len; i++)
        printf("a[%d] -> %p -> (actual address) -> %p\n", i, arr[i], &arr[i]);
    printf("\n");
}

bool checkCorrectPointers(void **arr, int len) {
    for (int i = 0; i < len; i++)
        if (!(arr[i] == &arr[i])) return false;
    return true;
}

int orderReorder(void **a) {
    int tally = 0;

    bool ordered = false;
    while (!ordered) {
        tally++;
        shuffle(a, ARRAY_LEN);
        ordered = checkCorrectPointers(a, ARRAY_LEN);
    }
    
    printf("Took %d shuffles to reorder list.\n", tally);
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
        tests[i] = orderReorder(a);
    
    printf("On average takes %d shuffles to reorder list.\n", averageList(tests, TEST_COUNT));
    
    return 0;
}


