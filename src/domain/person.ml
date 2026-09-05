(* PERSON SEMANTICS: operations and facts derived from individual persons. *)

open Genealogy_types

type t = person

let id person =
  person.id

let name person =
  person.name

let name_ru person =
  person.name_ru

let birth_date person =
  person.birth_date

let death_date person =
  person.death_date

let birth_place person =
  person.birth_place

let birth_year person =
  match person.birth_date with
  | Exact_date { year; _ } -> Some year
  | Year_only year -> Some year
  | Present -> None
  | Unknown -> None

let death_year person =
  match person.death_date with
  | Exact_date { year; _ } -> Some year
  | Year_only year -> Some year
  | Present -> None
  | Unknown -> None

let is_living person =
  match person.death_date with
  | Present -> true
  | _ -> false