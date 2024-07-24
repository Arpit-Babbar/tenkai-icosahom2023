using Tenkai
using Tenkai: utils_dir

include("$utils_dir/plot_python_solns.jl")

function add_theo_factors!(ax, ncells, error, degree, i,
                           theo_factor_even, theo_factor_odd)
    if degree isa Int64
        d = degree
    else
        d = parse(Int64, degree)
    end
    min_y = minimum(error[1:(end - 1)])
    @show error, min_y
    xaxis = ncells[(end - 1):end]
    slope = d + 1
    if iseven(slope)
        theo_factor = theo_factor_even
    else
        theo_factor = theo_factor_odd
    end
    y0 = theo_factor * min_y
    y = (1.0 ./ xaxis) .^ slope * y0 * xaxis[1]^slope
    markers = ["s", "o", "*", "^"]
    # if i == 1
    ax.loglog(xaxis, y, label = "\$ O(M^{-$(d + 1)})\$", linestyle = "--",
              marker = markers[i], c = "grey",
              fillstyle = "none")
    # else
    # ax.loglog(xaxis,y, linestyle = "--", c = "grey")
    # end
end

function plot_python_ndofs_vs_y(files::Vector{String}, labels::Vector{String},
                                degrees::Vector{Int};
                                saveto,
                                theo_factor_even = 0.8, theo_factor_odd = 0.8,
                                title = nothing, log_sub = "2.5",
                                error_norm = "l2",
                                ticks_formatter = format_with_powers,
                                figsize = (6.4, 4.8),
                                var_index = 2)
    # @assert error_type in ["l2","L2"] "Only L2 error for now"
    fig_error, ax_error = plt.subplots(figsize = figsize)
    colors = ["orange", "royalblue", "green", "m", "c", "y", "k"]
    markers = ["D", "o", "*", "^"]
    @assert length(files) == length(labels)
    n_plots = length(files)

    for i in 1:n_plots
        degree = degrees[i]
        data = readdlm(files[i])
        marker = markers[i]
        ax_error.loglog(data[:, 1] * (degree + 1), data[:, var_index], marker = marker, c = colors[i],
                        mec = "k", fillstyle = "none", label = labels[i])
    end

    for i in eachindex(degrees) # Assume degrees are not repeated
        data = readdlm(files[i])
        degree = degrees[i]
        add_theo_factors!(ax_error, (degree + 1) * data[:, 1], data[:,var_index], degree, i,
                             theo_factor_even, theo_factor_odd)
    end
    ax_error.set_xlabel("Degrees of freedom")
    ax_error.set_ylabel(error_label(error_norm))

    set_ticks!(ax_error, log_sub, ticks_formatter; dim = 1)

    ax_error.grid(true, linestyle = "--")

    if title !== nothing
        ax_error.set_title(title)
    end
    ax_error.legend()

    fig_error.savefig("$saveto.pdf")
    fig_error.savefig("$saveto.png")

    return fig_error
end

files = Vector{String}()
labels = Vector{String}()
degrees = Vector{Int}()
for i=2:4
    append!(files, ["convergence/N$i.txt"])
    append!(labels, ["\$ N = $i \$"])
    append!(degrees, i)
end

plot_python_ndofs_vs_y(files, labels, degrees, saveto = "convergence/convergence_rho",
                       theo_factor_even = 0.6, theo_factor_odd = 0.6,
                       figsize = (6.0, 6.2), var_index = 2)
plot_python_ndofs_vs_y(files, labels, degrees, saveto = "convergence/convergence_p11",
                       theo_factor_even = 0.6, theo_factor_odd = 0.6,
                       figsize = (6.0, 6.2), var_index = 3)
