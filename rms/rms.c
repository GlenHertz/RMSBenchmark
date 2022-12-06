#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

double rms(double xs[], double ys[], long N) {
    long i;
    double area, y1, y2, dx, dy, val;
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
    double tstop, dt, freq, t, val, ns;
    size_t element_size = sizeof tstop;
    double *xs, *ys, *results;
    clock_t t1, t2;

    /* generate a 1kHz sine wave from 0 to 1 second (with 1us steps): */
    N = 1000001;
    freq = 1000;
    tstop = 1/ (double) freq;
    dt = tstop / (double) (N-1);
    xs = malloc(N*element_size);
    ys = malloc(N*element_size);

    for (i = 0; i < N; i++) {
        t = dt * i;
        xs[i] = t;
        ys[i] = sin(2*M_PI*freq*t);
    }


    /* run benchmark */
    trials = 500;
    results = malloc(trials*element_size);
    val = rms(xs, ys, N);
    t1 = clock();
    for (i=0; i < trials; i++)
        results[i] = rms(xs, ys, N);
    t2 = clock();

    /* print out result to prevent constant folding */
    char fname[] = "results.bin";
    FILE * fp = fopen(fname, "wb");
    if (fp == NULL) { /* If an error occurs during the file creation */
        fprintf(stderr, "fopen() failed for '%s'\n", fname);
        return 1;
    } else {
        fwrite(results, element_size, trials, fp);
        fclose(fp);
    }

    ns = (double) (t2 - t1) / (double) CLOCKS_PER_SEC / (double) trials / (double) N * 1e9;
    printf("gcc %s             for rms=%.16f : %5.3f ns per iteration average over %ld trials of %ld points\n", VERSION, val, ns, trials, N);
    return 0;
}
