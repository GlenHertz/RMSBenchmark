function rms(x1, y1, x2, y2)
    @assert length(xs) == length(ys) "dimension mismatch"
    area = sum(@. (x2 - x1) * ((y2 - y1)^2/3 + y1*y2))
    sqrt(area/(xs[end]- xs[begin]))
end



using Metal
a = MtlArray(Float32[1, 1.5, 2, 3])
b = MtlArray(Float32[-1.5, 0, 1, -1])
a .* b
a[begin+1:end]
rms(a[begin:end-1], b[begin:end-1], a[begin+1:end], b[begin+1:end])
# Create sine wave:
N = 10^6 + 1
tstop = 1e-3
dt = tstop/(N-1)
xs = MtlArray(Float32[dt*i for i in 0:N-1])
freq = 1000
ys = MtlArray([Float32(sin(2pi*freq*x)) for x in xs])
x1 = xs[begin:end-1]
y1 = ys[begin:end-1]
x2 = xs[begin+1:end]
y2 = ys[begin+1:end]
# Run benchmark:
val = rms(x1, y1, x2, y2)  # first time to compile
trials = 380
t = @elapsed for i in 1:trials
    rms(x1, y1, x2, y2)
end
ns = t / trials / N * 1e9
nt = Threads.nthreads()
println("Julia $VERSION threads=$nt, for rms=$val : $(lpad(round(ns, sigdigits=3), 5)) ns per iteration average over $trials trials of $N points")