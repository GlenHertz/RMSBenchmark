function rms(xs, ys)
    @assert length(xs) == length(ys) "dimension mismatch"
    sqrt(sum((xs[i] - xs[i-1])*((ys[i]-ys[i-1])^2/3 + ys[i-1]*ys[i]) for i in 2:length(xs))/(last(xs) - first(xs)))
end




include("benchmark.jl")