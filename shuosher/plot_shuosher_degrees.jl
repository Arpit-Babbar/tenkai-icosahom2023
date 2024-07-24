using Tenkai
using Tenkai: utils_dir
EqTM = Tenkai.EqTenMoment1D
using Tenkai.EqTenMoment1D: initial_condition_shu_osher
shuosher = initial_condition_shu_osher
include("$utils_dir/plot_python_solns.jl")
include("../my_plot_python_solns.jl")
limiter = "tvb"
# files = ["shuosher/shuosher_tmp_results/output_$(limiter)_N$i/avg.txt" for i=2:4]
files = Vector{String}()
ndofs = 1000
for degree in 2:4
    global nx = ceil(Int64, 1000/(degree+1))
    # push!(files, "shuosher/shuosher_tmp_results/output_$(limiter)_N$degree/avg.txt")
    push!(files, "shuosher/output_N$(degree)_$(nx)_$(limiter)/avg.txt")
end
# files = ["shuosher/shuosher_tmp_results/output_$(limiter)_N$i/avg.txt" for i=2:4]
labels = ["\$N=$i\$" for i=2:4]
ax_density, ax_pressure, fig_density, fig_pressure = my_plot_solns(files, labels; outdir = "shuosher/figures", plt_type = "cts_avg",
              exact_data = EqTM.exact_solution_data(shuosher), exact_label = "Reference",
              second_var_index = 3, soln_line_width = 2.0)

# bounds[x0, y0, width, height]
# Lower-left corner of inset Axes, and its width and height.

# This is just the location of an inset plot. It is currently empty
axin = ax_density.inset_axes([0.1, 0.05, 0.3, 0.72])
axin.grid(true)

linestyles = my_line_styles()
# Plot some curves on the inset plot
for (i, file) in enumerate(files)
    data = readdlm(file)
    axin.plot(data[:,1], data[:,2], markeredgewidth = 3.0, linestyle = linestyles[4-i], linewidth = 2.0, color = colors[4-i])
end
exact_data = EqTM.exact_solution_data(shuosher)
axin.plot(exact_data[:,1], exact_data[:,2], color = "black")
axin.grid(true)

# Set limit in the inset
axin.set_xlim((-0.35, 0.6))
axin.set_ylim((1.75, 4.5))

# Show the region you are zooming into
ax_density.indicate_inset_zoom(axin, edgecolor = "gray", linewidth = 1.0, alpha = 1.0)

# Hide all ticks from inset
axin.xaxis.set_major_locator(plt.matplotlib.ticker.NullLocator())
axin.yaxis.set_major_locator(plt.matplotlib.ticker.NullLocator())

# Put in some ticks without numbering to show grid lines
axin.set_xticks([0.0, 0.5], "")
axin.set_xticks([0.0, 0.25, 0.5], "")
axin.set_yticks([2.0, 4.0], "")
axin.grid(true)

fig_density # Visualize inset
fig_density.savefig("shuosher/figures/density_$limiter.pdf")

fig_density