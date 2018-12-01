#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <assert.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <time.h>
#include "matrix.h"

void do_foo(int SIZE)
{
    unsigned int **first;
    unsigned int **second;
    unsigned int **multiply;
    unsigned int   seed;

    seed = (unsigned)time(NULL);
    srand(seed);

    first = malloc_matrix(SIZE);
    initialize_matrix(first, SIZE);

    second = malloc_matrix(SIZE);
    initialize_matrix(second, SIZE);

    multiply = malloc_matrix(SIZE);
    reset_matrix(multiply, SIZE);

    multiply_matrix(multiply, first, second, SIZE);
    // print_matrix(multiply, SIZE);

    free_matrix(first, SIZE);
    free_matrix(second, SIZE);
    free_matrix(multiply, SIZE);
}

void main()
{
    printf("sleep!\n");
    sleep(5);
    printf("fork!\n");
    pid_t pid      = fork();
    char *args[64] = {NULL};

    printf("%lu\n", pid);

    if (pid == -1) {
        printf("error, failed to fork()");
    } else if (pid > 0) {
        do_foo(1000);
        int status;
        waitpid(pid, &status, 0);
    } else {
        // we are the child

        do_foo(1000);
        char *name[] = {"bash", "-c", "echo 'Hello World'", NULL};
        execvp(name[0], name);
        _exit(EXIT_FAILURE); // exec never returns
    }
}
