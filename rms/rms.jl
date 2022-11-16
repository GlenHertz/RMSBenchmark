# Julia rms
function rms(xs, ys)
    area = 0.0
    for i in 2:length(xs)
        Δx = xs[i] - xs[i-1]
        y₁ = ys[i-1]
        y₂ = ys[i]
        Δy = y₂ - y₁
        area += Δx*(Δy^2/3 + y₁*y₂)
    end
    sqrt(1/(xs[end] - xs[1])*area)
end





rms([1, 1.5, 2, 3], [-1, 0, 1, -1])
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
trials = 380
t = @elapsed for i in 1:trials
    rms(xs, ys)
end
ns = t / trials / N * 1e9

println("Julia  $VERSION for           rms = $val : $(lpad(round(ns, sigdigits=2), 5)) ns per iteration average over $trials trials of $N points")


#using BenchmarkTools
#res = @benchmark rms(xs, ys)
#t = mean(res)
## Plot histogram:
#using UnicodePlots
#histogram(res.times)