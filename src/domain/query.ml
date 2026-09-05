(* Query provides graph navigation without exposing how Genealogy stores its indexes. *)

open Genealogy_types
module String_set = Set.Make (String)

let parents = Genealogy.parents_of
let children = Genealogy.children_of
let spouses = Genealogy.spouses_of
let person = Genealogy.person
let people = Genealogy.people

let ancestors t id =
  let rec visit seen result = function
    | [] -> List.rev result
    | current :: rest ->
        let next =
          Genealogy.parents_of t current
          |> List.filter (fun p -> not (String_set.mem p seen))
        in
        let seen = List.fold_left (fun s p -> String_set.add p s) seen next in
        visit seen (List.rev_append next result) (rest @ next)
  in
  visit (String_set.singleton id) [] [id]

let descendants t id =
  let rec visit seen result = function
    | [] -> List.rev result
    | current :: rest ->
        let next =
          Genealogy.children_of t current
          |> List.filter (fun p -> not (String_set.mem p seen))
        in
        let seen = List.fold_left (fun s p -> String_set.add p s) seen next in
        visit seen (List.rev_append next result) (rest @ next)
  in
  visit (String_set.singleton id) [] [id]

let ancestors_by_generation t id =
  let rec loop seen generation frontier acc =
    match frontier with
    | [] -> List.rev acc
    | _ ->
        let next =
          List.concat_map (Genealogy.parents_of t) frontier
          |> List.filter (fun p -> not (String_set.mem p seen))
        in
        if next = [] then List.rev acc
        else
          let seen = List.fold_left (fun s p -> String_set.add p s) seen next in
          loop seen (generation + 1) next ((generation, next) :: acc)
  in
  loop (String_set.singleton id) 1 [id] []

let descendants_by_generation t id =
  let rec loop seen generation frontier acc =
    match frontier with
    | [] -> List.rev acc
    | _ ->
        let next =
          List.concat_map (Genealogy.children_of t) frontier
          |> List.filter (fun p -> not (String_set.mem p seen))
        in
        if next = [] then List.rev acc
        else
          let seen = List.fold_left (fun s p -> String_set.add p s) seen next in
          loop seen (generation + 1) next ((generation, next) :: acc)
  in
  loop (String_set.singleton id) 1 [id] []

let relation_between t id1 id2 =
  if List.exists (fun r ->
      (r.parent = id1 && r.child = id2) ||
      (r.parent = id2 && r.child = id1))
      (Genealogy.parent_child_relations t)
  then Some `Parent_child
  else if List.exists (fun r ->
      (r.person1 = id1 && r.person2 = id2) ||
      (r.person1 = id2 && r.person2 = id1))
      (Genealogy.spouse_relations t)
  then Some `Spouse
  else None
