import math
from numba import jit, njit, float64
import numpy as np

@njit
def rms(xs, ys):
    area = 0.0
    for i in range(1,len(xs)):
        dx = xs[i] - xs[i-1]
        y1 = ys[i-1]
        y2 = ys[i]
        dy = y2 - y1
        area += dx*(dy**2/3 + y1*y2)
    return math.sqrt(area/(xs[-1] - xs[0]))


# A triangular wave has an RMS of Peak/sqrt(3)
N = 10**6
dt = 1/N
xs = [dt * i for i in range(N+1)]
ys = xs


# Run benchmark
import time
val = rms(xs, ys) # warm up
trials=20
times = []
tbegin = time.time()
for i in range(trials):
    rms(xs, ys)
tdone = time.time()

ns = (tdone - tbegin)/trials/N * 1e9

print("RMS of trangular wave: {val} (ans = {ans})".format(val=rms(xs, ys), ans=1/math.sqrt(3)))

import sys
ver = "{major}.{minor}.{micro}".format(major=sys.version_info[0], minor=sys.version_info[1], micro=sys.version_info[2])
print("Python {ver}     for(numba)    rms = {val} : {t:>5} ns per iteration average over {trials:>3} trials of {N} points".format(ver=ver, val=val, t=round(ns,2), trials=trials, N=N))