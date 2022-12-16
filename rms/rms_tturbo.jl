using LoopVectorization
function rms(xs, ys)
    @assert length(xs) == length(ys) "dimension mismatch"
    area = 0.0
    @tturbo for i in 2:length(xs)
        Δx = xs[i] - xs[i-1]
        y₁ = ys[i-1]
        y₂ = ys[i]
        Δy = y₂ - y₁
        area += Δx*(Δy^2/3 + y₁*y₂)
    end
    sqrt(area/(last(xs) - first(xs)))
end

# Create sine wave:
xs = collect(0:10^-6:1)
ys = sin.(2pi * 1000 * xs)
val = rms(xs, ys)



include("benchmark.jl")