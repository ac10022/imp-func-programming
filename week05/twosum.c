#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
int* twoSum(int* nums, int numsSize, int target, int* returnSize) {
    int abs_t = abs(target);
    *returnSize = 2;
    int * res = (int*)malloc(*returnSize * sizeof(int));
    int fst = -1;
    int snd = -1;
    for (int i = 0; i < numsSize - 1; i++)
    {
        fst = nums[i];
        for (int j = i + 1; j < numsSize; j++)
        {
            snd = nums[j];
            if (fst + snd == target) {
                res[0] = i;
                res[1] = j;
                return res;
            }
        }
    }
    return res;
}

int main(void) {
    int numsSize = 3;
    int * nums = (int*)malloc(numsSize * sizeof(int));
    int returnSize = 0;
    nums[0] = 3;
    nums[1] = 2;
    nums[2] = 4;
    int target = 6;
    int * res = twoSum(nums, numsSize, target, &returnSize);
    int ok = res[0] == 1 && res[1] == 2 && returnSize == 2;
    if (ok) {
        printf("OK\n");
    }
    else {
        printf("NO\n");
    }
    free(res);
    free(nums);
    return 0;
}