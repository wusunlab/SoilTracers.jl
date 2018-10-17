module type SOILGRID = sig
  (** The soil grid. *)
  type t

  (** The column vector in soil grid profiles. *)
  type col

  val get_level : t -> int
  (** [get_level grid] returns the number of vertical levels of the [grid]. *)

  val get_top : t -> float
  (** [get_top grid] returns the depth of the top of the [grid]. *)

  val get_bottom : t -> float
  (** [get_bottom grid] returns the depth of the bottom of the [grid]. *)

  val get_texture : t -> string
  (** [get_texture grid] returns the soil texture. *)

  val get_fields : t -> string array
  (** [get_fields grid] returns the variable fields in the profiles of
      [grid]. *)

  val exist_profile : t -> string -> bool
  (** [exist_profile grid var] checks if [var] exists in the profiles of
      [grid]. *)

  val get_profile : t -> string -> col
  (** [get_profile grid var] extracts the profile of [var] from [grid]. *)

  val set_profile_ : t -> string -> col -> unit
  (** [set_profile_ grid var values] sets the profile of [var] to [values].
      This requires that [var] exists in the profiles of [grid]. *)

  val add_profile_ : t -> string -> col -> unit
  (** [add_profile_ grid var values] adds a new profile of [var] to [values].
      This cannot be used to update an existing profile of [var] in [grid]. *)

  val del_profile_ : t -> string -> unit
  (** [del_profile_ grid var] removes the profile of [var] from [grid]. *)

  val make_grid :
       level:int
    -> top:float
    -> bottom:float
    -> texture:string
    -> fields:string array
    -> t
  (** [make_grid ~level ~top ~bottom ~texture ~fields] initializes a soil grid
      according to specifications, where
      - [level] is the number of vertical levels
      - [top] is the depth of the top of the soil column
      - [bottom] is the depth of the bottom of the soil column
      - [texture] is the soil texture
      - [fields] are names of vertical profiles, e.g.,
        [\[| "temp"; "moisture"; ... |\]]. *)

  val validate_grid : t -> bool
  (** [validate_grid grid] checks if the grid satisfies requirements. *)
end
