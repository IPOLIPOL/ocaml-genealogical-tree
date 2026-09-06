(* Validation checks asserted genealogy facts before they become a usable graph. *)

open Genealogy_types
open Relation

type error =
  | Empty_individual_id of iri
  | Duplicate_individual_id of iri
  | Empty_relation_id of iri
  | Duplicate_relation_id of iri
  | Unknown_individual of iri
  | Self_parent of iri
  | Self_spouse of iri
  | Birth_after_death of iri
  | Parent_born_after_child of { parent : iri; child : iri }
  | Parent_child_cycle of iri list

let string_of_error = function
  | Empty_individual_id id -> "empty individual id: " ^ id
  | Duplicate_individual_id id -> "duplicate individual id: " ^ id
  | Empty_relation_id id -> "empty relation id: " ^ id
  | Duplicate_relation_id id -> "duplicate relation id: " ^ id
  | Unknown_individual id -> "unknown individual: " ^ id
  | Self_parent id -> "individual cannot be their own parent: " ^ id
  | Self_spouse id -> "individual cannot be their own spouse: " ^ id
  | Birth_after_death id -> "birth date is after death date: " ^ id
  | Parent_born_after_child { parent; child } ->
      Printf.sprintf "parent %s is born after child %s" parent child
  | Parent_child_cycle ids ->
      "parent-child cycle: " ^ String.concat " -> " ids

let year_of_date = function
  | Exact_date { year; _ } -> Some year
  | Year_only year -> Some year
  | Present | Unknown -> None

let validate_individuals (individuals : individual list) =
  let errors = ref [] in
  let seen = Hashtbl.create (List.length individuals) in
  List.iter
    (fun (individual : individual) ->
      if String.trim individual.id = "" then
        errors := Empty_individual_id individual.id :: !errors;
      if Hashtbl.mem seen individual.id then
        errors := Duplicate_individual_id individual.id :: !errors
      else
        Hashtbl.add seen individual.id ();
      match
        year_of_date individual.birth_date, year_of_date individual.death_date
      with
      | Some birth, Some death when birth > death ->
          errors := Birth_after_death individual.id :: !errors
      | _ -> ())
    individuals;
  List.rev !errors

let relation_id = function
  | Parent_child parent_child -> parent_child.id
  | Spouse spouse -> spouse.id

let validate_relation_ids (relations : relation list) =
  let errors = ref [] in
  let seen = Hashtbl.create (List.length relations) in
  List.iter
    (fun relation ->
      let id = relation_id relation in
      if String.trim id = "" then
        errors := Empty_relation_id id :: !errors;
      if Hashtbl.mem seen id then
        errors := Duplicate_relation_id id :: !errors
      else
        Hashtbl.add seen id ())
    relations;
  List.rev !errors

let validate_references
    (individuals : individual list) (relations : relation list) =
  let known = Hashtbl.create (List.length individuals) in
  List.iter
    (fun (individual : individual) ->
      Hashtbl.replace known individual.id ())
    individuals;
  let errors = ref [] in
  let require_individual id =
    if not (Hashtbl.mem known id) then
      errors := Unknown_individual id :: !errors
  in
  List.iter
    (function
      | Parent_child parent_child ->
          require_individual parent_child.parent;
          require_individual parent_child.child;
          if parent_child.parent = parent_child.child then
            errors := Self_parent parent_child.parent :: !errors
      | Spouse spouse ->
          require_individual spouse.person1;
          require_individual spouse.person2;
          if spouse.person1 = spouse.person2 then
            errors := Self_spouse spouse.person1 :: !errors)
    relations;
  List.rev !errors

let validate_parent_chronology
    (individuals : individual list) (relations : relation list) =
  let by_id = Hashtbl.create (List.length individuals) in
  List.iter
    (fun (individual : individual) ->
      Hashtbl.replace by_id individual.id individual)
    individuals;
  let errors = ref [] in
  List.iter
    (function
      | Parent_child parent_child when parent_child.confidence <> Rejected ->
          begin match
            Hashtbl.find_opt by_id parent_child.parent,
            Hashtbl.find_opt by_id parent_child.child
          with
          | Some parent, Some child ->
              begin match
                year_of_date parent.birth_date, year_of_date child.birth_date
              with
              | Some parent_year, Some child_year when parent_year > child_year ->
                  errors :=
                    Parent_born_after_child
                      {
                        parent = parent_child.parent;
                        child = parent_child.child;
                      }
                    :: !errors
              | _ -> ()
              end
          | _ -> ()
          end
      | _ -> ())
    relations;
  List.rev !errors

let detect_parent_cycles (relations : relation list) =
  let children_of = Hashtbl.create 16 in
  let add_edge parent child =
    let existing =
      match Hashtbl.find_opt children_of parent with
      | Some children -> children
      | None -> []
    in
    Hashtbl.replace children_of parent (child :: existing)
  in
  List.iter
    (function
      | Parent_child parent_child when parent_child.confidence <> Rejected ->
          add_edge parent_child.parent parent_child.child
      | _ -> ())
    relations;

  let state = Hashtbl.create 16 in
  let errors = ref [] in

  let rec dfs path node =
    match Hashtbl.find_opt state node with
    | Some `Done -> ()
    | Some `Active ->
        let rec cycle_from accumulated = function
          | [] -> List.rev (node :: accumulated)
          | current :: _ when current = node ->
              List.rev (node :: current :: accumulated)
          | current :: remaining ->
              cycle_from (current :: accumulated) remaining
        in
        errors :=
          Parent_child_cycle (cycle_from [] (List.rev (node :: path)))
          :: !errors
    | None ->
        Hashtbl.replace state node `Active;
        let children =
          match Hashtbl.find_opt children_of node with
          | Some children -> children
          | None -> []
        in
        List.iter (fun child -> dfs (node :: path) child) children;
        Hashtbl.replace state node `Done
  in

  Hashtbl.iter (fun node _ -> dfs [] node) children_of;
  List.rev !errors

let validate
    ~(individuals : individual list) ~(relations : relation list) =
  validate_individuals individuals
  @ validate_relation_ids relations
  @ validate_references individuals relations
  @ validate_parent_chronology individuals relations
  @ detect_parent_cycles relations