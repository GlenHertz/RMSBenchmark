import Base: length, getindex

struct Signal{X,Y}
    x::Vector{X}
    y::Vector{Y}
    function Signal(x::Vector{X}, y::Vector{Y}) where {X,Y}
        @assert length(x) == length(y) "dimension mismatch"
        new{X,Y}(x, y)
    end
end
length(s::Signal) = length(s.x)
getindex(s::Signal, i::Int) = (x=s.x[i], y=s.y[i])
using LoopVectorization
function rms(s::Signal)
    area = zero(first(s.x) * first(s.y)^2 / 3)
    for i in 2:length(s)
        x₁, y₁ = s[i-1]
        x₂, y₂ = s[i]
        Δx = x₂ - x₁
        Δy = y₂ - y₁
        area += Δx*(Δy^2/3 + y₁*y₂)
    end
    sqrt(area/(last(xs) - first(xs)))
end



# Create sine wave:
xs = collect(0:10^-6:1)
ys = sin.(2pi*1000*xs)
sig = Signal(xs, ys)
val = rms(sig)


xs = collect(xs)
include("benchmark.jl")