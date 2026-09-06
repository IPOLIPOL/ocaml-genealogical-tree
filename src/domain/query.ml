(* Query provides graph navigation without exposing how Genealogy stores its indexes. *)

open Genealogy_types

module String_set = Set.Make (String)

let parents = Genealogy.parents_of
let children = Genealogy.children_of
let spouses = Genealogy.spouses_of
let individual = Genealogy.individual
let individuals = Genealogy.individuals

let ancestors (graph : Genealogy.graph) id =
  let rec visit seen accumulated = function
    | [] -> List.rev accumulated
    | current :: remaining ->
        let next_parents =
          Genealogy.parents_of graph current
          |> List.filter (fun parent_id -> not (String_set.mem parent_id seen))
        in
        let seen =
          List.fold_left
            (fun set parent_id -> String_set.add parent_id set)
            seen next_parents
        in
        visit seen
          (List.rev_append next_parents accumulated)
          (remaining @ next_parents)
  in
  visit (String_set.singleton id) [] [ id ]

let descendants (graph : Genealogy.graph) id =
  let rec visit seen accumulated = function
    | [] -> List.rev accumulated
    | current :: remaining ->
        let next_children =
          Genealogy.children_of graph current
          |> List.filter (fun child_id -> not (String_set.mem child_id seen))
        in
        let seen =
          List.fold_left
            (fun set child_id -> String_set.add child_id set)
            seen next_children
        in
        visit seen
          (List.rev_append next_children accumulated)
          (remaining @ next_children)
  in
  visit (String_set.singleton id) [] [ id ]

let ancestors_by_generation (graph : Genealogy.graph) id =
  let rec loop seen generation frontier accumulated =
    match frontier with
    | [] -> List.rev accumulated
    | _ ->
        let next_generation =
          List.concat_map (Genealogy.parents_of graph) frontier
          |> List.filter (fun parent_id -> not (String_set.mem parent_id seen))
        in
        if next_generation = [] then List.rev accumulated
        else
          let seen =
            List.fold_left
              (fun set parent_id -> String_set.add parent_id set)
              seen next_generation
          in
          loop seen (generation + 1) next_generation
            ((generation, next_generation) :: accumulated)
  in
  loop (String_set.singleton id) 1 [ id ] []

let descendants_by_generation (graph : Genealogy.graph) id =
  let rec loop seen generation frontier accumulated =
    match frontier with
    | [] -> List.rev accumulated
    | _ ->
        let next_generation =
          List.concat_map (Genealogy.children_of graph) frontier
          |> List.filter (fun child_id -> not (String_set.mem child_id seen))
        in
        if next_generation = [] then List.rev accumulated
        else
          let seen =
            List.fold_left
              (fun set child_id -> String_set.add child_id set)
              seen next_generation
          in
          loop seen (generation + 1) next_generation
            ((generation, next_generation) :: accumulated)
  in
  loop (String_set.singleton id) 1 [ id ] []

let relation_between (graph : Genealogy.graph) id1 id2 =
  if
    List.exists
      (fun parent_child ->
        (parent_child.parent = id1 && parent_child.child = id2)
        || (parent_child.parent = id2 && parent_child.child = id1))
      (Genealogy.parent_child_relations graph)
  then Some `Parent_child
  else if
    List.exists
      (fun spouse ->
        (spouse.person1 = id1 && spouse.person2 = id2)
        || (spouse.person1 = id2 && spouse.person2 = id1))
      (Genealogy.spouse_relations graph)
  then Some `Spouse
  else None