using ThreadsX
function rms(xs, ys)
    @assert length(xs) == length(ys) "dimension mismatch"
    # Take /3 out of the sum
    sqrt(ThreadsX.sum((xs[i] - xs[i-1])*((ys[i]-ys[i-1])^2 + 3*ys[i-1]*ys[i]) for i in 2:length(xs))/3/(xs[end] - xs[1]))

end

# generate a 1kHz sine wave from 0 to 1 second (with 1us steps):
xs = 0:10^-6:1
ys = sin.(2pi * 1000 * xs)
val = rms(xs, ys)


xs = collect(xs)
include("benchmark.jl")