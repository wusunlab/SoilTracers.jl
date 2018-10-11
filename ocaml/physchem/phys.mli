(*
 * SoilTracers - A model for soil--atmosphere exchange of trace gases
 * Copyright (c) 2018 Wu Sun <wu.sun@ucla.edu>
 * License: MIT
 *)

(** A collection of basic physics functions. *)

open Constants

(** [c2k t] converts temperature [t] from Celsius to Kelvin. *)
val c2k : float -> float

(** [k2c t] converts temperature [t] from Kelvin to Celsius. *)
val k2c : float -> float

(** [water_density t] calculates water density (kg m{^ -3}) from temperature
    [t] (K). *)
val water_density : float -> float

(** [water_dissoc t] calculates water dissociation constant (p{i K}{_ w}) from
    temperature [t] (K). *)
val water_dissoc : float -> float
