"""A collection of physical constants used in the SoilTracers model."""
module Constants

# do not export anything; preserve the namespace

"""Zero Celsius in Kelvin."""
const T_0 = 273.15

"""Molar gas constant [J K⁻¹ mol⁻¹]."""
const R = 8.314_4621

"""Standard acceleration of gravity on earth [m s⁻²]."""
const g = 9.806_65

"""Standard atmospheric pressure [Pa]."""
const atm = 1.01325e5

"""Molar mass of water [kg mol⁻¹]."""
const M_w = 18.015_28

end
