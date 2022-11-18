import math

def rms(xs, ys):
    if len(xs) != len(ys):
        raise Exception("dimension mismatch")
    area = 0.0
    for i in range(1,len(xs)):
        dx = xs[i] - xs[i-1]
        y1 = ys[i-1]
        y2 = ys[i]
        dy = y2 - y1
        area += dx*(dy**2/3.0 + y1*y2)
    return math.sqrt(area/(xs[-1] - xs[0]))


rms([1, 1.5, 2, 3], [-1, 0, 1, -1])
# Create sine wave:
N = 10**6 + 1
tstop = 1e-3
dt = tstop/(N-1)
xs = [dt*i for i in range(N)]
freq = 1000
ys = [math.sin(2*math.pi*freq*x) for x in xs]
#print("first (x,y) = (", xs[0], ", ", ys[0], ")")
#print("last (x,y) = (", xs[-1], ", ", ys[-1], ")")

# Run benchmark
import time
val = rms(xs, ys)
trials=38
tbegin = time.time()
for i in range(trials):
    rms(xs, ys)
tdone = time.time()

ns = (tdone - tbegin)/trials/N * 1e9

import sys
ver = "{major}.{minor}.{micro}".format(major=sys.version_info[0], minor=sys.version_info[1], micro=sys.version_info[2])
print("Python {ver}     for           rms = {val} : {t:>5} ns per iteration average over {trials:>3} trials of {N} points".format(ver=ver, val=val, t=round(ns,1), trials=trials, N=N))


