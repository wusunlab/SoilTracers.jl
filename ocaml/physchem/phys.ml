open Constants

let c2k = ( +. ) zero_celsius

let k2c t = t -. zero_celsius

let water_density t =
  let t_crit = 647.096 in
  (* critical temperature *)
  let rho_crit = 322.0 in
  (* critical density *)
  let theta = 1.0 -. t /. t_crit in
    (1.0 +. 1.99274064 *. theta ** (1.0 /. 3.0) +.
     1.09965342 *. theta ** (2.0 /. 3.0) -.
     0.510839303 *. theta ** (5.0 /. 3.0) -.
     1.7549349 *. theta ** (16.0 /. 3.0) -.
     45.5170352 *. theta ** (43.0 /. 3.0) -.
     6.74694450e5 *. theta ** (110.0 /. 3.0)) *. rho_crit

let water_dissoc t =
  let n = 6.0 in
  let rho_w = water_density t *. 1e-3 in  (* convert to g cm^-3 here *)
  let t_sq = t *. t in
  let z = rho_w *. exp(-0.864671 +. 8659.19 /. t -.
                       22786.2 /. t_sq *. rho_w ** (2.0 /. 3.0)) in
  let pK_w_G = 0.61415 +. 48251.33 /. t -. 67707.93 /. t_sq +.
               10102100.0 /. (t *. t_sq) in
    -2.0 *. n *. (log10(1.0 +. z) -. z /. (z +. 1.0) *. rho_w *.
                  (0.642044 -. 56.8534 /. t -. 0.375754 *. rho_w)) +.
        pK_w_G +. 2.0 *. log10(molar_weight_water)

let diffus_air_params = [
  "h2o", 2.178e-5;
  "co2", 1.381e-5;
  "ch4", 1.952e-5;
  "co", 1.807e-5;
  "so2", 1.089e-5;
  "o3", 1.444e-5;
  "nh3", 1.978e-5;
  "n2o", 1.436e-5;
  "no", 1.802e-5;
  "no2", 1.361e-5;
  "n2", 1.788e-5;
  "o2", 1.820e-5;
  "cos", 1.381e-5 /. 1.21;
]

let diffus_water_params = [
  "he", (818e-9, 11.70e3);
  "ne", (1608e-9, 14.84e3);
  "kr", (6393e-9, 20.20e3);
  "xe", (9007e-9, 21.61e3);
  "rn", (15877e-9, 23.26e3);
  "h2", (3338e-9, 16.06e3);
  "ch4", (3047e-9, 18.36e3);
  "co2", (5019e-9, 19.51e3);
  "cos", (4.735872481253359e-6, 19336.20405260121);
  "co", (0.407e-4, 24518.24);
  "no", (39.8e-4, 34978.24);
]

let soil_shape_params = [
  "sand", 4.05;
  "loamy sand", 4.38;
  "sandy loam", 4.9;
  "silt loam", 5.30;
  "loam", 5.39;
  "sandy clay loam", 7.12;
  "silty clay loam", 7.75;
  "clay loam", 8.52;
  "sandy clay", 10.4;
  "silty clay", 10.4;
  "clay", 11.4;
]

let diffus_air species t p =
  match List.assoc_opt species diffus_air_params with
  | None -> raise (Failure ("Species " ^ species ^ " not supported"))
  | Some d0 -> d0 *. (atm /. p) *. (t /. zero_celsius) ** 1.81

let diffus_water species t =
  match List.assoc_opt species diffus_water_params with
  | None -> raise (Failure ("Species " ^ species ^ " not supported"))
  | Some (pre_exp, e_act) -> pre_exp *. exp (-. e_act /. (gas_constant *. t))

let diffus_soil_air species texture t p theta_sat theta_w =
  match List.assoc_opt texture soil_shape_params with
  | None -> raise (Failure ("Soil texture " ^ texture ^ " not supported"))
  | Some b ->
      let theta_a = theta_sat -. theta_w in
      let tau_a = theta_a *. (theta_a /. theta_sat) ** (3.0 /. b) in
      diffus_air species t p *. theta_a *. tau_a

let diffus_soil_water species texture t theta_sat theta_w =
  match List.assoc_opt texture soil_shape_params with
  | None -> raise (Failure ("Soil texture " ^ texture ^ " not supported"))
  | Some b ->
      let tau_w = theta_w *. (theta_w /. theta_sat) ** (b /. 3.0 -. 1.0) in
      diffus_water species t *. theta_w *. tau_w

let diffus_soil species texture t p theta_sat theta_w =
  diffus_soil_air species texture t p theta_sat theta_w
  +. diffus_soil_water species texture t theta_sat theta_w
