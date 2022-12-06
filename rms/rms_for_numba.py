import math
from numba import njit
from numba.typed import List

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

# generate a 1kHz sine wave from 0 to 1 second (with 1us steps):
xs = List([i/(10**6) for i in range(10**6+1)])
ys = List([math.sin(2*math.pi*1000*x) for x in xs])
val = rms(xs, ys)


# Run benchmark
import time
trials=38
times = []
tbegin = time.time()
for i in range(trials):
    rms(xs, ys)
tdone = time.time()
N = len(xs)
ns = (tdone - tbegin)/trials/N * 1e9

print("RMS of trangular wave: {val} (ans = {ans})".format(val=rms(xs, ys), ans=1/math.sqrt(3)))

import sys
ver = "{major}.{minor}.{micro}".format(major=sys.version_info[0], minor=sys.version_info[1], micro=sys.version_info[2])
print("Python {ver}     for(numba)    rms = {val} : {t:>5} ns per iteration average over {trials:>3} trials of {N} points".format(ver=ver, val=val, t=round(ns,2), trials=trials, N=N))