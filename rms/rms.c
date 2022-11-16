#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

double rms(double xs[], double ys[], long N) {
    long i;
    double area, x1, y1, x2, y2, dx, dy, val;

    area = 0.0;
    for (i=1; i < N; i++) {
        dx = xs[i] - xs[i-1];
        y1 = ys[i-1];
        y2 = ys[i];
        dy = y2 - y1;
        area += dx*(pow(dy,2)/3.0 + y1*y2);
    }
    val = sqrt(area/(xs[N-1] - xs[0]));
    return val;
}


int main() {
    /* declare variables: */
    long i, trials, N;
    double tstop, dt, freq, t;
    double val;
    double *xs;
    double *ys;
    clock_t t1, t2;
    double ns;

    /* Create sine wave */
    N = 1000001;
    freq = 1000;
    tstop = 1/ (double) freq;
    dt = tstop / (double) (N-1);
    xs = malloc(N*sizeof(double));
    ys = malloc(N*sizeof(double));

    for (i = 0; i < N; i++) {
        t = dt * i;
        xs[i] = t;
        ys[i] = sin(2*M_PI*freq*t);
    }

    /* run benchmark */
    trials = 500;
    val = rms(xs, ys, N);
    t1 = clock();
    for (i=0; i < trials; i++)
        rms(xs, ys, N);
    t2 = clock();
    ns = (double) (t2 - t1) / (double) CLOCKS_PER_SEC / (double) trials / (double) N * 1e9;
    printf("gcc    %s    for           rms = %.16f : %5.1f ns per iteration average over %ld trials of %ld points\n", VERSION, val, ns, trials, N);
    return 0;
}

/*
Compiling with the following segfaults:
rm -f rms
gcc -Wall -g rms.c -lm -o rms &&
./rms
*/
