include("../consts.jl")

"""
    water_density(temp)

Calculate water density as a function of temperature (`temp`).

# Parameters

`temp`: Temperature in Kelvin.

# Returns

`rho_w`: Water density (kg m^-3).

# References

[WP02] Wagner, W. and Pruß, A. (2002). The IAPWS Formulation 1995 for the
    Thermodynamic Properties of Ordinary Water Substance for General and
    Scientific Use. *J. Phys. Chem. Ref. Data*, 31, 387.
    <https://doi.org/10.1063/1.1461829>

# Examples

```jldoctest
julia> water_density(298.15)
996.9993666156083
```
"""
function water_density(temp)
    # critical temperature and density
    T_crit = 647.096
    rho_crit = 322.
    # an empirically fitted polynomial
    theta = 1. - temp / T_crit
    rho_ratio = 1. + 1.99274064 * theta ^ (1. / 3.) +
        1.09965342 * theta ^ (2. / 3.) - 0.510839303 * theta ^ (5. / 3.) -
        1.7549349 * theta ^ (16. / 3.) - 45.5170352 * theta ^ (43. / 3.) -
        6.74694450e5 * theta ^ (110. / 3.)

    return rho_crit * rho_ratio
end


"""
    water_dissoc(temp)

Calculate water dissociation constant (pK_w) as a function of temperature.

# Parameters

`temp`: Temperature in Kelvin.

# Returns

`pK_w`:  Water dissociation constant.

# References

[BL06] Bandura, A. V. and Lvov, S. N. (2006). The Ionization Constant of Water
    over Wide Ranges of Temperature and Density. *J. Phys. Chem. Ref. Data*,
    35, 15. <https://doi.org/10.1063/1.1928231>

# Examples

```jldoctest
julia> water_dissoc(298.15)
13.994884354781636
```
"""
function water_dissoc(temp)
    # empirical parameters
    n = 6.
    alpha_0 = -0.864671
    alpha_1 = 8659.19
    alpha_2 = -22786.2
    beta_0 = 0.642044
    beta_1 = -56.8534
    beta_2 = -0.375754

    rho_w = water_density(temp) * 1e-3  # in g cm^-3 here
    temp_sq = temp * temp

    Z = rho_w * exp(alpha_0 + alpha_1 / temp +
                    alpha_2 / temp_sq * rho_w ^ (2. / 3.))
    pK_w_G = 0.61415 + 48251.33 / temp - 67707.93 / temp_sq +
        10102100. / (temp * temp_sq)

    return -2. * n * (log10(1. + Z) - Z / (Z + 1.) * rho_w *
                      (beta_0 + beta_1 / temp + beta_2 * rho_w)) +
        pK_w_G + 2. * log10(Constants.M_w)
end
