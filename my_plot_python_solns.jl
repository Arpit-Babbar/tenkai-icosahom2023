my_line_styles() = ["dotted", "dashed", "dashdot"]
function my_plot_solns(files::Vector{String}, labels::Vector{String};
                    test_case = nothing, title = "",
                    xlims = nothing, ylims = nothing,
                    xscale = "linear", yscale = "linear",
                    exact_line_width = 1, soln_line_width = 1,
                    degree = 3,
                    plt_type = "sol", outdir = nothing,
                    exact_data = nothing,
                    exact_label = "Reference",
                    second_var_index = 6)
    @assert length(files) == length(labels)
    markers = markers_array_new()
    colors = colors_array_new()
    fig_density, ax_density = plt.subplots()
    var_label_names = ["Density", "\$ v_1 \$", "\$ v_2 \$", "\$ P_{11} \$",
                 "\$ P_{12} \$", "\$ P_{22} \$"]
    var_filenames = ["density", "v1", "v2", "P11", "P12", "P22"]
    linestyles = my_line_styles()
    # exact_data = exact_solution_data(test_case)
    fig_pressure, ax_pressure = plt.subplots()
    if xlims !== nothing
        ax_density.set_xlim(xlims)
        ax_pressure.set_xlim(xlims)
    end
    if ylims !== nothing
        ax_density.set_ylim(ylims)
    end
    ax_density.set_xlabel("x")
    ax_pressure.set_xlabel("x")
    ax_density.set_ylabel("Density")
    ax_pressure.set_ylabel(var_label_names[second_var_index-1])
    ax_density.grid(true, linestyle = "--")
    ax_pressure.grid(true, linestyle = "--")

    # Set scales
    ax_density.set_xscale(xscale)
    ax_density.set_yscale(yscale)
    ax_pressure.set_xscale(xscale)
    ax_pressure.set_yscale(yscale)

    if exact_data !== nothing
        @views ax_density.plot(exact_data[:, 1], exact_data[:, 2], label = exact_label,
                               c = "k", linewidth = exact_line_width)
        @views ax_pressure.plot(exact_data[:, 1], exact_data[:, second_var_index], label = exact_label,
                                c = "k", linewidth = exact_line_width)
    end
    if plt_type == "avg"
        filename = "avg.txt"
        seriestype = :scatter
    elseif plt_type == "cts_avg"
        filename = "avg.txt"
        seriestype = :line
    else
        @assert plt_type in ("sol", "cts_sol")
        filename = "sol.txt"
        seriestype = :line
    end

    n_plots = length(files)
    for i in 1:n_plots
        # data = datas[i]
        label = labels[i]
        soln_data = readdlm(files[i])
        if plt_type == "avg"
            @views ax_density.plot(soln_data[:, 1], soln_data[:, 2], markers[i],
                                   fillstyle = "none",
                                   c = colors[i], label = label)
            @views ax_pressure.plot(soln_data[:, 1], soln_data[:, second_var_index], markers[i],
                                    fillstyle = "none",
                                    c = colors[i], label = label)
        elseif plt_type in ("cts_sol", "cts_avg")
            @views ax_density.plot(soln_data[:, 1], soln_data[:, 2], fillstyle = "none",
                                   c = colors[i], label = label,
                                   linewidth = soln_line_width, linestyle = linestyles[i] )
            @views ax_pressure.plot(soln_data[:, 1], soln_data[:, second_var_index], fillstyle = "none",
                                    c = colors[i], label = label,
                                    linewidth = soln_line_width, linestyle = linestyles[i])
        else
            nu = max(2, degree + 1)
            nx = Int(size(soln_data, 1) / nu)
            @views ax_density.plot(soln_data[1:nu, 1], soln_data[1:nu, 2],
                                   fillstyle = "none",
                                   color = colors[i], label = label,
                                   linewidth = soln_line_width)
            @views ax_pressure.plot(soln_data[1:nu, 1], soln_data[1:nu, second_var_index],
                                    fillstyle = "none",
                                    color = colors[i], label = label,
                                    linewidth = soln_line_width)
            for ix in 2:nx
                i1 = (ix - 1) * nu + 1
                i2 = ix * nu
                @views ax_density.plot(soln_data[i1:i2, 1], soln_data[i1:i2, 2],
                                       fillstyle = "none",
                                       c = colors[i], linewidth = soln_line_width)
                @views ax_pressure.plot(soln_data[i1:i2, 1], soln_data[i1:i2, second_var_index],
                                        fillstyle = "none",
                                        c = colors[i], linewidth = soln_line_width)
            end
        end
    end
    ax_density.legend()
    ax_pressure.legend()
    ax_density.set_title(title)
    ax_pressure.set_title(title)

    if outdir === nothing
        outdir = joinpath(Tenkai.base_dir, "figures", test_case)
    end
    mkpath(outdir)
    my_save_fig_python(test_case, fig_density, "density.pdf", fig_dir = outdir)
    my_save_fig_python(test_case, fig_pressure, "$(var_filenames[second_var_index-1]).pdf", fig_dir = outdir)
    plt.close()
    return ax_density, ax_pressure, fig_density, fig_pressure
end
