module TestReactions

using Base.Test
using SoilTracers.PhysChem: hydrolysis_cos


@time @testset "Reaction functions" begin
    temp_0C = 273.15
    temp_25C = 298.15

    # test hydrolysis_cos

    k_hyd_cos_0C = hydrolysis_cos(temp_0C)
    k_hyd_cos_25C = hydrolysis_cos(temp_25C)

    @test typeof(k_hyd_cos_0C) <: Real
    @test typeof(k_hyd_cos_25C) <: Real

    @test k_hyd_cos_0C < k_hyd_cos_25C
    @test isapprox(k_hyd_cos_25C, 2.26e-5, rtol=1e-3)
end


end
