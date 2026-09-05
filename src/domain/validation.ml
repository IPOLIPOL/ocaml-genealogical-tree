(* Validation checks asserted genealogy facts before they become a usable graph. *)

open Genealogy_types
open Relation

type error =
  | Empty_person_id of iri
  | Duplicate_person_id of iri
  | Empty_relation_id of iri
  | Duplicate_relation_id of iri
  | Unknown_person of iri
  | Self_parent of iri
  | Self_spouse of iri
  | Birth_after_death of iri
  | Parent_born_after_child of { parent : iri; child : iri }
  | Parent_child_cycle of iri list

let string_of_error = function
  | Empty_person_id id -> "empty person id: " ^ id
  | Duplicate_person_id id -> "duplicate person id: " ^ id
  | Empty_relation_id id -> "empty relation id: " ^ id
  | Duplicate_relation_id id -> "duplicate relation id: " ^ id
  | Unknown_person id -> "unknown person: " ^ id
  | Self_parent id -> "person cannot be their own parent: " ^ id
  | Self_spouse id -> "person cannot be their own spouse: " ^ id
  | Birth_after_death id -> "birth date is after death date: " ^ id
  | Parent_born_after_child { parent; child } ->
      Printf.sprintf "parent %s is born after child %s" parent child
  | Parent_child_cycle ids ->
      "parent-child cycle: " ^ String.concat " -> " ids

let year_of_date = function
  | Exact_date { year; _ } -> Some year
  | Year_only year -> Some year
  | Present | Unknown -> None

let validate_persons (people : person list) =
  let errors = ref [] in
  let seen = Hashtbl.create (List.length people) in
  List.iter
    (fun (p : person) ->
      if String.trim p.id = "" then
        errors := Empty_person_id p.id :: !errors;
      if Hashtbl.mem seen p.id then
        errors := Duplicate_person_id p.id :: !errors
      else
        Hashtbl.add seen p.id ();
      match year_of_date p.birth_date, year_of_date p.death_date with
      | Some birth, Some death when birth > death ->
          errors := Birth_after_death p.id :: !errors
      | _ -> ())
    people;
  List.rev !errors

let relation_id (relation : Relation.t) =
  match relation with
  | Parent_child r -> r.id
  | Spouse r -> r.id

let validate_relation_ids (relations : Relation.t list) =
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

let validate_references (people : person list) (relations : Relation.t list) =
  let known = Hashtbl.create (List.length people) in
  List.iter (fun (p : person) -> Hashtbl.replace known p.id ()) people;
  let errors = ref [] in
  let require_person id =
    if not (Hashtbl.mem known id) then
      errors := Unknown_person id :: !errors
  in
  List.iter
    (function
      | Parent_child r ->
          require_person r.parent;
          require_person r.child;
          if r.parent = r.child then
            errors := Self_parent r.parent :: !errors
      | Spouse r ->
          require_person r.person1;
          require_person r.person2;
          if r.person1 = r.person2 then
            errors := Self_spouse r.person1 :: !errors)
    relations;
  List.rev !errors

let validate_parent_chronology (people : person list) (relations : Relation.t list) =
  let by_id = Hashtbl.create (List.length people) in
  List.iter (fun (p : person) -> Hashtbl.replace by_id p.id p) people;
  let errors = ref [] in
  List.iter
    (function
      | Parent_child r when r.confidence <> Rejected ->
          begin match Hashtbl.find_opt by_id r.parent,
                      Hashtbl.find_opt by_id r.child with
          | Some parent, Some child ->
              begin match year_of_date parent.birth_date,
                          year_of_date child.birth_date with
              | Some py, Some cy when py > cy ->
                  errors := Parent_born_after_child
                    { parent = r.parent; child = r.child } :: !errors
              | _ -> ()
              end
          | _ -> ()
          end
      | _ -> ())
    relations;
  List.rev !errors

let detect_parent_cycles (relations : Relation.t list) =
  let children_of = Hashtbl.create 16 in
  let add_edge parent child =
    let old = match Hashtbl.find_opt children_of parent with
      | Some xs -> xs | None -> []
    in
    Hashtbl.replace children_of parent (child :: old)
  in
  List.iter
    (function
      | Parent_child r when r.confidence <> Rejected ->
          add_edge r.parent r.child
      | _ -> ())
    relations;

  let state = Hashtbl.create 16 in
  let errors = ref [] in
  let rec dfs path node =
    match Hashtbl.find_opt state node with
    | Some `Done -> ()
    | Some `Active ->
        let rec cycle_from acc = function
          | [] -> List.rev (node :: acc)
          | x :: _ when x = node -> List.rev (node :: x :: acc)
          | x :: xs -> cycle_from (x :: acc) xs
        in
        errors := Parent_child_cycle (cycle_from [] (List.rev (node :: path))) :: !errors
    | None ->
        Hashtbl.replace state node `Active;
        let children = match Hashtbl.find_opt children_of node with
          | Some xs -> xs | None -> []
        in
        List.iter (fun child -> dfs (node :: path) child) children;
        Hashtbl.replace state node `Done
  in
  Hashtbl.iter (fun node _ -> dfs [] node) children_of;
  List.rev !errors

let validate ~(people : person list) ~(relations : Relation.t list) =
  validate_persons people
  @ validate_relation_ids relations
  @ validate_references people relations
  @ validate_parent_chronology people relations
  @ detect_parent_cycles relations