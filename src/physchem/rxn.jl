"""
    hydrolysis_cos(temp[, pH=7., seawater::Bool=false])

COS abiotic hydrolysis rate in natural waters. Applicable range: temperature
5--30 C and pH 4--10.

# Parameters

* `temp`: Temperature in Kelvin.
* `pH`: pH value. Default is 7.
* `seawater` (optional): If `true`, calculate COS hydrolysis rate in the
  seawater [RC93]. If `false` (default), caculate COS hydrolysis rate in the
  fresh water [E89].

# Returns

The abiotic hydrolysis rate constant of COS [s^-1].

# References

[E89] Elliott, S., Lu, E., and Rowland, F. S. (1989). Rates and
    mechanisms for the hydrolysis of carbonyl sulfide in natural waters.
    *Environ. Sci. Tech.*, 23(4), 458--461.
    <https://doi.org/10.1021/es00181a011>

[RC93] Radford-Knoery, J., and Cutter, G. A. (1993). Determination of
    carbonyl sulfide and hydrogen sulfide species in natural waters using
    specialized collection procedures and gas chromatography with flame
    photometric detection. *Anal. Chem.*, 65(8), 976--982.
    <https://doi.org/10.1021/ac00056a005>

# Examples

```jldoctest
julia> @printf "%g" hydrolysis_cos(288.15)
6.60184e-06

julia> @printf "%g" hydrolysis_cos(288.15, 9.)
3.64899e-05

julia> @printf "%g" hydrolysis_cos(288.15, 8.2, true)
1.40695e-05
```
"""
function hydrolysis_cos(temp, pH=7., seawater::Bool=false)
    T_ref = 298.15
    c_OH = 10. ^ (pH - water_dissoc(temp))
    t_diff = 1. / temp - 1. / T_ref

    # note: the parameter values used here differ from those in the original
    # publications due to a small correction for water pK_w
    if seawater
        # RC93 equation
        return 1.63838819502e-5 * exp(-6444.02904777 * t_diff) +
            11.7115101829 * exp(-2427.27401921 * t_diff) * c_OH
    else
        # E89 equation
        return 2.11834513803e-5 * exp(-10418.3722377 * t_diff) +
            14.16881179 * exp(-6469.11889197 * t_diff) * c_OH
    end
end
