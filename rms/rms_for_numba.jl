using PyCall

py"""
import math
from numba import jit, njit, float64
from numba.typed import List
import numpy as np

@njit
def rms(xs, ys):
    area = 0.0
    for i in range(1,len(xs)):
        x1 = xs[i-1]
        y1 = ys[i-1]
        x2 = xs[i]
        y2 = ys[i]
        dx = x2 - x1
        dy = y2 - y1
        area += dx*(dy**2/3 + y1*y2)
    return math.sqrt(area/(xs[-1] - xs[0]))




# Create sine wave
N=10**6 + 1
freq = 1000
tstop = 1/freq
dt = tstop/(N-1)
xs = List([dt * i for i in range(N)])
ys = List([math.sin(2*math.pi*freq*x) for x in xs])




# Run benchmark
import time
val = rms(xs, ys)
trials=380
t1 = time.time()
for i in range(trials):
    rms(xs, ys)
t2 = time.time()
ns = (t2 - t1)/trials/N * 1e9

import sys
ver = "{major}.{minor}.{micro}".format(major=sys.version_info[0], minor=sys.version_info[1], micro=sys.version_info[2])
print("Python {ver}     for(numba)    rms = {val} : {t:>5} ns per iteration average over {trials} trials of {N:<3} points".format(ver=ver, val=val, t=round(ns,1), trials=trials, N=N))
"""