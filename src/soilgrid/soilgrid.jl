"""Soil grid types."""
module SoilGrid

using DataFrames

export AbstractSoilGrid, FVGrid, getprofile, setprofile!, addprofile!,
    delprofile!, validategrid


"""USDA soil texture classification."""
const textures = ("sand", "loamy sand",
                  "sandy loam", "silt loam", "loam",
                  "sandy clay loam", "silty clay loam", "clay loam",
                  "sandy clay", "silty clay", "clay")


"""Abstract supertype for all soil grids."""
abstract type AbstractSoilGrid end


"""A 1-D finite-volume soil grid."""
struct FVGrid <: AbstractSoilGrid
    """Number of grid levels."""
    level::Integer
    """Top boundary depth."""
    top::Real
    """Bottom boundary depth."""
    bottom::Real
    """Soil texture."""
    texture::String
    """Names of soil grid properties."""
    gridfields::Array{String,1}
    """Names of soil physical properties."""
    propfields::Array{String,1}
    """Names of tracers."""
    tracerfields::Array{String,1}
    """A DataFrame to store soil variable profiles."""
    profiles::DataFrames.DataFrame

    # define default values in the constructor
    function FVGrid(level=25, top=0., bottom=1., texture="none",
                    gridfields=Array{String,1}[],
                    propfields=Array{String,1}[],
                    tracerfields=Array{String,1}[])
        gridfields = union(
            gridfields, ["grid_node", "grid_top", "grid_bottom", "grid_size"])

        if level <= 0
            throw(DomainError("Number of grid levels must be positive!"))
        end

        if top == bottom
            throw(ArgumentError("Top and bottom depths cannot be the same!"))
        end

        # ensure top boundary depth < bottom boundary depth
        if top > bottom
            tmp = top
            top = bottom
            bottom = tmp
        end

        # convert field names from String to Symbol
        allnamedfields = Symbol.(
            [sort(gridfields); sort(propfields); sort(tracerfields)])

        profiles = DataFrames.DataFrame(
            repeat([Float64], outer=length(allnamedfields)),
            allnamedfields, level)

        self = new(level, top, bottom, texture, gridfields, propfields,
                   tracerfields, profiles)
        initgrid!(self)
        return self
    end
end


"""
    getprofile(g::AbstractSoilGrid, name::Symbol)

Access the vertical profile of a variable in a soil grid.
"""
function getprofile(g::AbstractSoilGrid, name::Symbol)
    if name in g.profiles.colindex.names
        return g.profiles[name]
    else
        throw(ArgumentError("The soil grid has no attribute of \"$name\"\!"))
    end
end


"""
    setprofile!(g::AbstractSoilGrid, name::Symbol, val)

Set the vertical profile of a variable in a soil grid.
"""
function setprofile!(g::AbstractSoilGrid, name::Symbol, val)
    if name in g.profiles.colindex.names
        g.profiles[name] = val
    else
        throw(ArgumentError("The soil grid has no attribute of \"$name\"\!"))
    end
end


"""
    addprofile!(g::AbstractSoilGrid, name::Symbol[, val=NaN])

Add the vertical profile of a variable in a soil grid.
"""
function addprofile!(g::AbstractSoilGrid, name::Symbol, val=NaN)
    if name in g.profiles.colindex.names
        throw(ArgumentError(
            "The attribute \"$name\" already exists in the soil grid!"))
    else
        g.profiles[name] = val
    end
end


"""
    delprofile!(g::AbstractSoilGrid, name::Symbol)

Remove the vertical profile of a variable in a soil grid.
"""
function delprofile!(g::AbstractSoilGrid, name::Symbol)
    if name in g.profiles.colindex.names
        delete!(g.profiles, name)
    else
        throw(ArgumentError("The soil grid has no attribute of \"$name\"\!"))
    end
end


"""Initialize the vertical levels of FVGrid (face-centered)."""
function initgrid!(g::FVGrid)
    grid_node = exp.(collect(1:g.level) * 5. / g.level - 5.) .*
        (g.bottom - g.top) + g.top
    grid_size = Array{Float64,1}(g.level)
    grid_bottom = Array{Float64,1}(g.level)

    grid_size[1] = 0.5 * (grid_node[1] + grid_node[2])
    grid_size[2:end-1] = 0.5 * (grid_node[3:end] - grid_node[1:end-2])
    grid_size[end] = grid_node[end] - grid_node[end-1]

    grid_bottom[1:end-1] = 0.5 * (grid_node[1:end-1] + grid_node[2:end])
    grid_bottom[end] = grid_node[end] + 0.5 * grid_size[end]
    grid_top = grid_bottom - grid_size

    setprofile!(g, :grid_node, grid_node)
    setprofile!(g, :grid_size, grid_size)
    setprofile!(g, :grid_bottom, grid_bottom)
    setprofile!(g, :grid_top, grid_top)
end


"""
    validategrid(g::AbstractSoilGrid)

Check if the soil grid specifications meet the requirements for calculation.
"""
function validategrid(g::AbstractSoilGrid)
    if !(g.texture in textures)
        throw(ArgumentError("Soil texture \"", g.texture, "\" not supported!"))
    end

    required_fields = (:temp, :moisture, :porosity)
    for col in required_fields
        if !(col in g.profiles.colindex.names)
            throw(ArgumentError("Missing required field \"$col\"!"))
        end
    end
end


end
