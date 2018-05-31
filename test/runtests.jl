using Base.Test
using Compat  # for breaking changes in julia 0.7
using SoilTracers


anyerrors = false

tests = ["consts.jl",
         "soilgrid/soilgrid.jl",
         "physchem/thermodyn.jl",
         "physchem/diffus.jl",
         "physchem/solub.jl",
         "physchem/water.jl",
         "physchem/rxn.jl",
         "physchem/physchem.jl"]


println("Running tests:")


for t in tests
    try
        include(t)
        println("\t\033[1m\033[32mPASSED\033[0m: $(t)")
    catch e
        global anyerrors = true
        println("\t\033[1m\033[31mFAILED\033[0m: $(t)")
        showerror(stdout, e, backtrace())
    end
end

if anyerrors
    throw(error("Tests failed"))
end
