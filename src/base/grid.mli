val textures : string list
module type SOILGRID =
  sig
    type t
    type col
    val exist_profile : t -> string -> bool
    val get_profile : t -> string -> col
    val set_profile_ : t -> string -> col -> unit
    val add_profile_ : t -> string -> col -> unit
    val del_profile_ : t -> string -> unit
    val make_grid :
      level:int ->
      top:float -> bottom:float -> texture:string -> fields:string array -> t
    val validate_grid : t -> bool
  end
module FVGrid : SOILGRID
