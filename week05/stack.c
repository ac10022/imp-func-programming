#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct stackelem {
    int value;
    struct stackelem *prev;
} Elem;

typedef struct stack {
    Elem *top;
} Stack;

Stack *newStack() {
    // allocate memory for a stack
    Stack *s = (Stack*)malloc(sizeof(Stack));

    // set the top element of the stack to NULL
    s->top = NULL;

    // return the stack
    return s;
}

void pushStack(Stack *s, int elem) {
    // turn elem into an Elem type
    Elem *new_elem;
    new_elem = (Elem*)malloc(sizeof(Elem));

    // push the elem to the top of the list, i.e. put the previous top element as the previous element of the new element
    new_elem->prev = s->top;

    // put this new element at the top of the stack
    s->top = new_elem;

    // set the value of this new element to the argument of the function
    s->top->value = elem;
}

int isEmpty(Stack *s) {
    // empty if the top element is NULL
    return s->top == NULL;
}

int peekStack(Stack *s) {
    // if stack empty, return min int
    if (isEmpty(s)) return -2147483647; 
    
    // return the value held at the top of the stack
    return s->top->value;
}

int popStack(Stack *s) {
    // if the top is empty return min int
    if (isEmpty(s)) return -2147483647;
    
    // otherwise get value held by elem at top of stack
    int val = peekStack(s);

    // get top of stack and second top of stack
    Elem* curr = s->top;
    Elem* prev = s->top->prev;

    // free top of stack
    free(curr);

    // set the new top of stack to the second top of stack
    s->top = prev;

    // return the value which was previously held at the top of the stack
    return val;
}

void freeStack(Stack *s) {
    // while the stack is not empty, keep popping elements
    while (!isEmpty(s)) {
        popStack(s);
    }
    
    // once the stack is empty, free the memory allocated to the stack
    free(s);
}

int main(void) {
    Stack *s = newStack();
    
    for (int i = 0; i < 10; i++)
    {
        pushStack(s, i);
    }

    printf("Top element of stack: %d, popped.\n", popStack(s));

    if (!isEmpty(s)) {
        printf("Stack is not empty.\n");
    }
    else {
        printf("Stack is empty.\n");
    }

    printf("Top element of the stack (peek): %d\n", peekStack(s));

    printf("Clearning the stack.\n");
    freeStack(s);
    
    return 0;
}