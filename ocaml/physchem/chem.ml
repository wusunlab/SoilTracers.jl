open Constants
open Phys

let solub_co2 t =
  let t' = t *. 0.01 in
  (* a transferred scale *)
  exp(-. 58.0931 +. 90.5069 /. t' +. 22.2940 *. log(t'))
  *. 1e3 /. (air_concentration t atm)

let solub_co2_sal t sal =
  let t' = t *. 0.01 in
  (* a transferred scale *)
  exp(-. 58.0931 +. 90.5069 /. t' +. 22.2940 *. log(t') +.
      sal *. (0.027766 -. 0.025888 *. t' +. 0.0050578 *. t' *. t'))
  *. 1e3 /. (air_concentration t atm)

let solub_cos t = t *. exp(4050.32 /. t -. 20.0007)

let hydrolysis_cos t pH =
  let t_ref = 298.15 in
  let t_diff = 1.0 /. t -. 1.0 /. t_ref in
  let c_OH = 10.0 ** (pH -. water_dissoc t) in
  2.11834513803e-5 *. exp(-. 10418.3722377 *. t_diff)
  +. 14.16881179 *. exp(-. 6469.11889197 *. t_diff) *. c_OH

(* TODO: co2 source from respiration *)
