__precompile__()

module SoilTracers

include("consts.jl")  # Constants
include("physchem/physchem.jl")  # PhysChem
include("soilgrid/soilgrid.jl")  # SoilGrid
include("tracers/tracers.jl")  # Tracers

# expose submodule public members to the main module namespace
using SoilTracers.PhysChem
using SoilTracers.SoilGrid

end # module
