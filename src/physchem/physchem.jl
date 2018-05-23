__precompile__()

"""Physical chemistry functions."""
module PhysChem

include("thermodyn.jl")
include("diffus.jl")

# from diffus.jl
export diffus_air, diffus_water, diffus_soil_air, diffus_soil_water,
    diffus_soil

end  # module
