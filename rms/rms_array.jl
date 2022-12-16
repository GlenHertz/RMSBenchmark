function rms(xs, ys)
    @assert length(xs) == length(ys) "dimension mismatch"
    x₁ = @view xs[begin:end-1]
    y₁ = @view ys[begin:end-1]
    x₂ = @view xs[begin+1:end]
    y₂ = @view ys[begin+1:end]
    areas = @. (x₂-x₁) * ((y₂-y₁)^2/3 + y₁*y₂)
    area = sum(areas)
    sqrt(area/(xs[end] - xs[begin]))
end

# generate a 1kHz sine wave from 0 to 1 second (with 1us steps):
xs = 0:10^-6:1
ys = sin.(2pi * 1000 * xs)
val = rms(xs, ys)


xs = collect(xs)
include("benchmark.jl")