# Run benchmark:
val = rms(xs, ys)  # first time to compile
trials = 380 #* 2000
t = @elapsed for i in 1:trials
    rms(xs, ys)
end
N = length(xs)
ns = t / trials / N * 1e9
nt = Threads.nthreads()
println("Julia $VERSION threads=$nt, for rms=$val : $(lpad(round(ns, sigdigits=3), 5)) ns per iteration average over $trials trials of $N points")



