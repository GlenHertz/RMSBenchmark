import math
import numpy as np

def rms(xs, ys):
    if len(xs) != len(ys):
        raise Exception("dimension mismatch")
    xs1 = xs[0:-2]
    ys1 = ys[0:-2]
    xs2 = xs[1:-1]
    ys2 = ys[1:-1]
    dx = xs2 - xs1
    dy = ys2 - ys1
    areas = dx*(dy**2/3 + ys1*ys2)
    area = areas.sum()
    return math.sqrt(area/(xs[-1] - xs[0]))

# generate a 1kHz sine wave from 0 to 1 second (with 1us steps):
xs = np.linspace(0, 1, 1000001)
ys = np.sin(2*np.pi*1000*xs)
val = rms(xs, ys)



# Run benchmark
import time
val = rms(xs, ys)
trials=38
t1 = time.time()
for i in range(trials):
    rms(xs, ys)
t2 = time.time()
N=len(xs)
ns = (t2 - t1)/trials/N * 1e9

import sys
ver = "{major}.{minor}.{micro}".format(major=sys.version_info[0], minor=sys.version_info[1], micro=sys.version_info[2])
print("Python {ver}     array(numpy)  rms = {val} : {t:>5} ns per iteration average over {trials:>3} trials of {N} points".format(ver=ver, val=val, t=round(ns,1), trials=trials, N=N))