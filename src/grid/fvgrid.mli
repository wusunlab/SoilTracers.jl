open Grid_sig

val textures : string list
(** A list of soil textures in the USDA classification. *)

(** 1D finite-volume soil grid. *)
module FVGrid : SOILGRID with type col = float array
