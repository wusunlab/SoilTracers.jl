module TestSolubility

using Base.Test
using SoilTracers.PhysChem: solub_co2, solub_cos


@time @testset "Solubility functions" begin
    temp_0C = 273.15
    temp_25C = 298.15

    # test solub_co2

    k_co2_0C = solub_co2(temp_0C)
    @test typeof(k_co2_0C) <: Real
    @test isapprox(k_co2_0C, 1.739, rtol=1e-3)

    k_co2_25C = solub_co2(temp_25C)
    @test typeof(k_co2_25C) <: Real
    @test isapprox(k_co2_25C, 0.831, rtol=1e-3)

    # test solub_cos

    k_cos_0C = solub_cos(temp_0C)
    @test typeof(k_cos_0C) <: Real
    @test isapprox(k_cos_0C, 1.549, rtol=1e-3)

    k_cos_25C = solub_cos(temp_25C)
    @test typeof(k_cos_25C) <: Real
    @test isapprox(k_cos_25C, 0.488, rtol=1e-3)
end


end
