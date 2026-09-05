(* Genealogy owns a structurally valid graph and builds inverse/symmetric indexes from asserted facts. *)

open Genealogy_types

module String_map = Map.Make (String)

type t = {
  people : person String_map.t;
  parent_child_relations : parent_child_relation list;
  spouse_relations : spouse_relation list;
  parents_of : iri list String_map.t;
  children_of : iri list String_map.t;
  spouses_of : iri list String_map.t;
}

let add_to_index key value index =
  let old =
    match String_map.find_opt key index with
    | Some xs -> xs
    | None -> []
  in
  String_map.add key (value :: old) index

let build_people (people : person list) =
  List.fold_left
    (fun map (person : person) -> String_map.add person.id person map)
    String_map.empty people

let build_indexes
    (parent_child_relations : parent_child_relation list)
    (spouse_relations : spouse_relation list) =
  let parents_of = ref String_map.empty in
  let children_of = ref String_map.empty in
  let spouses_of = ref String_map.empty in
  List.iter
    (fun (r : parent_child_relation) ->
      if r.confidence <> Rejected then begin
        parents_of := add_to_index r.child r.parent !parents_of;
        children_of := add_to_index r.parent r.child !children_of
      end)
    parent_child_relations;
  List.iter
    (fun (r : spouse_relation) ->
      if r.confidence <> Rejected then begin
        spouses_of := add_to_index r.person1 r.person2 !spouses_of;
        spouses_of := add_to_index r.person2 r.person1 !spouses_of
      end)
    spouse_relations;
  (!parents_of, !children_of, !spouses_of)

let create
    ~(people : person list)
    ~(parent_child_relations : parent_child_relation list)
    ~(spouse_relations : spouse_relation list) =
  let relations =
    List.map (fun (r : parent_child_relation) -> Relation.Parent_child r) parent_child_relations
    @ List.map (fun (r : spouse_relation) -> Relation.Spouse r) spouse_relations
  in
  match Validation.validate ~people ~relations with
  | _ :: _ as errors -> Error errors
  | [] ->
      let people = build_people people in
      let parents_of, children_of, spouses_of =
        build_indexes parent_child_relations spouse_relations
      in
      Ok
        {
          people;
          parent_child_relations;
          spouse_relations;
          parents_of;
          children_of;
          spouses_of;
        }

let person t id = String_map.find_opt id t.people

let people t = String_map.bindings t.people |> List.map snd

let parent_child_relations t = t.parent_child_relations

let spouse_relations t = t.spouse_relations

let parents_of t id =
  match String_map.find_opt id t.parents_of with
  | Some xs -> List.rev xs
  | None -> []

let children_of t id =
  match String_map.find_opt id t.children_of with
  | Some xs -> List.rev xs
  | None -> []

let spouses_of t id =
  match String_map.find_opt id t.spouses_of with
  | Some xs -> List.rev xs
  | None -> []

let events t =
  let person_events =
    List.concat_map
      (fun (p : person) ->
        let birth =
          match p.birth_date with
          | Unknown -> []
          | date -> [ Event.Birth { person = p.id; date } ]
        in
        let death =
          match p.death_date with
          | Unknown | Present -> []
          | date -> [ Event.Death { person = p.id; date } ]
        in
        birth @ death)
      (people t)
  in
  let marriage_events =
    List.filter_map
      (fun (r : spouse_relation) ->
        match r.marriage_date with
        | Unknown -> None
        | date ->
            Some
              (Event.Marriage
                 {
                   relation = r.id;
                   person1 = r.person1;
                   person2 = r.person2;
                   date;
                   place = r.place;
                   source = r.source;
                   confidence = r.confidence;
                 }))
      t.spouse_relations
  in
  person_events @ marriage_events