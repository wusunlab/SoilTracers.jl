using Base.Test
using Compat  # for breaking changes in julia 0.7
using SoilTracers


anyerrors = false

tests = ["consts.jl"]
        #  "test_physchem/test_diffus.jl",
        #  "test_physchem/test_solub.jl",
        #  "test_physchem/test_water.jl",
        #  "test_physchem/test_rxn.jl"]


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


@time @testset "Test PhysChem functions" begin
    include("test_physchem/test_diffus.jl")
    include("test_physchem/test_solub.jl")
    include("test_physchem/test_water.jl")
    include("test_physchem/test_rxn.jl")
end


if anyerrors
    throw(error("Tests failed"))
end
