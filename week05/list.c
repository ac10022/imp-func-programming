#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

typedef int item;

typedef struct list {
    int length;
    int max_capacity;
    item *items;
} list;

void error(const char* msg) {
    printf("Error: %s\n", msg);
    exit(1);
}

list* createList(int capacity) {
    list* new_list = (list*)malloc(sizeof(list));
    new_list->items = (item*)malloc(capacity * sizeof(item));
    new_list->length = 0;
    new_list->max_capacity = capacity;
    return new_list;
}

int length(list* l) {
    if (l != NULL) return l->length;
    else error("length: List has not been initialised; cannot get length.");
}

item get(list* l, int index) {
    if (index < length(l) && 0 <= index) {
        return (l->items)[index];
    }
    else error("get: Index out of bounds of list; cannot get item.");
}

void set(list* l, int index, item n) {
    if (index < length(l) && 0 <= index) {
        (l->items)[index] = n;
    }
    else error("set: Index out of bounds of list; cannot set item.");
}

void insert(list *l, int index, item n) {
    if (l == NULL) error("insert: List is uninitialised; cannot insert item.");
    int len = length(l);
    if (len >= l->max_capacity) expand(l);
    if (index < 0 || index > len) error("insert: Index for insertion is out of bounds of list; cannot insert item.");
    for (int i = len; index < i; i--)
    {
        l->items[i] = l->items[i-1];
    }
    l->items[index] = n;
    (l->length)++;
}

void delete(list* l, int index) {
    if (l == NULL) error("delete: List is uninitialised; cannot delete item.");
    int len = length(l);
    if (index < 0 || index >= len) error("delete: Index of deletion is out of bounds of list; cannot delete item");
    for (int i = index; i < len; i++)
    {
        l->items[i] = l->items[i+1];
    }
    l->length--;   
}

bool check(list* l, int n, item target[/*n*/]) {
    if (l->length != n) return false;
    if (l->max_capacity < n) return false;
    for (int i = 0; i < n; i++)
    {
        if (l->items[i] != target[i]) return false;
    }
    return true;
}

void append(list* l, item new_item) {
    int len = l->length;
    int cap = l->max_capacity;
    if (len >= cap) {
        expand(l);
    }
    (l->items)[len] = new_item;
    (l->length)++;
}

void expand(list* l) {
    // increase size by 100%
    l->max_capacity *= 2;
    l->items = (item*)realloc(l->items, l->max_capacity * sizeof(item));
}

int main(void) {
    list* l = createList(10);
    append(l, (item)3);
    item res = get(l, 0);
    printf("%d\n", res);
    printf("%d\n", length(l));
    return 0;
}