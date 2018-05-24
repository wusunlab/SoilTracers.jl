include("../consts.jl")


function solub_co2(temp, pressure=Constants.atm, salinity=0.)
    # coefficients are from Weiss (1974) fitted to Murray & Riley (1971) data
    t = temp * 1e-2  # a transferred scale
    kcp_co2 = @. exp(-58.0931 + 90.5069 / t + 22.2940 * log(t) +
                     salinity * (0.027766 - 0.025888 * t + 0.0050578 * t * t))
    # note: kcp = c_aq / p_i [mol L^-1 atm^-1]
    # where p_i is the partial pressure

    # convert to bunsen solubility [dimensionless]
    # air molar concentration [mol m^-3]
    air_conc = @. pressure / (Constants.R * temp)
    return @. kcp_co2 * 1e3 / air_conc
end


function solub_cos(temp, pressure=Constants.atm)
    # coefficients from fitting Elliott et al. (1989) data
    return @. temp * exp(4050.32 / temp - 20.0007)
end
