#=
using SoilTracers
using Base.Test
=#


# test reaction functions

hydrolysis_cos = SoilTracers.hydrolysis_cos

temp_0C = SoilTracers.c2k(0.)
temp_25C = SoilTracers.c2k(25.)

# test hydrolysis_cos

k_hyd_cos_0C = hydrolysis_cos(temp_0C)
k_hyd_cos_25C = hydrolysis_cos(temp_25C)

@test typeof(k_hyd_cos_0C) <: Real
@test typeof(k_hyd_cos_25C) <: Real

@test k_hyd_cos_0C < k_hyd_cos_25C
@test isapprox(k_hyd_cos_25C, 2.26e-5, rtol=1e-3)
