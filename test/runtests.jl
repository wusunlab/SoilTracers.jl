using SoilTracers
using Base.Test

println("Starting tests")

@time @testset "Test physical constants" begin
    include("test_consts.jl")
end

@time @testset "Test H2O functions" begin
    include("test_h2o.jl")
end
