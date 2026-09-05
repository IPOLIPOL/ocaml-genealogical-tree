open Genealogy_types

let people = 
  [ Persons.rudkina_nina; 
    Persons.kotlykov_pavel; 
    Persons.kotlykov_andrei; 
    Persons.kotlykov_innokentiy; 
    Persons.afanasyeva_proskovya; 
    Persons.rudkin_nikolay; 
    Persons.korotueva_kseniia ]

let parent_child_relations =
  [ Relations.rudkina_nina_mother_of_kotlykov_andrei;
    Relations.kotlykov_pavel_father_of_kotlykov_andrei;
    Relations.afanasyeva_proskovya_mother_of_kotlykov_pavel;
    Relations.kotlykov_innokentiy_father_of_kotlykov_pavel;
    Relations.korotueva_kseniia_mother_of_rudkina_nina;
    Relations.rudkin_nikolay_father_of_rudkina_nina ]

let marriage_relations =
  [ Relations.rudkina_nina_wife_of_kotlykov_pavel;
    Relations.kotlykov_pavel_husband_of_rudkina_nina;
    Relations.afanasyeva_proskovya_wife_of_kotlykov_innokentiy;
    Relations.kotlykov_innokentiy_husband_of_afanasyeva_proskovya;
    Relations.korotueva_kseniia_wife_of_rudkin_nikolay;
    Relations.rudkin_nikolay_husband_of_korotueva_kseniia]

let () =
  List.iter
    (fun (person : Genealogy_types.person) ->
      Printf.printf "%s: %s (%s)\n" 
      person.id 
      person.name 
      person.name_ru)
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
    marriage_relations;

  Graph_export.export_to_svg
    people
    parent_child_relations
    "generated/family-tree.svg"