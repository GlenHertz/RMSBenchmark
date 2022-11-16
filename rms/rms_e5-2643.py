import math

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


# A triangular wave has an RMS of Peak/sqrt(3)
N = 10**6
dt = 1/N
xs = [dt * i for i in range(N+1)]
ys = [dt * i for i in range(N+1)]


# Run benchmark
import time
val = rms(xs, ys)
trials=10
min_time = 1e6
for i in range(trials):
    t1 = time.time()
    rms(xs, ys)
    t2 = time.time()
    min_time = min(min_time, t2 - t1)

print("RMS of trangular wave: {val} (ans = {ans})".format(val=val, ans=1/math.sqrt(3)))

print("Best time of {trials} trials: {min_time}".format(trials=trials, min_time=min_time))

# Results:
# num_cpus: 12
# cpu_mhz: 3500.0
# cache_size_mb: 25.0
# model_name: Intel(R) Xeon(R) CPU E5-2643 v2 @ 3.50GHz
# phys_mem_gb: 251.7
# redhat_release: CentOS Linux release 7.7 (Core)
# Python 3.9.7
# RMS of trangular wave: 0.5773502691896244 (ans = 0.5773502691896258)
# Best time of 10 trials: 0.5741355419158936