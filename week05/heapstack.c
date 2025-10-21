/*
TASK. Write a tiny program heapstack.c that shows that the heap and the stack grow in different directions. The easiest way to show this is by printing memory addresses of successive allocations on the heap and the stack, respectively.
*/

#include <stdio.h>
#include <stdlib.h>

void recursive(int n) {
    if (n == 0) return;
    int demo_var;
    printf("Address of demo_var (%d) -> %p\n", 5-n, (void*)&demo_var);
    return recursive(n-1);
}

int main(void) {
    int *heap_1 = (int*)malloc(sizeof(int));
    int *heap_2 = (int*)malloc(sizeof(int));
    int *heap_3 = (int*)malloc(sizeof(int));
    int *heap_4 = (int*)malloc(sizeof(int));
    int *heap_5 = (int*)malloc(sizeof(int));

    void* ptrs[5] = { (void*)heap_1, (void*)heap_2, (void*)heap_3, (void*)heap_4, (void*)heap_5 };

    for (size_t i = 0; i < 5; i++)
    {
        printf("Address of heap_%d -> %p\n", i, ptrs[i]);
    }

    recursive(5);
    
    return 0;
}