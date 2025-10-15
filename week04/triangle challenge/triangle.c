/* Classify a triangle according to the integer lengths of its sides. */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdbool.h>
#include <limits.h>
#include <math.h>

bool validPosIntString(int n, char input[]) {
    // only accept integers which contain exclusively digits, i.e. no decimal points
    bool valid = true;
    while (n-- && valid) {
        char cur = input[n];
        if (cur < '0' || cur > '9') valid = false;
    }
    return valid;
}

int stringToInt(char input[]) {
    // we have 0 is invalid for this program
    if (input == "0") return -1;

    int inputLength = strlen(input);
    
    if (inputLength > 10) {
        // we have the input uses more digits than integer limit, this is erroneous
        return -1;
    } 
    else if (inputLength == 10 && (input[0] > '2' && input[0] <= '9')) {
        // too large for int to hold, in the case that the we still have an int too large with the given digits, it will be caught later with the overflow check.
        return -1;
    }
    else if (inputLength != 1 && input[0] == '0') {
        // not just integer 0 and has more than one digit, leading 0s disallowed
        return -1;
    }

    int sum = 0;
    // if we have a valid integer
    if (validPosIntString(inputLength, input)) {
        for (int i = 0; i < inputLength; i++)
            sum = sum * 10 + (input[i] - '0');
    }
    else {
        return -1; // else we have an invalid integer
    }

    // if the sum overflows, we were given an invalid integer
    if (sum < 0) {
        return -1; 
    }
    
    return sum;
}

// Integer constants representing types of triangle.
enum { Equilateral, Isosceles, Right, Scalene, Flat, Impossible, Illegal };

// Convert a string into an integer.  Return -1 if it is not valid.
int convert(const char str[]) {
    return stringToInt(str);
}

// Classify a triangle, given side lengths as strings:
int triangle(int a, int b, int c) {
    // if any inputs are invalid, then the triangle is illegal
    if (a == -1 || b == -1 || c == -1) return Illegal;

    // introduce long variables to check sums and products without overflow 
    long la = (long)a;
    long lb = (long)b;
    long lc = (long)c;

    // we order a, b, c in ascending order, so that a is the smallest, c is the largest
    if (la > lb) {
        // switch variables
        la += lb;
        lb = la - lb;
        la -= lb;
    }
    if (lb > lc) {
        // switch variables
        lb += lc;
        lc = lb - lc;
        lb -= lc;
    }
    // c is now in correct position
    if (la > lb) {
        // switch variables
        la += lb;
        lb = la - lb;
        la -= lb;
    }
    // a and b are now in correct position

    // for triangle inequality we need a + b > c, so if not triangle is impossible
    if (la + lb < lc) return Impossible;

    // from now on, triangles are valid
    // if sides are equliateral, all sides are the same
    if (la == lb && lb == lc) return Equilateral;

    // if the two shorter sides add to the longer side, the triangle is flat
    if (la + lb == lc) return Flat;

    // a triangle with integral sides which is right cannot also be isosceles, as root 2 is irrational, checking order does not matter, but we check isosceles first as this is less computationally intensive

    // if two sides are the same, the triangle is isosceles
    if (la == lb || la == lc || lb == lc) return Isosceles;

    // necessarily c is the longest side, so a^2 + b^2 = c^2 is the only check we need to make to prove a right angle
    if (la * la + lb * lb == lc * lc) return Right;

    // if all other conditions are not met, the triangle is still valid, so the triangle must be scalene
    return Scalene;
}

// -----------------------------------------------------------------------------
// User interface and testing.

void print(int type) {
    switch (type) {
        case Equilateral: printf("Equilateral"); break;
        case Isosceles: printf("Isosceles"); break;
        case Right: printf("Right"); break;
        case Scalene: printf("Scalene"); break;
        case Flat: printf("Flat"); break;
        case Impossible: printf("Impossible"); break;
        case Illegal: printf("Illegal"); break;
    }
    printf("\n");
}

// A replacement for the library assert function.
void assert(int line, bool b) {
    if (b) return;
    printf("The test on line %d fails.\n", line);
    exit(1);
}

// Check that you haven't changed the triangle type constants.  (If you do, it
// spoils automatic marking, when your program is linked with a test program.)
void checkConstants() {
    assert(__LINE__, Equilateral==0 && Isosceles==1 && Right==2 && Scalene==3);
    assert(__LINE__, Flat==4 && Impossible==5 && Illegal==6);
}

// Tests 1 to 2: check equilateral
void testEquilateral() {
    assert(__LINE__, triangle(8, 8, 8) == Equilateral);
    assert(__LINE__, triangle(1073, 1073, 1073) == Equilateral);
}

