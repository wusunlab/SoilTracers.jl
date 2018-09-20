"""
A collection of physical constants.

# References

- [MNT16a] Mohr, P. J., Newell, D. B., and Taylor, B. N. (2016). CODATA
  recommended values of the fundamental physical constants: 2014. *Rev. Mod.
  Phys.*, 88, 035009, 1--73. <https://doi.org/10.1103/RevModPhys.88.035009>.
- [MNT16b] Mohr, P. J., Newell, D. B., and Taylor, B. N. (2016). CODATA
  Recommended Values of the Fundamental Physical Constants: 2014. *J. Phys.
  Chem. Ref. Data*, 45, 043102, 1--74. <https://doi.org/10.1063/1.4954402>.
"""
module Constants

"""Zero Celsius [K]."""
const T_0 = 273.15

"""Molar gas constant [J K^-1 mol^-1]."""
const R = 8.314_4598

"""Standard acceleration of gravity on earth [m s^-2]."""
const g = 9.806_65

"""Standard atmospheric pressure [Pa]."""
const atm = 1.01325e5

"""Molar mass of water [kg mol^-1]."""
const M_w = 18.015_28e-3

end  # module
