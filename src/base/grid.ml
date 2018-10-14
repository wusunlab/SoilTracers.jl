(* open Owl *)

let textures =
  [ "sand"
  ; "loamy sand"
  ; "sandy loam"
  ; "silt loam"
  ; "loam"
  ; "sandy clay loam"
  ; "silty clay loam"
  ; "clay loam"
  ; "sandy clay"
  ; "silty clay"
  ; "clay" ]

module type SOILGRID = sig
  (** The soil grid. *)
  type t

  (** The column vector in soil grid profiles. *)
  type col

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

module FVGrid : SOILGRID = struct
  type grid_record =
    { level: int
    ; top: float
    ; bottom: float
    ; texture: string
    ; fields: string array
    ; mutable profiles: Owl.Dataframe.t }

  type t = grid_record

  (* type col =
  | BoolCol of bool array
  | IntCol of int array
  | FloatCol of float array
  | StringCol of string array
  | AnyCol *)

  type col = float array

  let exist_profile grid var =
    Array.mem var (Owl.Dataframe.get_heads grid.profiles)

  let get_profile grid var =
    let frame = grid.profiles in
    Owl.Dataframe.(
      if Array.mem var (get_heads frame) then
        unpack_float_series (get_col_by_name frame var)
      else raise (Failure "profile not found"))

  let set_profile_ grid var values =
    let frame = grid.profiles in
    Owl.Dataframe.(
      if Array.mem var (get_heads frame) then
        let var_id = head_to_id frame var in
        (* TODO: turn this to non-imperative code after set_col feature is
         * added in Owl.Dataframe *)
        for i = 0 to row_num frame do
          set frame i var_id (pack_float values.(i))
        done
      else raise (Failure "profile not found"))

  let add_profile_ grid var values =
    let frame = grid.profiles in
    Owl.Dataframe.(
      if Array.mem var (get_heads frame) then
        raise (Failure "profile already exists")
      else append_col frame (pack_float_series values) var)

  let del_profile_ grid var =
    let frame = grid.profiles in
    Owl.Dataframe.(
      if Array.mem var (get_heads frame) then
        remove_col frame (head_to_id frame var)
      else raise (Failure "profile not found"))

  (* helper functions to initialize grid positions *)
  let init_grid_node level top bottom =
    Array.init level (fun i ->
        Float.(
          exp ((of_int ((i + 1) * 5) /. of_int level) -. 5.)
          *. (bottom -. top)
          +. top) )

  let init_grid_size grid_node =
    Array.(
      let len = length grid_node in
      concat
        [ [|0.5 *. (grid_node.(0) +. grid_node.(1))|]
        ; map2
            (fun x y -> 0.5 *. (x -. y))
            (sub grid_node 2 (len - 2))
            (sub grid_node 1 (len - 2))
        ; [|grid_node.(len - 1) -. grid_node.(len - 2)|] ])

  let init_grid_bottom grid_node grid_size =
    Array.(
      let len = length grid_node in
      concat
        [ map2
            (fun x y -> 0.5 *. (x +. y))
            (sub grid_node 0 (len - 1))
            (sub grid_node 1 (len - 1))
        ; [|grid_node.(len - 1) +. (0.5 *. grid_size.(len - 1))|] ])

  let init_grid_positions level top bottom =
    let grid_node = init_grid_node level top bottom in
    let grid_size = init_grid_size grid_node in
    let grid_bottom = init_grid_bottom grid_node grid_size in
    let grid_top = Array.(map2 ( -. ) grid_bottom grid_size) in
    ( [|"grid_node"; "grid_size"; "grid_bottom"; "grid_top"|]
    , [|grid_node; grid_size; grid_bottom; grid_top|] )

  let make_grid ~level ~top ~bottom ~texture ~fields =
    if level <= 0 || top = bottom then raise (Failure "incorrect grid spec")
    else
      let init_series () =
        Owl.Dataframe.pack_float_series (Array.make level 0.)
      in
      let top, bottom =
        if top > bottom then (bottom, top) else (top, bottom)
      in
      let grid_fields, grid_profiles = init_grid_positions level top bottom in
      let all_data =
        Array.(
          append
            (map Owl.Dataframe.pack_float_series grid_profiles)
            (make (length fields) (init_series ())))
      in
      let all_fields = Array.append grid_fields fields in
      { level
      ; top
      ; bottom
      ; texture
      ; fields= all_fields
      ; profiles= Owl.Dataframe.(make ~data:all_data all_fields)}

  let validate_grid grid =
    (List.mem grid.texture textures || raise (Failure "grid texture illegal"))
    && ( exist_profile grid "temp"
       || raise (Failure "temperature profile not found") )
    && ( exist_profile grid "moisture"
       || raise (Failure "moisture profile not found") )
    && ( exist_profile grid "porosity"
       || raise (Failure "moisture profile not found") )
end