// Tests 3 to 5: check isosceles
void testIsosceles() {
    assert(__LINE__, triangle(25, 25, 27) == Isosceles);
    assert(__LINE__, triangle(25, 27, 25) == Isosceles);
    assert(__LINE__, triangle(27, 25, 25) == Isosceles);
}

// Tests 6 to 14: check right angled
void testRight() {
    assert(__LINE__, triangle(3, 4, 5) == Right);
    assert(__LINE__, triangle(3, 5, 4) == Right);
    assert(__LINE__, triangle(5, 3, 4) == Right);
    assert(__LINE__, triangle(5, 12, 13) == Right);
    assert(__LINE__, triangle(5, 13, 12) == Right);
    assert(__LINE__, triangle(12, 5, 13) == Right);
    assert(__LINE__, triangle(12, 13, 5) == Right);
    assert(__LINE__, triangle(13, 5, 12) == Right);
    assert(__LINE__, triangle(13, 12, 5) == Right);
}

// Tests 15 to 20: check scalene
void testScalene() {
    assert(__LINE__, triangle(12, 14, 15) == Scalene);
    assert(__LINE__, triangle(12, 15, 14) == Scalene);
    assert(__LINE__, triangle(14, 12, 15) == Scalene);
    assert(__LINE__, triangle(14, 15, 12) == Scalene);
    assert(__LINE__, triangle(15, 12, 14) == Scalene);
    assert(__LINE__, triangle(15, 14, 12) == Scalene);
}

// Tests 21 to 25: check flat
void testFlat() {
    assert(__LINE__, triangle(7, 9, 16) == Flat);
    assert(__LINE__, triangle(7, 16, 9) == Flat);
    assert(__LINE__, triangle(9, 16, 7) == Flat);
    assert(__LINE__, triangle(16, 7, 9) == Flat);
    assert(__LINE__, triangle(16, 9, 7) == Flat);
}

// Tests 26 to 31: check impossible
void testImpossible() {
    assert(__LINE__, triangle(2, 3, 13) == Impossible);
    assert(__LINE__, triangle(2, 13, 3) == Impossible);
    assert(__LINE__, triangle(3, 2, 13) == Impossible);
    assert(__LINE__, triangle(3, 13, 2) == Impossible);
    assert(__LINE__, triangle(13, 2, 3) == Impossible);
    assert(__LINE__, triangle(13, 3, 2) == Impossible);
}

// Tests 32 to 44: check conversion.
// Leading zeros are disallowed because thy might be mistaken for octal.
void testConvert() {
    assert(__LINE__, convert("1") == 1);
    assert(__LINE__, convert("12345678") == 12345678);
    assert(__LINE__, convert("2147483647") == 2147483647);
    assert(__LINE__, convert("2147483648") == -1);
    assert(__LINE__, convert("2147483649") == -1);
    assert(__LINE__, convert("0") == -1);
    assert(__LINE__, convert("-1") == -1);
    assert(__LINE__, convert("-2") == -1);
    assert(__LINE__, convert("-2147483648") == -1);
    assert(__LINE__, convert("x") == -1);
    assert(__LINE__, convert("4y") == -1);
    assert(__LINE__, convert("13.4") == -1);
    assert(__LINE__, convert("03") == -1);
}

// Tests 45 to 50: check for correct handling of overflow
void testOverflow() {
    assert(__LINE__, triangle(2147483647,2147483647,2147483646) == Isosceles);
    assert(__LINE__, triangle(2147483645,2147483646,2147483647) == Scalene);
    assert(__LINE__, triangle(2147483647,2147483647,2147483647) == Equilateral);
    assert(__LINE__, triangle(1100000000,1705032704,1805032704) == Scalene);
    assert(__LINE__, triangle(2000000001,2000000002,2000000003) == Scalene);
    assert(__LINE__, triangle(150000002,666666671,683333338) == Scalene);
}

// Run tests on the triangle function.
void test() {
    checkConstants();
    testEquilateral();
    testIsosceles();
    testRight();
    testScalene();
    testFlat();
    testImpossible();
    testConvert();
    testOverflow();
    printf("All tests passed\n");
}

// Run the program or, if there are no arguments, test it.
int main(int n, char *args[n]) {
    setbuf(stdout, NULL);
    if (n == 1) {
        test();
    }
    else if (n == 4) {
        int a = convert(args[1]), b = convert(args[2]), c = convert(args[3]);
        int result = triangle(a, b, c);
        print(result);
    }
    else {
        fprintf(stderr, "Use e.g.: ./triangle 3 4 5\n");
        exit(1);
    }
    return 0;
}
