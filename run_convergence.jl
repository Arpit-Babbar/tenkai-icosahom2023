using Tenkai
using Trixi: trixi_include
using DelimitedFiles

function run_convergence(degree; M = 5, file = "convergence/run_tenmom_convergence_source.jl")
    nx_array = Vector([2^(i+3) for i=1:M])
    data = zeros(M, 5)
    for i in eachindex(nx_array)
        sol = trixi_include("$(@__DIR__)/$file",
                            degree = degree, nx = nx_array[i])
        data[i,1] = nx_array[i]
        data[i,2] = sol["errors"]["l2_error"][1]
        data[i,3] = sol["errors"]["l2_error"][4] # P11 because prim = (rho, v1, v2, P11, P12, P22)
        data[i,4] = sol["errors"]["l1_error"][1]
        data[i,5] = sol["errors"]["l1_error"][4]
    end
    writedlm("convergence/N$degree.txt", data)
end

for degree in 1:4
    run_convergence(degree)
end
