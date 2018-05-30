module TestDiffusivity

using Base.Test
using SoilTracers.PhysChem:
    diffus_air, diffus_water, diffus_soil_air, diffus_soil_water, diffus_soil


@time @testset "Diffusivity functions" begin
    sp1 = "co2"
    sp2 = "cos"
    temp1 = 273.15
    temp2 = 298.15
    tx = "sandy loam"  # soil texture
    theta_sat = 0.5
    theta_w = 0.2
    p = 5e4  # 500 hPa or 0.5 bar; testing the optional arg `pressure`

    # test diffus_air

    D_a_co2_25C = diffus_air(sp1, temp2)
    D_a_cos_25C = diffus_air(sp2, temp2)
    D_a_co2_25C_50kPa = diffus_air(sp1, temp2, p)

    @test typeof(D_a_co2_25C) <: AbstractFloat
    @test isapprox(D_a_co2_25C, 1.618e-5, rtol=1e-3)
    @test typeof(D_a_cos_25C) <: AbstractFloat
    @test isapprox(D_a_cos_25C, 1.337e-5, rtol=1e-3)
    @test typeof(D_a_co2_25C_50kPa) <: AbstractFloat
    @test isapprox(D_a_co2_25C_50kPa, D_a_co2_25C * 1.01325 / 0.5, rtol=1e-5)

    # test diffus_water

    D_w_co2_25C = diffus_water(sp1, temp2)
    D_w_cos_25C = diffus_water(sp2, temp2)

    @test typeof(D_w_co2_25C) <: AbstractFloat
    @test isapprox(D_w_co2_25C, 1.917e-9, rtol=1e-2)
    @test typeof(D_w_cos_25C) <: AbstractFloat
    @test isapprox(D_w_cos_25C, 1.940e-9, rtol=1e-3)

    # test diffus_soil_air

    D_sa_co2_25C = diffus_soil_air(sp1, tx, temp2, theta_sat, theta_w)
    D_sa_co2_25C_50kPa = diffus_soil_air(sp1, tx, temp2, theta_sat, theta_w, p)

    @test typeof(D_sa_co2_25C) <: AbstractFloat
    @test D_w_co2_25C < D_sa_co2_25C < D_a_co2_25C
    @test typeof(D_sa_co2_25C_50kPa) <: AbstractFloat
    @test isapprox(D_sa_co2_25C_50kPa, D_sa_co2_25C * 1.01325 / 0.5, rtol=1e-5)

    # test diffus_soil_water

    D_sw_co2_25C = diffus_soil_water(sp1, tx, temp2, theta_sat, theta_w)
    @test typeof(D_sw_co2_25C) <: AbstractFloat
    @test D_sw_co2_25C < D_w_co2_25C

    # test diffus_soil

    D_s_co2_25C = diffus_soil(sp1, tx, temp2, theta_sat, theta_w)
    @test typeof(D_s_co2_25C) <: AbstractFloat
    @test D_sa_co2_25C < D_s_co2_25C
end


end
