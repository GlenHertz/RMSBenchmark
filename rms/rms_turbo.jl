using LoopVectorization

function rms(xs, ys)
    @assert length(xs) == length(ys) "dimension mismatch"
    area = 0.0
    @turbo for i in 2:length(xs)
        dx = xs[i] - xs[i-1]
        y1 = ys[i-1]
        y2 = ys[i]
        dy = y2 - y1
        area += dx*(dy^2/3 + y1*y2)
    end
    sqrt(area/(last(xs) - first(xs)))
end




# Create sine wave:
xs = 0:10^-6:1
ys = sin.(2pi * 1000 * xs)
val = rms(xs, ys)


xs = collect(xs) # a bit faster
include("benchmark.jl")