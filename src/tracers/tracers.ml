open Soiltracers_grid.Grid_sig
open Soiltracers_lib

module type TRACER_ENV = sig
  (* environmental parameters for the tracer *)

  val texture : string

  val source_params : (string * float) list
end

module COS (E : TRACER_ENV) (G : SOILGRID with type col = float array) = struct
  type t = G.t

  let name = "cos"

  let texture = E.texture

  let source_params = E.source_params

  let get_param p = List.assoc p source_params

  let solub grid = Array.map Chem.solub_cos (G.get_profile grid "temperature")

  (* this is wrong; need an air temperature field in soilgrid. *)
  let diffus_air grid =
    Array.map
      (fun x -> Phys.diffus_air name x 101325.0)
      (G.get_profile grid "temperature")

  let diffus_soil grid =
    let diffus_soil_partial =
      Array.map2
        (fun theta_sat theta_w x ->
          Phys.diffus_soil name E.texture x 101325.0 theta_sat theta_w )
        (G.get_profile grid "porosity")
        (G.get_profile grid "moisture")
    in
    Array.map2 ( |> ) (G.get_profile grid "temperature") diffus_soil_partial

  let source grid =
    let v_max_source = get_param "v_max_source" in
    let q10 = get_param "q10" in
    let t_ref = get_param "t_ref" in
    Array.map
      (fun x -> v_max_source *. Chem.q10_fun q10 x t_ref)
      (G.get_profile grid "temperature")

  let sink grid =
    let v_max_sink = get_param "v_max_sink" in
    let k_m = get_param "k_m" in
    let delta_G_a = get_param "delta_G_a" in
    let delta_H_d = get_param "delta_H_d" in
    let delta_S_d = get_param "delta_S_d" in
    let t_ref = get_param "t_ref" in
    let soil_temp = G.get_profile grid "temperature" in
    let cos_conc = G.get_profile grid "cos" in
    let rel_moisture =
      Array.map2 ( /. )
        (G.get_profile grid "moisture")
        (G.get_profile grid "porosity")
    in
    let sink_partial ts c =
      -.v_max_sink *. c /. (k_m +. c)
      *. Chem.enzyme_temp_dependence delta_G_a delta_H_d delta_S_d ts t_ref
    in
    Array.map2 ( *. ) (Array.map2 sink_partial soil_temp cos_conc) rel_moisture
end
