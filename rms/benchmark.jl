rms([1, 1.5, 2, 3], [-1.0, 0, 1, -1])
# Create sine wave:
N = 10^6 + 1
tstop = 1e-3
dt = tstop/(N-1)
xs = [dt*i for i in 0:N-1]
freq = 1000
ys = sin.(2pi*freq*xs)

# Run benchmark:
val = rms(xs, ys)  # first time to compile
trials = 380 #* 2000
t = @elapsed for i in 1:trials
    rms(xs, ys)
end
ns = t / trials / N * 1e9
nt = Threads.nthreads()
println("Julia $VERSION threads=$nt, for rms=$val : $(lpad(round(ns, sigdigits=3), 5)) ns per iteration average over $trials trials of $N points")
