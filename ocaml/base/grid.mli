module type SOILGRID = sig
  (** Soil grid type. *)
  type t

  (** A column vector in the soil grid profiles. *)
  type col

  val exist_profile : t -> string -> bool
  (** Check the existence of a variable in the soil profiles. *)

  val get_profile : t -> string -> col
  (** Get the vertical profile of a variable. *)

  val set_profile_ : t -> string -> col -> unit
  (** Set the vertical profile of a variable. *)

  val add_profile_ : t -> string -> col -> unit
  (** Add the vertical profile of a variable to the soil grid. *)

  val del_profile_ : t -> string -> unit
  (** Remove a variable from the soil grid. *)

  val make_grid :
    level:int -> top:float -> bottom:float -> texture:string ->
    fields:string array -> t
  (** Initialize a soil grid according to specifications. *)

  val validate_grid : t -> bool
  (** Check if the grid satisfies physical requirements. *)
end
