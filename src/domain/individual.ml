(* INDIVIDUAL SEMANTICS: operations and facts derived from an individual. *)

open Genealogy_types

let birth_year individual_value =
  match individual_value.birth_date with
  | Exact_date { year; _ } -> Some year
  | Year_only year -> Some year
  | Present | Unknown -> None

let death_year individual_value =
  match individual_value.death_date with
  | Exact_date { year; _ } -> Some year
  | Year_only year -> Some year
  | Present | Unknown -> None

let is_living individual_value =
  match individual_value.death_date with
  | Present -> true
  | _ -> false