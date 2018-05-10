"""A collection of physical constants used in the SoilTracers model."""
module Constants

# do not export anything; preserve the namespace

"""Zero Celsius in Kelvin."""
const T_0 = 273.15

"""Molar gas constant [J K^-1 mol^-1]."""
const R = 8.314_4621

"""Standard acceleration of gravity on earth [m s^-2]."""
const g = 9.806_65

"""Standard atmospheric pressure [Pa]."""
const atm = 1.01325e5

"""Molar mass of water [kg mol^-1]."""
const M_w = 18.015_28e-3

end
