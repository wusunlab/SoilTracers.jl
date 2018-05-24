"""
    solub_co2(temp[, salinity=0.])

Calculate CO2 solubility in natural water.

# Parameters

* `temp`: Temperature in Kelvin.
* `salinity` (optional): Salinity in per mil mass fraction (g kg^-1 seawater).

# Returns

Bunsen solubility coefficient of COS [dimensionless].

# See also

`solub_cos` : Calculate COS solubility in pure water.

# References

[MR71] Murray, C. N. and Riley, J. P. (1971). The solubility of gases
    in distilled water and seawater--IV. Carbon dioxide. *Deep-Sea Res.*, 18,
    533--541. <https://doi.org/10.1016/0011-7471(71)90077-5>

[W74] Weiss, R. F. (1974). Carbon dioxide in water and seawater: the solubility
    of a non-ideal gas. *Mar. Chem.*, 2, 203--215.
    <https://doi.org/10.1016/0304-4203(74)90015-2>

# Examples

```jldoctest
julia> solub_co2(298.15)
0.8310045730830151
```
"""
function solub_co2(temp, salinity=0.)
    t = temp * 1e-2  # a transferred scale
    kcp_co2 = @. exp(-58.0931 + 90.5069 / t + 22.2940 * log(t) +
                     salinity * (0.027766 - 0.025888 * t + 0.0050578 * t * t))
    # Note: kcp = c_aq / p_i [mol L^-1 atm^-1], where p_i is the partial
    # pressure. To convert it to the Bunsen solubility [dimensionless],
    # multiply kcp by the air molar concentration at the standard pressure
    # [mol m^-3]. There is no pressure dependence because it cancels out.
    air_conc = @. Constants.atm / (Constants.R * temp)
    return @. kcp_co2 * 1e3 / air_conc
end


"""
    solub_cos(temp)

Calculate COS solubility in pure water.

# Parameters

`temp`: Temperature in Kelvin.

# Returns

Bunsen solubility coefficient of COS [dimensionless].

# See also

`solub_co2` : Calculate CO2 solubility in natural water.

# References

[E89] Elliott, S., Lu, E., and Rowland, F. S. (1989). Rates and
    mechanisms for the hydrolysis of carbonyl sulfide in natural waters.
    *Environ. Sci. Tech*. 23(4), 458--461.
    <https://doi.org/10.1021/es00181a011>

# Examples

```jldoctest
julia> solub_cos(298.15)
0.48759826544380036
```
"""
function solub_cos(temp)
    return @. temp * exp(4050.32 / temp - 20.0007)
end
