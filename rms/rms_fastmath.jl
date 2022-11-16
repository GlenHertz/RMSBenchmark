function rms(xs, ys)
    area = zero(xs[1] * ys[1]^2 / 3)
    @inbounds @fastmath for i in 2:length(xs)
        x1 = xs[i-1]
        y1 = ys[i-1]
        x2 = xs[i]
        y2 = ys[i]
        dx = x2 - x1
        dy = y2 - y1
        area += dx*(dy^2/3 + y1*y2)
    end
    sqrt(area/(xs[end] - xs[1]))
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
trials = 710
t = @elapsed for i in 1:trials
    rms(xs, ys)
end
ns = t / trials / N * 1e9

println("Julia  $VERSION for(fastmath) rms = $val : $(lpad(round(ns, digits=1), 5)) ns per iteration average over $trials trials of $N points")


#using BenchmarkTools
#res = @benchmark rms(xs, ys)
#t = mean(res)
## Plot histogram:
#using UnicodePlots
#histogram(res.times)