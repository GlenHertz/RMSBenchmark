using BenchmarkTools
using PyCall
using DataFrames
using CSV

py"""import timeit
import numpy as np"""


py"""def py_time(f, number=1_000):
    timer = timeit.Timer(f)
    time = min(timer.repeat(number=number))
    return time/number
"""

py_time = py"py_time"

sizes = (100, 1000, 10_000, 100_000, 1_000_000)
results = DataFrame()

for size in sizes
    @info "Testing size $size"
    data1 = rand(size)
    data2 = rand(size)
    data3 = rand(size)
    data1_py = py"np.random.rand($size)"
    data2_py = py"np.random.rand($size)"
    data3_py = py"np.random.rand($size)"

    op = "addition"
    timing = @belapsed $data1 .+ $data2
    push!(results, (sys="Julia", op=op, size=size, timing=timing))
    timing = py"py_time(lambda: $data1_py + $data2_py)"
    push!(results, (sys="Numpy", op=op, size=size, timing=timing))

    op="multiplication"
    timing = @belapsed $data1 .* $data2
    push!(results, (sys="Julia", op=op, size=size, timing=timing))
    timing = py"py_time(lambda: $data1_py * $data2_py)"
    push!(results, (sys="Numpy", op=op, size=size, timing=timing))

    op="division"
    timing = @belapsed $data1 ./ $data2
    push!(results, (sys="Julia", op=op, size=size, timing=timing))
    timing = py"py_time(lambda: $data1_py / $data2_py)"
    push!(results, (sys="Numpy", op=op, size=size, timing=timing))

    op="3ops"
    timing = @belapsed $data1 .* $data2 .+ $data3
    push!(results, (sys="Julia", op=op, size=size, timing=timing))
    timing = py"py_time(lambda: $data1_py * $data2_py + $data3_py)"
    push!(results, (sys="Numpy", op=op, size=size, timing=timing))

    op="exp"
    timing = @belapsed exp.($data1)
    push!(results, (sys="Julia", op=op, size=size, timing=timing))
    timing = py"py_time(lambda: np.exp($data1_py))"
    push!(results, (sys="Numpy", op=op, size=size, timing=timing))

    op="log"
    timing = @belapsed log.($data1)
    push!(results, (sys="Julia", op=op, size=size, timing=timing))
    timing = py"py_time(lambda: np.log($data1_py))"
    push!(results, (sys="Numpy", op=op, size=size, timing=timing))

    op="element_sum"
    timing = @belapsed sum($data1)
    push!(results, (sys="Julia", op=op, size=size, timing=timing))
    timing = py"py_time(lambda: $data1_py.sum())"
    push!(results, (sys="Numpy", op=op, size=size, timing=timing))
    
end

CSV.write("timings.csv", results)
show(results, allrows=true)

## plotting (could be executed stand-alone)

using Plots
using DataFrames
using CSV

results = DataFrame(CSV.File("timings.csv"))

agg_timings = DataFrame()

for (key, data) in pairs(groupby(results, [:op, :size]))
    ratio = first(filter(x-> x.sys=="Numpy", data).timing) / first(filter(x-> x.sys=="Julia", data).timing)
    push!(agg_timings, (op=key.op, size=key.size, ratio=ratio))
end
agg_timings

plt = plot(; xlabel="element size", ylabel="Julia speedup (runtime Numpy / Julia - 1)", xscale=:log, yscale=:log, leg=:topright)

for (key, data) in pairs(groupby(agg_timings, :op))
    plot!(plt, data.size, data.ratio, label=key.op)
end

savefig(plt, "timings.png")
plt

