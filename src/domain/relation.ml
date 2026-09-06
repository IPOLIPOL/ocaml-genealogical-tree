(* RELATION SEMANTICS – minimal: sum type, constructors, one non-trivial helper. *)

open Genealogy_types

type relation =
  | Parent_child of parent_child_relation
  | Spouse of spouse_relation

let parent_child ~id ~parent ~child ~relation_type ~source ~confidence =
  Parent_child
    {
      id;
      parent;
      child;
      relation_type;
      source;
      confidence;
    }

let spouse ~id ~person1 ~person2 ~marriage_date ~place ~source ~confidence =
  Spouse
    {
      id;
      person1;
      person2;
      marriage_date;
      place;
      source;
      confidence;
    }

let involves individual_id = function
  | Parent_child { parent; child; _ } ->
      parent = individual_id || child = individual_id
  | Spouse { person1; person2; _ } ->
      person1 = individual_id || person2 = individual_id