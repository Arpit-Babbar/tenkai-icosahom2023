using Tenkai
using Tenkai: utils_dir
EqTM = Tenkai.EqTenMoment1D
using Tenkai.EqTenMoment1D: initial_condition_shu_osher
shuosher = initial_condition_shu_osher
include("$utils_dir/plot_python_solns.jl")
include("../my_plot_python_solns.jl")
file_TVB = "shuosher/output_N4_200_tvb/avg.txt"
file_blend = "shuosher/output_N4_200_blend/avg.txt"
files = [file_blend, file_TVB]
labels = ["Blend", "TVB"]
ax_density, ax_pressure, fig_density, fig_pressure = my_plot_solns(files, labels; degree = 4, outdir = "shuosher/figures", plt_type = "cts_avg",
              exact_data = EqTM.exact_solution_data(shuosher), exact_label = "Reference",
              second_var_index = 3, soln_line_width = 2.0)

# bounds[x0, y0, width, height]
# Lower-left corner of inset Axes, and its width and height.

# This is just the location of an inset plot. It is currently empty
axin = ax_density.inset_axes([0.1, 0.05, 0.3, 0.72])
axin.grid(true)

linestyles = my_line_styles()
# Plot some curves on the inset plot
data_tvb = readdlm(file_TVB)
data_blend = readdlm(file_blend)
axin.plot(data_blend[:,1], data_blend[:,2], "o", mfc = "none", markeredgewidth = 3.0, linestyle = linestyles[1], linewidth = 2.0, color = "red")
axin.plot(data_tvb[:,1], data_tvb[:,2], "s", mfc = "none", markeredgewidth = 3.0, linestyle = linestyles[2], linewidth = 2.0, color = "blue")
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
fig_density.savefig("shuosher/figures/density.pdf")
fig_density