(* PERSON SEMANTICS: operations and facts derived from individual persons. *)

open Genealogy_types

let birth_year (ind : individual) =
  match ind.birth_date with
  | Exact_date { year; _ } -> Some year
  | Year_only year -> Some year
  | Present | Unknown -> None

let death_year (ind : individual) =
  match ind.death_date with
  | Exact_date { year; _ } -> Some year
  | Year_only year -> Some year
  | Present | Unknown -> None

let is_living (ind : individual) =
  match ind.death_date with
  | Present -> true
  | _ -> false