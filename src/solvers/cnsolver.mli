open Owl

(** Evolve the concentration profile by one time step. *)
val evolver_CN :
  Mat.mat ->
  Mat.mat ->
  Mat.mat ->
  Mat.mat -> float -> (float, Bigarray.float64_elt) Owl_dense_matrix_generic.t
