module TestSoilGrid

using Base.Test
using DataFrames
using SoilTracers.SoilGrid


@time @testset "SoilGrid constructor" begin
    required_fields =
        Set(Symbol[:grid_size, :grid_top, :grid_bottom, :grid_node])

    # test case: empty soil grid
    grid1 = FVGrid()
    @test grid1.level > 0
    @test grid1.top < grid1.bottom
    @test isa(grid1.texture, String)
    @test Set(grid1.profiles.colindex.names) >= required_fields
    @test all(grid1.profiles[:grid_top] .< grid1.profiles[:grid_node])
    @test all(grid1.profiles[:grid_node] .< grid1.profiles[:grid_bottom])

    # test case: a soil grid with more fields
    grid2 = FVGrid(
        25, 0., 1., "sandy loam", [],
        ["temp", "moisture", "porosity", "pH", "orgC"],
        ["co2"])
    @test grid2.level > 0
    @test grid2.top < grid2.bottom
    @test isa(grid2.texture, String)
    @test Set(grid2.profiles.colindex.names) >= required_fields
    @test all(grid2.profiles[:grid_top] .< grid2.profiles[:grid_node])
    @test all(grid2.profiles[:grid_node] .< grid2.profiles[:grid_bottom])
    @test all([
        in(field, grid2.profiles.colindex.names) for
        field in Symbol.(["temp", "moisture", "porosity", "pH", "orgC"])])

    # test case: ensure that top depth < bottom depth always true
    grid3 = FVGrid(20, 1.5, 0.)
    @test grid3.level > 0
    @test grid3.top < grid3.bottom
end


@time @testset "SoilGrid methods" begin
    grid = FVGrid(
        25, 0., 1., "sandy loam", [],
        ["temp", "moisture", "porosity", "pH", "orgC"],
        ["co2"])

    # getprofile
    co2_profile = getprofile(grid, :co2)
    @test typeof(co2_profile) <: AbstractArray
    @test typeof(co2_profile) <: DataArray
    @test length(co2_profile) == grid.level
    @test_throws ArgumentError getprofile(grid, :cos)

    # setprofile!
    co2 = 400.  # arbitrary unit
    setprofile!(grid, :co2, co2)
    co2_profile = getprofile(grid, :co2)
    @test all(isapprox.(co2_profile, co2))
    @test_throws ArgumentError setprofile!(grid, :cos, co2)

    # addprofile!
    cos = 500.  # arbitrary unit
    @test_throws ArgumentError addprofile!(grid, :co2)
    addprofile!(grid, :cos)
    @test :cos in grid.profiles.colindex.names

    # delprofile!
    delprofile!(grid, :cos)
    @test !(:cos in grid.profiles.colindex.names)
    @test_throws ArgumentError delprofile!(grid, :cos)

    # validategrid
    @test validategrid(grid) === nothing
    delprofile!(grid, :temp)
    @test_throws ArgumentError validategrid(grid)
end


end
