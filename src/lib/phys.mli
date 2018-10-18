(*
 * SoilTracers - A model for soil--atmosphere exchange of trace gases
 * Copyright (c) 2018 Wu Sun <wu.sun@ucla.edu>
 * License: MIT
 *)

(** A collection of basic physics functions.

    References

    - \[WP02\] Wagner, W. and Pruß, A. (2002). The IAPWS Formulation 1995 for
      the thermodynamic properties of ordinary water substance for general and
      scientific use. {i J. Phys. Chem. Ref. Data}, 31, 387--535.
      {{: https://doi.org/10.1063/1.1461829} \[DOI\]}
    - \[BL06\] Bandura, A. V. and Lvov, S. N. (2006). The ionization constant
      of water over wide ranges of temperature and density. {i J. Phys. Chem.
      Ref. Data}, 35, 15--30. {{: https://doi.org/10.1063/1.1928231} \[DOI\]}
    - \[M98\] Massman, W. J. (1998). A review of the molecular diffusivities of
      H{_ 2}O, CO{_ 2}, CH{_ 4}, CO, O{_ 3}, SO{_ 2}, NH{_ 3}, N{_ 2}O, NO, and
      NO{_ 2} in air, O{_ 2} and N{_ 2} near STP. {i Atmos. Environ.}, 32(6),
      1111--1127. {{: https://doi.org/10.1016/S1352-2310(97)00391-9} \[DOI\]}
    - \[SKS10\] Seibt, U., Kesselmeier, J., Sandoval-Soto, L., Kuhn, U., and
      Berry, J. A. (2010). A kinetic analysis of leaf uptake of COS and its
      relation to transpiration, photosynthesis and carbon isotope
      fractionation. {i Biogeosci.}, 7, 333--341.
      {{: https://doi.org/10.5194/bg-7-333-2010} \[DOI\]}
    - \[JHD87\] Jähne, B., Heinz, G., and Dietrich, W. (1987). Measurement of
      the diffusion coefficients of sparingly soluble gases in water. {i J.
      Geophys. Res.}, 92(C10), 10767--10776.
      {{: https://doi.org/10.1029/JC092iC10p10767} \[DOI\]}
    - \[WH68\] Wise, D. L. and Houghton, G. (1968). Diffusion coefficients of
      neon, krypton, xenon, carbon monoxide and nitric oxide in water at 10--6O
      C. {i Chem. Eng. Sci.}, 23, 1211--1216.
      {{: https://doi.org/10.1016/0009-2509(68)89029-3} \[DOI\]}
    - \[UFU96\] Ulshöfer, V. S., Flöck, O. R., Uher, G., and Andreae, M. O.
      (1996). Photochemical production and air-sea exchange of sulfide in the
      eastern Mediterranean Sea. {i Mar. Chem.}, 53, 25--39.
      {{: https://doi.org/10.1016/0304-4203(96)00010-2} \[DOI\]}
    - \[CH78\] Clapp, R. B. and Hornberger, G. M. (1978). Empirical equations
      for some soil hydraulic properties. {i Water Resources Res.}, 14(4),
      601--604. {{: https://doi.org/10.1029/WR014i004p00601} \[DOI\]}
    - \[MOK03\] Moldrup, P., Olesen, T., Komatsu, T, Yoshikawa, S, Schjønning,
      P, and Rolston, D. E. (2003). Modeling diffusion and reaction in soils:
      X. A unifying model for solute and gas diffusivity in unsaturated soil.
      {i Soil Sci.}, 168(5), 321--337.
      {{: https://doi.org/10.1097/01.ss.0000070907.55992.3c} \[DOI\]}
*)

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

val air_concentration : float -> float -> float
(** [air_concentration t p] calculates the molar concentration of air
    (mol m{^ -3}) from temperature [t] (K) and pressure [p] (Pa). *)

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
