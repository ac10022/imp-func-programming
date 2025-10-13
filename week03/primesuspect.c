/*
TASK: Find all prime numbers up to a given limit n by implementing the ‘Sieve of Eratosthenes’.

The Sieve of Eratosthenes is an algorithm that solves the prime problem. It gives each number a binary label and iteratively marks as ‘not prime’ the multiples of each prime, starting with the first prime number, 2. The multiples of a given prime are generated as numbers starting from that prime, with constant difference between them. This is faster than a trial division test, but not as fast as complicated modern algorithms such as the Sieve of Atkin.
*/

#include <stdbool.h>
#include <stdio.h>
#include <time.h>
#include <limits.h>

void printTrue(bool array[], int len) {
    for (int i = 0; i < len; i++)
        if (array[i]) printf("%d\t", i);   
    printf("\n");
}

void fillTrue(bool sieve[], int len) {
    for (int i = 0; i < len; i++)
        sieve[i] = true;
}

int sieve(int n) {
    int m = n + 1;    
    bool sieve[m];

    fillTrue(sieve, m);
    
    // defaults 
    sieve[0] = false;
    sieve[1] = false;
    
    for (int t = 2; t < (m + 1 / 2); t++)
    {
        if (!sieve[t]) continue;
        for (int i = 2*t; i < m; i += t)
        {
            sieve[i] = false;
        }   
    }

    printTrue(sieve, m);
}

int main(void) {
    clock_t begin = clock();

    int n = __INT16_MAX__;
    sieve(n);

    clock_t end = clock();
    double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;

    printf("Determined all primes <= %d in %lf seconds.\n", n, time_spent);

    return 0;
}

