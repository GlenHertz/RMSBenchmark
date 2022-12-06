function rms(xs, ys)
    @assert length(xs) == length(ys) "dimension mismatch"
    area = zero(xs[1] * ys[1]^2 / 3)
    @inbounds @fastmath for i in 2:length(xs)
        Δx = xs[i] - xs[i-1]
        y1 = ys[i-1]
        y2 = ys[i]
        Δy = y2 - y1
        area += Δx*(Δy^2/3 + y1*y2)
    end
    sqrt(area/(last(xs) - first(xs)))
end

# Create sine wave:
xs = collect(0:10^-6:1)
ys = sin.(2pi * 1000 * xs)
val = rms(xs, ys)



include("benchmark.jl")