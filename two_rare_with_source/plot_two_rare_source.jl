using Tenkai
using Tenkai: utils_dir
EqTM = Tenkai.EqTenMoment1D
using Tenkai.EqTenMoment1D: sod_iv
include("$utils_dir/plot_python_solns.jl")
include("../my_plot_python_solns.jl")
s_dir = "two_rare_with_source"
file1 = "$s_dir/output_homogeneous_N4_500/sol.txt"
file2 = "$s_dir/output_N4_500/sol.txt"
files = [file1, file2]
labels = ["Homogeneous", "Non-Homog."]
my_plot_solns(files, labels; degree = 4, outdir = "$s_dir/figures", plt_type = "sol",
              soln_line_width = 2.0)
