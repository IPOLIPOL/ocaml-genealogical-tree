(* Genealogy owns a structurally valid graph and builds inverse/symmetric indexes
   from asserted facts. *)

open Genealogy_types

module String_map = Map.Make (String)

type graph = {
  individuals : individual String_map.t;
  parent_child_relations : parent_child_relation list;
  spouse_relations : spouse_relation list;
  parents_of : iri list String_map.t;
  children_of : iri list String_map.t;
  spouses_of : iri list String_map.t;
}

let add_to_index key value index =
  let existing =
    match String_map.find_opt key index with
    | Some values -> values
    | None -> []
  in
  String_map.add key (value :: existing) index

(* Builds the individual map from the asserted registry list. *)
let build_individuals (registry : individual list) =
  List.fold_left
    (fun (map : individual String_map.t) (individual : individual) ->
      String_map.add individual.id individual map)
    String_map.empty
    registry

let build_indexes
    (parent_child_relations : parent_child_relation list)
    (spouse_relations : spouse_relation list) =
  let parents_of = ref String_map.empty in
  let children_of = ref String_map.empty in
  let spouses_of = ref String_map.empty in

  List.iter
    (fun (parent_child : parent_child_relation) ->
      if parent_child.confidence <> Rejected then begin
        parents_of :=
          add_to_index parent_child.child parent_child.parent !parents_of;
        children_of :=
          add_to_index parent_child.parent parent_child.child !children_of
      end)
    parent_child_relations;

  List.iter
    (fun (spouse : spouse_relation) ->
      if spouse.confidence <> Rejected then begin
        spouses_of :=
          add_to_index spouse.person1 spouse.person2 !spouses_of;
        spouses_of :=
          add_to_index spouse.person2 spouse.person1 !spouses_of
      end)
    spouse_relations;

  (!parents_of, !children_of, !spouses_of)

(* GEDCOM-aligned: the asserted collection is called "registry". *)
let create
    ~(registry : individual list)
    ~(parent_child_relations : parent_child_relation list)
    ~(spouse_relations : spouse_relation list)
  : (graph, Validation.error list) result =
  let relations =
    List.map
      (fun parent_child -> Relation.Parent_child parent_child)
      parent_child_relations
    @ List.map
        (fun spouse -> Relation.Spouse spouse)
        spouse_relations
  in
  match Validation.validate ~individuals:registry ~relations with
  | _ :: _ as errors -> Error errors
  | [] ->
      let individual_map = build_individuals registry in
      let parents_of, children_of, spouses_of =
        build_indexes parent_child_relations spouse_relations
      in
      Ok
        {
          individuals = individual_map;
          parent_child_relations;
          spouse_relations;
          parents_of;
          children_of;
          spouses_of;
        }

let individual (graph : graph) id =
  String_map.find_opt id graph.individuals

let individuals (graph : graph) =
  String_map.bindings graph.individuals |> List.map snd

let parent_child_relations (graph : graph) =
  graph.parent_child_relations

let spouse_relations (graph : graph) =
  graph.spouse_relations

let parents_of (graph : graph) id =
  match String_map.find_opt id graph.parents_of with
  | Some parents -> List.rev parents
  | None -> []

let children_of (graph : graph) id =
  match String_map.find_opt id graph.children_of with
  | Some children -> List.rev children
  | None -> []

let spouses_of (graph : graph) id =
  match String_map.find_opt id graph.spouses_of with
  | Some spouses -> List.rev spouses
  | None -> []

let events (graph : graph) =
  let individual_events =
    List.concat_map
      (fun individual ->
        let birth =
          match individual.birth_date with
          | Unknown -> []
          | date -> [ Event.Birth { person = individual.id; date } ]
        in
        let death =
          match individual.death_date with
          | Unknown | Present -> []
          | date -> [ Event.Death { person = individual.id; date } ]
        in
        birth @ death)
      (individuals graph)
  in
  let marriage_events =
    List.filter_map
      (fun spouse ->
        match spouse.marriage_date with
        | Unknown -> None
        | date ->
            Some
              (Event.Marriage
                 {
                   relation = spouse.id;
                   person1 = spouse.person1;
                   person2 = spouse.person2;
                   date;
                   place = spouse.place;
                   source = spouse.source;
                   confidence = spouse.confidence;
                 }))
      graph.spouse_relations
  in
  individual_events @ marriage_events