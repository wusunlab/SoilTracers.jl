module TestThermodynamics

using Base.Test
using SoilTracers: Constants
using SoilTracers.PhysChem: c2k, k2c


@time @testset "Basic thermodynamics" begin
    temp1_C = 0.
    temp2_C = 100.
    temp1_K = c2k(temp1_C)
    temp2_K = c2k(temp2_C)
    @test temp1_K === temp1_C + Constants.T_0
    @test temp2_K === temp2_C + Constants.T_0

    @test temp1_C === k2c(temp1_K)
    @test temp2_C === k2c(temp2_K)
end


end
