module TestWater

using Base.Test
using SoilTracers.PhysChem: water_density, water_dissoc


@time @testset "Water properties" begin
    # test water density
    rho_4C = water_density(277.15)
    @test typeof(rho_4C) <: Real
    @test isapprox(rho_4C, 999.9, rtol=1e-4)

    # test water dissociation coefficient
    pK_w_25C = water_dissoc(298.15)
    @test typeof(pK_w_25C) <: Real
    @test isapprox(pK_w_25C, 14., rtol=1e-3)
end


end
