using Trixi: trixi_include

trixi_include("$(@__DIR__)/plot_shuosher.jl")
trixi_include("$(@__DIR__)/plot_shuosher_degrees.jl", limiter = "tvb")
trixi_include("$(@__DIR__)/plot_shuosher_degrees.jl", limiter = "blend")
