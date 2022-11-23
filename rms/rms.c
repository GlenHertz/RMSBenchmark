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
    double tstop, dt, freq, t;
    size_t element_size = sizeof tstop;
    double val;
    double *xs_gen;
    double *ys_gen;
    double *xs;
    double *ys;
    double *results;
    clock_t t1, t2;
    double ns;

    /* Create sine wave */
    N = 1000001;
    freq = 1000;
    tstop = 1/ (double) freq;
    dt = tstop / (double) (N-1);
    xs_gen = malloc(N*sizeof(double));
    ys_gen = malloc(N*sizeof(double));
    xs = malloc(N*sizeof(double));
    ys = malloc(N*sizeof(double));

    for (i = 0; i < N; i++) {
        t = dt * i;
        xs_gen[i] = t;
        ys_gen[i] = sin(2*M_PI*freq*t);
    }

    /* write to file to prevent constant folding */
    char file_name[] = "xs_ys.bin";
    FILE * fp;

    fp = fopen(file_name, "wb");
    if (fp == NULL) { /* If an error occurs during the file creation */
        fprintf(stderr, "fopen() failed for '%s'\n", file_name);
        return 1;
    } else {
        fwrite(xs_gen, element_size, N, fp);
        fwrite(ys_gen, element_size, N, fp);
        fclose(fp);
    }

    fp = fopen(file_name, "r");
    if (fp == NULL) { /* If an error occurs during the file creation */
        fprintf(stderr, "fopen() failed for '%s'\n", file_name);
        return 1;
    } else {
        fread(xs, element_size, N, fp);
        fread(ys, element_size, N, fp);
        fclose(fp);
    }

    /* run benchmark */
    trials = 500;
    results = malloc(trials*sizeof(double));
    val = rms(xs, ys, N);
    t1 = clock();
    for (i=0; i < trials; i++)
        results[i] = rms(xs, ys, N);
    t2 = clock();
    char file_name2[] = "results.bin";
    fp = fopen(file_name2, "wb");
    if (fp == NULL) { /* If an error occurs during the file creation */
        fprintf(stderr, "fopen() failed for '%s'\n", file_name2);
        return 1;
    } else {
        fwrite(results, element_size, trials, fp);
        fclose(fp);
    }

    ns = (double) (t2 - t1) / (double) CLOCKS_PER_SEC / (double) trials / (double) N * 1e9;
    printf("gcc %s             for rms=%.16f : %8.7f ns per iteration average over %ld trials of %ld points\n", VERSION, val, ns, trials, N);
    return 0;
}
