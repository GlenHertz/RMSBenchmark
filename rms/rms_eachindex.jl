function rms(xs, ys)
    @assert length(xs) == length(ys) "dimension mismatch"
    xs₁ = @view xs[begin:end-1]
    ys₁ = @view ys[begin:end-1]
    xs₂ = @view xs[begin+1:end]
    ys₂ = @view ys[begin+1:end]
    area = 0.0
    for i in eachindex(xs₁, ys₁, xs₂, ys₂)
        Δx = xs₂[i] - xs₁[i]
        y₁ = xs₁[i]
        y₂ = ys₂[i]
        Δy = y₂ - y₁
        area += Δx*(Δy^2/3 + y₁*y₂)
    end
    sqrt(area/(xs[end] - xs[begin]))
end

# generate a 1kHz sine wave from 0 to 1 second (with 1us steps):
xs = 0:10^-6:1
ys = sin.(2pi * 1000 * xs)
val = rms(xs, ys)


xs = collect(xs)
include("benchmark.jl")
