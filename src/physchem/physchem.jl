__precompile__()

"""Physical chemistry functions."""
module PhysChem

include("thermodyn.jl")
include("diffus.jl")
include("solub.jl")

export c2k, k2c  # from thermodyn.jl
export diffus_air, diffus_water, diffus_soil_air, diffus_soil_water,
    diffus_soil  # from diffus.jl
export solub_co2, solub_cos  # from solub.jl

end  # module
