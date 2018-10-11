(*
 * SoilTracers - A model for soil--atmosphere exchange of trace gases
 * Copyright (c) 2018 Wu Sun <wu.sun@ucla.edu>
 * License: MIT
 *)

(** A collection of basic physics functions. *)

open Constants

val c2k : float -> float
(** [c2k t] converts temperature [t] from Celsius to Kelvin. *)

val k2c : float -> float
(** [k2c t] converts temperature [t] from Kelvin to Celsius. *)

val water_density : float -> float
(** [water_density t] calculates water density (kg m{^ -3}) from temperature
    [t] (K). *)

val water_dissoc : float -> float
(** [water_dissoc t] calculates water dissociation constant (p{i K}{_ w}) from
    temperature [t] (K). *)

val diffus_air_params : (string * float) list
(** Gas diffusivities in air under STP condition (m{^ 2} s{^ -1}). *)

val diffus_water_params : (string * (float * float)) list
(** Pre-exponential factors and activation energies for gas diffusivities in
    water (m{^ 2} s{^ -1}). *)

val soil_shape_params : (string * float) list
(** Clapp--Hornberger shape parameters for tortuosity effect. *)

val diffus_air : string -> float -> float -> float
(** [diffus_air species t p] calculats the diffusivity of a gas [species]
    (m{^ 2} s{^ -1}) from temperature [t] (K) and pressure [p] (Pa).

    Support gas species including H{_ 2}O, CO{_ 2}, CH{_ 4}, CO, SO{_ 2},
    O{_ 3}, NH{_ 3}, N{_ 2}O, NO, NO{_ 2}, N{_ 2}, O{_ 2}, and COS. Note that
    [species] must be given in lower case. *)

val diffus_water : string -> float -> float
(** [diffus_water species t] calculates the diffusivity of a gas [species] in
    water (m{^ 2} s{^ -1}) from temperature [t] (K).

    Support gas species including He, Ne, Kr, Xe, Rn, H{_ 2}, CH{_ 4}, CO{_ 2},
    CO, NO, and COS. Note that [species] must be given in lower case. *)

val diffus_soil_air :
  string -> string -> float -> float -> float -> float -> float
(** [diffus_soil_air species texture t p theta_sat theta_w] calculates the
    diffusivity of a gas in soil air (m{^ 2} s{^ -1}). Support gas species
    including H{_ 2}O, CO{_ 2}, CH{_ 4}, CO, SO{_ 2}, O{_ 3}, NH{_ 3}, N{_ 2}O,
    NO, NO{_ 2}, N{_ 2}, O{_ 2}, and COS.

    args:
    - [species]: Chemical name of the gas species in lower case.
    - [texture]: Soil texture name in lower case.
    - [t]: Temperature (K).
    - [p]: Ambient pressure (Pa).
    - [theta_sat]: Total porosity of the soil (m{^ 3} m{^ -3}).
    - [theta_w]: Water-filled porosity of the soil (m{^ 3} m{^ -3}). *)

val diffus_soil_water : string -> string -> float -> float -> float -> float
(** [diffus_soil_water species texture t theta_sat theta_w] calculates the
    diffusivity of a gas in soil water (m{^ 2} s{^ -1}). Support gas species
    including He, Ne, Kr, Xe, Rn, H{_ 2}, CH{_ 4}, CO{_ 2}, CO, NO, and COS.

    args:
    - [species]: Chemical name of the gas species in lower case.
    - [texture]: Soil texture name in lower case.
    - [t]: Temperature (K).
    - [theta_sat]: Total porosity of the soil (m{^ 3} m{^ -3}).
    - [theta_w]: Water-filled porosity of the soil (m{^ 3} m{^ -3}). *)

val diffus_soil : string -> string -> float -> float -> float -> float -> float
(** [diffus_soil species texture t p theta_sat theta_w] calculates the total
    diffusivity in soil gaseous and aqueous phases (m{^ 2} s{^ -1}). Support
    gas species including CO{_ 2}, CO, NO, CH{_ 4}, and COS.

    args:
    - [species]: Chemical name of the gas species in lower case.
    - [texture]: Soil texture name in lower case.
    - [t]: Temperature (K).
    - [p]: Ambient pressure (Pa).
    - [theta_sat]: Total porosity of the soil (m{^ 3} m{^ -3}).
    - [theta_w]: Water-filled porosity of the soil (m{^ 3} m{^ -3}). *)
