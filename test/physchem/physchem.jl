module TestPhysChem

using SoilTracers.PhysChem
using Base.Test

bindings = [
    :c2k,
    :k2c,
    :diffus_air,
    :diffus_water,
    :diffus_soil_air,
    :diffus_soil_water,
    :diffus_soil,
    :solub_co2,
    :solub_cos,
    :water_density,
    :water_dissoc,
    :hydrolysis_cos]

private_bindings = [
    :diffus_air_stp,
    :diffus_water_stp,
    :soil_shape_params]

@time @testset "PhysChem module bindings" begin
    for binding in bindings
        @test isdefined(binding)
    end

    # private bindings should not be exported
    for private_binding in private_bindings
        @test !isdefined(private_binding)
    end
end


end
