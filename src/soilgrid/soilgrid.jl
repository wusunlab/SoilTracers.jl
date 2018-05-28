"""Types of the soil grid."""
module SoilGrid

using DataFrames

export AbstractSoilGrid, FVGrid, getprofile, setprofile!, addprofile!


"""An abstract supertype for soil grids."""
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
            error("Number of grid levels must be a positive integer!")
        end

        if top == bottom
            error("Top and bottom depths cannot be the same!")
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


"""Access the vertical profile of a variable in a soil grid."""
function getprofile(g::T, name::Symbol) where T <: AbstractSoilGrid
    if name in g.profiles.colindex.names
        return g.profiles[name]
    else
        error("The soil grid has no attribute of $name\!")
    end
end


"""Set the vertical profile of a variable in a soil grid."""
function setprofile!(g::T, name::Symbol, val) where T <: AbstractSoilGrid
    if name in g.profiles.colindex.names
        g.profiles[name] = val
    else
        error("The soil grid has no attribute of $name\!")
    end
end


"""Add the vertical profile of a variable in a soil grid."""
function addprofile!(g::T, name::Symbol, val=0.0) where T <: AbstractSoilGrid
    if name in g.profiles.colindex.names
        error("The attribute $name already exists in the soil grid!")
    else
        g.profiles[name] = val
    end
end


"""Remove the vertical profile of a variable in a soil grid."""
function delprofile!(g::T, name::Symbol) where T <: AbstractSoilGrid
    if name in g.profiles.colindex.names
        delete!(g.profiles, name)
    else
        error("The soil grid has no attribute of $name\!")
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


end
