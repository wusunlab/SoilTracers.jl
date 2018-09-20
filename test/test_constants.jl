module TestConstants

using Test
using SoilTracers: Constants

@time @testset "Physical constants" begin
    @test isapprox(Constants.T_0, 273.15)
    @test isapprox(Constants.R, 8.314, rtol=1e-3)
    @test isapprox(Constants.g, 9.81, rtol=1e-3)
    @test isapprox(Constants.atm, 101325., rtol=1e-3)
    @test isapprox(Constants.M_w, 18.015e-3, rtol=1e-3)
end

end  # module
