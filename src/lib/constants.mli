(*
 * SoilTracers - A model for soil--atmosphere exchange of trace gases
 * Copyright (c) 2018 Wu Sun <wu.sun@ucla.edu>
 * License: MIT
 *)

(** A collection of physical constants.

    References

    - \[MNT16a\] Mohr, P. J., Newell, D. B., and Taylor, B. N. (2016). CODATA
      recommended values of the fundamental physical constants: 2014. {i Rev.
      Mod. Phys.}, 88, 035009, 1--73.
      {{: https://doi.org/10.1103/RevModPhys.88.035009} \[DOI\]}
    - \[MNT16b\] Mohr, P. J., Newell, D. B., and Taylor, B. N. (2016). CODATA
      recommended values of the fundamental physical constants: 2014. {i J.
      Phys. Chem. Ref. Data}, 45, 043102, 1--74.
      {{: https://doi.org/10.1063/1.4954402} \[DOI\]}
*)

(** Zero Celsius (K). *)
val zero_celsius : float

(** Molar gas constant (J K{^ -1} mol{^ -1}). *)
val gas_constant : float

(** Standard acceleration of gravity on earth (m s{^ -2}). *)
val gravity : float

(** Standard atmospheric pressure (Pa). *)
val atm : float

(** Molar mass of water (kg mol{^ -1}). *)
val molar_weight_water : float
