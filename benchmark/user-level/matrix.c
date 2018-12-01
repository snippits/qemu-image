#include "matrix.h"

void initialize_matrix(unsigned int **mat, unsigned int n)
{
    int i, j;

    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++) {
            mat[i][j] = rand() % 100;
        }
    }

    return;
}

void reset_matrix(unsigned int **mat, unsigned int n)
{
    int i, j;

    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++) {
            mat[i][j] = 0;
        }
    }

    return;
}

unsigned int **malloc_matrix(unsigned int n)
{
    unsigned int **mat_buff;
    int            i;

    mat_buff = (unsigned int **)malloc(sizeof(unsigned int *) * n);
    for (i = 0; i < n; i++) {
        mat_buff[i] = (unsigned int *)malloc(sizeof(unsigned int) * n);
    }
    return mat_buff;
}

void free_matrix(unsigned int **mat, unsigned int n)
{
    int i;

    for (i = 0; i < n; i++) {
        free(mat[i]);
    }
    free(mat);
}

void print_matrix(unsigned int **mat, unsigned int n)
{
    int i, j;

    printf("\n");
    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++) {
            printf("%d ", mat[i][j]);
        }
        printf("\n");
    }
    printf("\n");

    return;
}

void output_matrix(unsigned int **mat, unsigned int n, const char *filename)
{
    int   i, j;
    FILE *fp;

    fp = fopen(filename, "wt");
    if (fp == NULL) return;

    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++) {
            fprintf(fp, "%d ", mat[i][j]);
        }
        fprintf(fp, "\n");
    }

    fclose(fp);

    return;
}

void multiply_matrix(unsigned int **multiply,
                     unsigned int **first,
                     unsigned int **second,
                     unsigned int   n)
{
    int i, j, k;

    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++) {
            for (k = 0; k < n; k++) {
                multiply[i][j] += first[i][k] * second[k][j];
                // printf("i:%d j:%d k:%d", i, j, k);
            }
        }
    }

    return;
}
