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
