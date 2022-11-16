using ThreadsX
using LoopVectorization
export rms_vec
export rms_for, rms_for2, rms_for3, rms_for3_avx, rms_for_simd, rms_for_fastmath
export rms_generator, rms_generator2
export rms_threadsx, rms_threadsx2

function rms_vec(xs, ys)
    @assert length(xs) == length(ys) "dimension mismatch"
    y1 = @view ys[1:end-1]
    x1 = @view xs[1:end-1]
    y2 = @view ys[2:end]
    x2 = @view xs[2:end]
    dy = y2 .- y1
    dx = x2 .- x1
    areas = @. dx*(dy^2/3 + y1*y2)
    area = sum(areas)
    sqrt(area/(xs[end] - xs[1]))
end

function rms_for(xs, ys)
    @assert length(xs) == length(ys) "dimension mismatch"
    area = zero(xs[1]*ys[1]^2/3)
    for i in 2:length(xs)
        x1, x2 = xs[i-1], xs[i]
        y1, y2 = ys[i-1], ys[i]
        dx = x2 - x1
        dy = y2 - y1
        area += dx*(dy^2/3 + y1*y2)
    end
    sqrt(area/(xs[end] - xs[1]))
end

function rms_for2(xs, ys)
    @assert length(xs) == length(ys) "dimension mismatch"
    x1, y1 = xs[1], ys[1]
    area = zero(x1*y1*y1/3)
    xmin = x1
    for i in 2:length(xs)
        x2, y2 = xs[i], ys[i]
        dx = x2 - x1
        dy = y2 - y1
        area += dx*(dy^2/3 + y1*y2)
        x1, y1 = x2, y2
    end
    xmax = x1
    sqrt(area/(xmax - xmin))
end

function rms_for3(xs, ys)
    @assert length(xs) == length(ys) "dimension mismatch"
    x1, y1 = xs[1], ys[1]
    area3x = zero(x1*y1*y1)
    xmin = x1
    for i in 2:length(xs)
        x2, y2 = xs[i], ys[i]
        dx = x2 - x1
        dy = y2 - y1
        area3x += dx*(dy^2 + 3y1*y2)
        x1, y1 = x2, y2
    end
    xmax = x1
    sqrt(area3x/3/(xmax - xmin))
end

function rms_for3_avx(xs, ys)
    @assert length(xs) == length(ys) "dimension mismatch"
    N = length(xs)
    area3x = zero(xs[1]*ys[1]^2)
    @avx for i in 2:N
        x1 = xs[i-1]
        x2 = xs[i]
        y1 = ys[i-1]
        y2 = ys[i]
        dx = x2 - x1
        dy = y2 - y1
        area3x += dx*(dy^2 + 3y1*y2)
    end
    sqrt(area3x/3/(xs[end] - xs[1]))
end

function rms_for_fastmath(xs, ys)
    @assert length(xs) == length(ys) "dimension mismatch"
    area = zero(xs[1]*ys[1]^2/3)
    @fastmath for i in 2:length(xs)
        x1, x2 = xs[i-1], xs[i]
        y1, y2 = ys[i-1], ys[i]
        dx = x2 - x1
        dy = y2 - y1
        area += dx*(dy^2/3 + y1*y2)
    end
    sqrt(area/(xs[end] - xs[1]))
end


function rms_for_simd(xs, ys)
    @assert length(xs) == length(ys) "dimension mismatch"
    x1, y1 = xs[1], ys[1]
    area = zero(x1*y1*y1/3)
    xmin = x1
    @simd for i in 2:length(xs)
        x2, y2 = xs[i], ys[i]
        dx = x2 - x1
        dy = y2 - y1
        area += dx*(dy^2/3 + y1*y2)
        x1, y1 = x2, y2
    end
    xmax = x1
    sqrt(area/(xmax - xmin))
end


function rms_generator(xs, ys)
    @assert length(xs) == length(ys) "dimension mismatch"
    sqrt(sum((xs[i] - xs[i-1])*((ys[i]-ys[i-1])^2/3 + ys[i-1]*ys[i]) for i in 2:length(xs))/(xs[end] - xs[1]))
end

function rms_generator2(xs, ys)
    @assert length(xs) == length(ys) "dimension mismatch"
    sqrt(sum((xs[i] - xs[i-1])*((ys[i]-ys[i-1])^2 + 3*ys[i-1]*ys[i]) for i in 2:length(xs))/3/(xs[end] - xs[1]))
end

function rms_threadsx(xs, ys)
    @assert length(xs) == length(ys) "dimension mismatch"
    sqrt(ThreadsX.sum((xs[i] - xs[i-1])*((ys[i]-ys[i-1])^2/3 + ys[i-1]*ys[i]) for i in 2:length(xs))/(xs[end] - xs[1]))
end
function rms_threadsx2(xs, ys)
    @assert length(xs) == length(ys) "dimension mismatch"
    sqrt(ThreadsX.sum((xs[i] - xs[i-1])*((ys[i]-ys[i-1])^2 + 3*ys[i-1]*ys[i]) for i in 2:length(xs))/3/(xs[end] - xs[1]))
end
