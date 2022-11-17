function rms(xs, ys)
    x1 = @view xs[begin:end-1]
    y1 = @view ys[begin:end-1]
    x2 = @view xs[begin+1:end]
    y2 = @view ys[begin+1:end]
    area = sum(@. (x2 - x1) * ((y2 - y1)^2/3 + y1*y2))
    sqrt(area/(xs[end]- xs[1]))
end

# Create sine wave:
N = 10^6 + 1
tstop = 1e-3
dt = tstop/(N-1)
xs = [dt*i for i in 0:N-1]
freq = 1000
ys = sin.(2pi*freq*xs)

#using Unitful, Unitiful.DefaultSymbols
#xs = xs .* 1s
#ys = ys .* 1V


# Run benchmark:
val = rms(xs, ys)  # first time to compile
trials = 120
t = @elapsed for i in 1:trials
    rms(xs, ys)
end
ns = t / trials / N * 1e9

println("Julia  $VERSION array         rms = $val : $(lpad(round(ns, sigdigits=2), 5)) ns per iteration average over $(lpad(trials, 3)) trials of $N points")
