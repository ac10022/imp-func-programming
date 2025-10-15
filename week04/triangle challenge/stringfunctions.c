int length(const char s[]);
void copy(char t[], const char s[]);
int compare(const char s[], const char t[]);
void append(char t[], const char s[]);
int find(const char t[], const char s[]);

int main(int n, char* args[/*n*/]) {
    return 0;
}

/// @brief Finds the length of a string.
/// @param s given string
/// @return An integer length of string s.
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

/// @brief Compares two different strings.
/// @param s first string
/// @param t second string
/// @return A value corresponding to the equality of the two strings: 0 indicates the two string are equal, 1 indicates the first string is greater than the second, -1 indicates the second string is greater than the first.
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

/// @brief Copies the value of one string into a second, overriding the second.
/// @param t destination string
/// @param s source string
void copy(char t[], const char s[]) {
    int slen = length(s);
    for (int i = 0; i < slen; i++)
        t[i] = s[i]; // for each char in s, copy this into t
}

/// @brief Finds a substring in a given string.
/// @param t string to search
/// @param s substring to find
/// @return An index corresponding to the first index of the first instance of the given substring in the string to search, or -1 if either the string to search was too short, or the substring could not be found. 
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

/// @brief Appends the contents of one string onto a second string.
/// @param t destination string
/// @param s source string to append
void append(char t[], const char s[]) {
    int tlen = length(t);
    int slen = length(s);

    // starting at the character succeeding the last in t, place the characters of s into t in order
    for (int i = tlen; i < tlen + slen; i++)
        t[i] = s[i - tlen];
}