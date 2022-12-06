import math
from numba import njit
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

# generate a 1kHz sine wave from 0 to 1 second (with 1us steps):
xs = np.linspace(0, 1, 1000001)
ys = np.sin(2*np.pi*1000*xs)
val = rms(xs, ys)


# Run benchmark
import time
trials=3800
t1 = time.time()
for i in range(trials):
    rms(xs, ys)
t2 = time.time()
N = len(xs)
ns = (t2 - t1)/trials/N * 1e9

import sys
ver = "{major}.{minor}.{micro}".format(major=sys.version_info[0], minor=sys.version_info[1], micro=sys.version_info[2])
print("Python {ver}     for(numba,np) rms = {val} : {t:>5} ns per iteration average over {trials} trials of {N:<3} points".format(ver=ver, val=val, t=round(ns,2), trials=trials, N=N))