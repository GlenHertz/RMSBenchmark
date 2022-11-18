function rms(xs, ys)
    @assert length(xs) == length(ys) "dimension mismatch"
    x1 = @view xs[begin:end-1]
    y1 = @view ys[begin:end-1]
    x2 = @view xs[begin+1:end]
    y2 = @view ys[begin+1:end]
    area = sum(@. (x2 - x1) * ((y2 - y1)^2/3 + y1*y2))
    sqrt(area/(xs[end]- xs[begin]))
end




include("benchmark.jl")