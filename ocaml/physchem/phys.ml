open Constants

let c2k = (+.) zero_celsius

let k2c t = t -. zero_celsius

let water_density t =
  let t_crit = 647.096 in  (* critical temperature *)
  let rho_crit = 322.0 in  (* critical density *)
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
