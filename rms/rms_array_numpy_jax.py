import jax.numpy as jnp
from jax import jit

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
    return jnp.sqrt(area/(xs[-1] - xs[0]))


# Create sine wave
N=10**6 + 1
freq = 1000
tstop = 1/freq
dt = tstop/(N-1)
xs = jnp.array([dt * i for i in range(N)])
ys = jnp.sin(2*jnp.pi*freq*xs)
val = rms(xs, ys)


fast_rms = jit(rms)
# Run benchmark
import time
val = fast_rms(xs, ys)
trials=38
t1 = time.time()
for i in range(trials):
    fast_rms(xs, ys)
t2 = time.time()
ns = (t2 - t1)/trials/N * 1e9

import sys
ver = "{major}.{minor}.{micro}".format(major=sys.version_info[0], minor=sys.version_info[1], micro=sys.version_info[2])
print("Python {ver}  array(jax jit)   rms = {val} : {t:>5} ns per iteration average over {trials:>3} trials of {N} points".format(ver=ver, val=val, t=round(ns,2), trials=trials, N=N))