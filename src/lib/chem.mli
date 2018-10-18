(*
 * SoilTracers - A model for soil--atmosphere exchange of trace gases
 * Copyright (c) 2018 Wu Sun <wu.sun@ucla.edu>
 * License: MIT
 *)

(** A collection of basic chemistry functions. *)

val solub_co2 : float -> float
(** [solub_co2 t] calculates the Bunsen solubility of CO{_ 2} (dimensionless)
    in freshwater from temperature [t] (K). *)

val solub_co2_sal : float -> float -> float
(** [solub_co2_sal t sal] calculates the Bunsen solubility of CO{_ 2}
    (dimensionless) in saline water from temperature [t] (K) and salinity [sal]
    (per mil). *)

val solub_cos : float -> float
(** [solub_cos t] calculates the Bunsen solubility of COS (dimensionless) in
    freshwater from temperature [t] (K). *)

val hydrolysis_cos : float -> float -> float
(** [hydrolysis t pH] calculates the hydrolysis rate coefficient of COS
    (s{^ -1}) in freshwater from temperature [t] (K) and [pH]. *)

val q10_fun : float -> float -> float -> float
(** [q10_fun q10 t t_ref] calculates the ratio of reaction rate at a given
    temperature [t] (K) to that at a reference temperature [t_ref] (K) using a
    {i Q}{_ 10} function defined by [q10]. *)

val enzyme_temp_dependence : float -> float -> float -> float -> float -> float
(** [enzyme_temp_dependence delta_G_a delta_H_d delta_S_d t t_ref] calculates
    the ratio of reaction rate at a given temperature [t] (K) to that at
    a reference temperature [t_ref] (K) for an enzyme reaction with a
    temperature optimum.

    args:
    - [delta_G_a]: The standard Gibbs free energy of activation of the active
      state of the enzyme (J mol{^ -1}).
    - [delta_H_d]: The standard enthalpy change when the enzyme switches from
      the active to the deactivated state (J mol{^ -1}).
    - [delta_S_d]: The standard entropy change when the enzyme switches from
      the active to the deactivated state (J mol{^ -1} K{^ -1}).
    - [t]: Temperature (K).
    - [t_ref]: A reference temperature (K). *)

val enzyme_temp_optimum : float -> float -> float -> float
(** [enzyme_temp_optimum delta_G_a delta_H_d delta_S_d] calculates the
    temperature optimum of an enzyme reaction (K) from energetic parameters.

    args:
    - [delta_G_a]: The standard Gibbs free energy of activation of the active
      state of the enzyme (J mol{^ -1}).
    - [delta_H_d]: The standard enthalpy change when the enzyme switches from
      the active to the deactivated state (J mol{^ -1}).
    - [delta_S_d]: The standard entropy change when the enzyme switches from
      the active to the deactivated state (J mol{^ -1} K{^ -1}).
*)
