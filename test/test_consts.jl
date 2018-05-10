using SoilTracers

@test typeof(SoilTracers.Constants.T_0) <: Number
@test isapprox(SoilTracers.Constants.T_0, 273.15)

@test typeof(SoilTracers.Constants.R) <: Number
@test isapprox(SoilTracers.Constants.R, 8.314, rtol=1e-3)

@test typeof(SoilTracers.Constants.g) <: Number
@test isapprox(SoilTracers.Constants.g, 9.80, rtol=1e-3)

@test typeof(SoilTracers.Constants.atm) <: Number
@test isapprox(SoilTracers.Constants.atm, 101325., rtol=1e-3)

@test typeof(SoilTracers.Constants.M_w) <: Number
@test isapprox(SoilTracers.Constants.M_w, 18.015e-3, rtol=1e-3)
