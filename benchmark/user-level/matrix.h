#ifndef __MATRIX_H_
#define __MATRIX_H_

#include <stdio.h>
#include <stdlib.h>

void initialize_matrix(unsigned int **mat, unsigned int n);
void reset_matrix(unsigned int **mat, unsigned int n);
void free_matrix(unsigned int **mat, unsigned int n);
void print_matrix(unsigned int **mat, unsigned int n);
void output_matrix(unsigned int **mat, unsigned int n, const char *filename);
void multiply_matrix(unsigned int **multiply,
                     unsigned int **first,
                     unsigned int **second,
                     unsigned int   n);

unsigned int **malloc_matrix(unsigned int n);
#endif
