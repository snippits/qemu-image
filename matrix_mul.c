#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define SIZE 200

void initialize_array(unsigned int **mat)
{
    int i, j;

    for(i = 0; i < SIZE; i++) {
        for(j = 0; j < SIZE; j++) {
            mat[i][j] = rand();
        }
    }

    return ;
}

void clean_array(unsigned long long **mat)
{
    int i, j;

    for(i = 0; i < SIZE; i++) {
        for(j = 0; j < SIZE; j++) {
            mat[i][j] = 0;
        }
    }

    return ;
}

void multiply_array(unsigned long long **multiply, unsigned int **first, unsigned int **second)
{
    int i, j, k;

    for(i = 0; i < SIZE; i++) {
        for(j = 0; j < SIZE; j++) {
            for(k = 0; k < SIZE; k++) {
                multiply[i][j] += first[i][k] * second[k][j];
                //printf("i:%d j:%d k:%d", i, j, k);
            }
        }
    }

    return ;
}


int main()
{
    unsigned int **first;
    unsigned int **second;
    unsigned long long **multiply;
    int i, j;
    unsigned int seed;
    seed = (unsigned)time(NULL);
    srand(seed);

    second=(unsigned int**)malloc(sizeof(unsigned int*) * SIZE);
    first=(unsigned int**)malloc(sizeof(unsigned int*) * SIZE);
    multiply=(unsigned long long**)malloc(sizeof(unsigned long long*) * SIZE);
    for(i = 0; i < SIZE; i++) {
        second[i] = (unsigned int *)malloc(sizeof(unsigned int) * SIZE);
        first[i] = (unsigned int *)malloc(sizeof(unsigned int) * SIZE);
        multiply[i] = (unsigned long long *)malloc(sizeof(unsigned long long) * SIZE);
        for(j = 0; j < SIZE; j++) {
            second[i][j] = rand();
            //printf("i:%d j:%d", i, j);
        }
    }
    initialize_array(first);
    initialize_array(second);
    clean_array(multiply);
    multiply_array(multiply, first, second);

    for(i = 0; i < SIZE; i++) {
        free(first[i]);
        free(second[i]);
        free(multiply[i]);
    }
    free(first);
    free(second);
    free(multiply);

    return 0;
}

