(* RELATION SEMANTICS: heterogeneous relation type and derived relation operations. *)

open Genealogy_types

type relation =
  | Parent_child of parent_child_relation
  | Spouse of spouse_relation

let involves individual_id = function
  | Parent_child { parent; child; _ } ->
      parent = individual_id
      || child = individual_id

  | Spouse { individual1_id; individual2_id; _ } ->
      individual1_id = individual_id
      || individual2_id = individual_id