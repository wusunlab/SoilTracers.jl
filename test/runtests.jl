using SoilTracers
using Base.Test

println("Starting tests")

@time @testset "Test physical constants" begin
    include("test_consts.jl")
end
