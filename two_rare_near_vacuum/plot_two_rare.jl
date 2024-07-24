using Tenkai
using Tenkai: utils_dir
EqTM = Tenkai.EqTenMoment1D
using Tenkai.EqTenMoment1D: sod_iv
using DelimitedFiles
include("$utils_dir/plot_python_solns.jl")
include("../my_plot_python_solns.jl")
dir = "two_rare_near_vacuum"
file1 = "$dir/output_N2_100/avg.txt"
file2 = "$dir/output_N2_500/avg.txt"
files = [file1, file2]
labels = ["\$ NC = 100\$", "\$ NC = 500 \$"]
exact_data = readdlm("$dir/reference/avg.txt")
my_plot_solns(files, labels; degree = 2, outdir = "two_rare_near_vacuum/figures", plt_type = "sol",
              exact_data = exact_data, exact_label = "Reference",
              second_var_index = 3,
              soln_line_width = 2.0)
