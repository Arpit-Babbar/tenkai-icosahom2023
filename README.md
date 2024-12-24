Running this code requires julia. I recommend using `juliaup` to install it, see https://julialang.org/downloads/. Once you have julia installed, enter the current directory in your terminal and enter the julia REPL by using the command `julia`.

```julia
julia> import Pkg
julia> Pkg.add(url="https://github.com/Arpit-Babbar/Tenkai.jl")
```
Now, you are ready to run the any code, e.g., by entering
```julia
julia> include("realistic/run_tenmom_realistic.jl")
```
Many other examples are available at https://github.com/Arpit-Babbar/Tenkai.jl/tree/master/Examples.

