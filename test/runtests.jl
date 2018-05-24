using SoilTracers
using Base.Test

println("Starting tests")

@time @testset "Test physical constants" begin
    include("test_consts.jl")
end

@time @testset "Test PhysChem functions" begin
    include("test_physchem/test_diffus.jl")
    include("test_physchem/test_solub.jl")
    include("test_physchem/test_water.jl")
end
