using SoilTracers
using Base.Test

# test h2o functions

water_density = SoilTracers.Tracers.water_density
water_dissoc = SoilTracers.Tracers.water_dissoc

# test water density
rho_4C = water_density(SoilTracers.Constants.T_0 + 4.)
@test typeof(rho_4C) <: Real
@test isapprox(rho_4C, 999.9, rtol=1e-4)

# test water dissociation coefficient
pK_w_25C = water_dissoc(SoilTracers.Constants.T_0 + 25.)
@test typeof(pK_w_25C) <: Real
@test isapprox(pK_w_25C, 14., rtol=1e-3)