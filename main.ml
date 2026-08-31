open Genealogy_types

let people = [ Persons.rudkina_nina; Persons.kotlykov_pavel; Persons.kotlykov_andrei ]

let parent_child_relations =
  [ Relations.rudkina_nina_mother_of_kotlykov_andrei;
    Relations.kotlykov_pavel_father_of_kotlykov_andrei ]

let marriage_relations =
  [ Relations.rudkina_nina_wife_of_kotlykov_pavel;
    Relations.kotlykov_pavel_husband_of_rudkina_nina ]

let () =
  List.iter
    (fun (person : Genealogy_types.person) ->
      Printf.printf "%s: %s (%s)\n" person.id person.name person.name_ru)
    people;

  List.iter
    (fun (relation : Genealogy_types.parent_child_relation) ->
      Printf.printf
        "parent-child %s: %s -> %s\n"
        relation.id
        relation.parent
        relation.child)
    parent_child_relations;

  List.iter
    (fun (relation : Genealogy_types.marriage_relation) ->
      Printf.printf
        "marriage %s: %s -[%s]-> %s\n"
        relation.id
        relation.subject
        (match relation.role with Husband -> "husband_of" | Wife -> "wife_of" | Spouse -> "spouse_of")
        relation.spouse)
    marriage_relations

(* Export to SVG *)
  Graph_export.export_to_svg
    people
    parent_child_relations
    "generated/family-tree.svg"