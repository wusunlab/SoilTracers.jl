open Owl

let evolver_CN conc alpha beta gamma dt =
  let nr, nc = Mat.shape conc in
  if
    nc != 1 || nr = 1
    || Mat.shape alpha != (nr, nc)
    || Mat.shape beta != (nr, nc)
    || Mat.shape gamma != (nr, nc)
  then raise (Failure "shapes of input column vectors do not match")
  else
    (* coefficient matrices *)
    let alpha_coefs = Mat.diagm alpha in
    let beta_slice = Mat.get_slice [[1; -1]] beta in
    let beta_diag = Mat.(map ( ~-. ) ((beta_slice @= zeros 1 1) + beta)) in
    let beta_coefs =
      Mat.(
        diagm ~k:0 beta_diag + diagm ~k:1 beta_slice + diagm ~k:~-1 beta_slice)
    in
    let inv_coefs =
      Linalg.D.(pinv Mat.(2.0 $* alpha_coefs - (dt $* beta_coefs)))
    in
    Mat.(
      inv_coefs
      *@ ( ((2.0 $* alpha_coefs + (dt $* beta_coefs)) *@ conc)
         + (2.0 *. dt $* gamma) ))

let k_m = 3.9e-2
let delta_G_a = 8.41e4
let delta_H_d = 3.59e5
let delta_S_d = 1.236e3
let q10 = 1.0

(* let solver_CN_fcos texture grid_node grid_size dt cos_s cos_a t_s t_a theta_sat theta_w p v_max_cos_sink v_max_cos_source duration ?(max_iter=100000) ?(rtol=1e-5) =
  let (n, _) = Mat.shape cos_s in
  let max_iter_actual = min max_iter (ceil duration /. dt) in
  let k_cos = Mat.(map solub_cos t_s) in
  let d_a_cos = diffus_air "cos" t_a p in
  let d_s_cos = ...  (* how to map multiple arguments??? *) in
  let alpha = Mat.((theta_sat - theta_w + k_cos * theta_w) * grid_size) in
  let beta = d_s_cos in
   *)
