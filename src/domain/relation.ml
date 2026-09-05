(* RELATION SEMANTICS: inverse, symmetric and other properties of relations. *)

open Genealogy_types

type t =
  | Parent_child of parent_child_relation
  | Spouse of spouse_relation

let parent_child
    ~id
    ~parent
    ~child
    ~relation_type
    ~source
    ~confidence =
  Parent_child
    {
      id;
      parent;
      child;
      relation_type;
      source;
      confidence;
    }

let spouse
    ~id
    ~person1
    ~person2
    ~marriage_date
    ~place
    ~source
    ~confidence =
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

let id relation =
  match relation with
  | Parent_child relation -> relation.id
  | Spouse relation -> relation.id

let involves person_id relation =
  match relation with
  | Parent_child relation ->
      relation.parent = person_id
      || relation.child = person_id

  | Spouse relation ->
      relation.person1 = person_id
      || relation.person2 = person_id

let parent relation =
  match relation with
  | Parent_child relation ->
      Some relation.parent
  | Spouse _ ->
      None

let child relation =
  match relation with
  | Parent_child relation ->
      Some relation.child
  | Spouse _ ->
      None

let spouse_pair relation =
  match relation with
  | Parent_child _ ->
      None

  | Spouse relation ->
      Some (relation.person1, relation.person2)

let relation_type relation =
  match relation with
  | Parent_child relation ->
      Some relation.relation_type
  | Spouse _ ->
      None

let confidence relation =
  match relation with
  | Parent_child relation ->
      relation.confidence
  | Spouse relation ->
      relation.confidence

let source relation =
  match relation with
  | Parent_child relation ->
      relation.source
  | Spouse relation ->
      relation.source

let marriage_date relation =
  match relation with
  | Parent_child _ ->
      None
  | Spouse relation ->
      Some relation.marriage_date

let place relation =
  match relation with
  | Parent_child _ ->
      None
  | Spouse relation ->
      relation.place