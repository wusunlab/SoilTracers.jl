"""Parameter sets for COS hydrolysis rate coefficient."""
params_hydrolysis_cos = Dict(
    "e89" => [2.11834513803e-5, 10418.3722377, 14.16881179, 6469.11889197],
    "rc94" => [1.63838819502e-5, 6444.02904777, 11.7115101829, 2427.27401921],
    "k03" => [9.60317126325e-6, 12110., 19.1176322696, 11580.]
)

function hydrolysis_cos(temp, pH=7.; seawater::Bool=false, method="e89")
    T_ref = 298.15
    method = seawater ? "rc94" : method  # only "rc94" applies to seawater
    params = get(params_hydrolysis_cos, method, params_hydrolysis_cos["e89"])

    c_OH = 10. ^ (pH - 14.)  # @TODO: need to implement water_dissoc()

    # @TODO: this expression needs to be optimized
    return params[1] * exp(-params[2] * (1. / temp - 1. / T_ref)) +
        params[3] * exp(-params[4] * (1. / temp - 1. / T_ref)) * c_OH
end
