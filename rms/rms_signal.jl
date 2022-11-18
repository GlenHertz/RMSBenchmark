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

function rms(s::Signal)
    area = zero(s.x[1] * s.y[1]^2 / 3)
    for i in 2:length(s)
        p1 = s[i-1]
        p2 = s[i]
        dx = p2.x - p1.x
        dy = p2.y - p1.y
        area += dx*(dy^2/3 + p1.y*p2.y)
    end
    sqrt(area/(last(xs) - first(xs)))
end



# Create sine wave:
N = 10^6 + 1
tstop = 1e-3
dt = tstop/(N-1)
xs = [dt*i for i in 0:N-1]
freq = 1000
ys = sin.(2pi*freq*xs)
sig = Signal(xs, ys)

#using Unitful, Unitiful.DefaultSymbols
#xs = xs .* 1s
#ys = ys .* 1V


# Run benchmark:
val = rms(sig)  # first time to compile
trials = 300
t = @elapsed for i in 1:trials
    rms(sig)
end
ns = t / trials / N * 1e9

println("Julia  $VERSION rms = $val : $(lpad(round(ns, sigdigits=2), 5)) ns per iteration average over $trials trials of $N points")

#using BenchmarkTools
#res = @benchmark rms(xs, ys)
#t = mean(res)
## Plot histogram:
#using UnicodePlots
#histogram(res.times)