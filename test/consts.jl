module TestConstants

using Base.Test
using SoilTracers: Constants


@time @testset "Physical constants" begin
    @test typeof(Constants.T_0) <: AbstractFloat
    @test isapprox(Constants.T_0, 273.15)

    @test typeof(Constants.R) <: AbstractFloat
    @test isapprox(Constants.R, 8.314, rtol=1e-3)

    @test typeof(Constants.g) <: AbstractFloat
    @test isapprox(Constants.g, 9.81, rtol=1e-3)

    @test typeof(Constants.atm) <: AbstractFloat
    @test isapprox(Constants.atm, 101325., rtol=1e-3)

    @test typeof(Constants.M_w) <: AbstractFloat
    @test isapprox(Constants.M_w, 18.015e-3, rtol=1e-3)
end


end
