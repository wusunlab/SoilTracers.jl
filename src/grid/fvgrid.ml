open Grid_sig
open Grid_exn

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

module FVGrid : SOILGRID with type col = float array = struct
  type t =
    { level: int
    ; top: float
    ; bottom: float
    ; texture: string
    ; mutable profiles: Owl.Dataframe.t }

  type col = float array

  let get_level grid = grid.level

  let get_top grid = grid.top

  let get_bottom grid = grid.bottom

  let get_texture grid = grid.texture

  let get_fields grid = Owl.Dataframe.get_heads grid.profiles

  let exist_profile grid var = Array.mem var (get_fields grid)

  let get_profile grid var =
    let frame = grid.profiles in
    Owl.Dataframe.(
      if Array.mem var (get_heads frame) then
        unpack_float_series (get_col_by_name frame var)
      else raise (Grid_error ("profile of " ^ var ^ " not found")))

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
      else raise (Grid_error ("profile of " ^ var ^ " not found")))

  let add_profile_ grid var values =
    let frame = grid.profiles in
    Owl.Dataframe.(
      if Array.mem var (get_heads frame) then
        raise (Grid_error ("profile of " ^ var ^ " already exists"))
      else append_col frame (pack_float_series values) var)

  let del_profile_ grid var =
    let frame = grid.profiles in
    Owl.Dataframe.(
      if Array.mem var (get_heads frame) then
        remove_col frame (head_to_id frame var)
      else raise (Grid_error ("profile of " ^ var ^ " not found")))

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
    if level <= 0 || top = bottom then raise (Grid_error "incorrect grid spec")
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
      ; profiles= Owl.Dataframe.(make ~data:all_data all_fields) }

  let validate_grid grid =
    (List.mem grid.texture textures || raise (Grid_error "illegal texture"))
    && ( exist_profile grid "temp"
       || raise (Grid_error "temperature profile not found") )
    && ( exist_profile grid "moisture"
       || raise (Grid_error "moisture profile not found") )
    && ( exist_profile grid "porosity"
       || raise (Grid_error "porosity profile not found") )
end
