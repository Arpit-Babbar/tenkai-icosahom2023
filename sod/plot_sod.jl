using Tenkai
using Tenkai: utils_dir
EqTM = Tenkai.EqTenMoment1D
using Tenkai.EqTenMoment1D: sod_iv
include("$utils_dir/plot_python_solns.jl")
include("../my_plot_python_solns.jl")
file1 = "sod/output_N2_100/avg.txt"
file2 = "sod/output_N2_500/avg.txt"
files = [file1, file2]
labels = ["\$ NC = 100\$", "\$ NC = 500 \$"]
my_plot_solns(files, labels; degree = 2, outdir = "sod/figures", plt_type = "cts_avg",
              exact_data = EqTM.exact_solution_data(sod_iv), exact_label = "Exact",
              soln_line_width = 2.0)
