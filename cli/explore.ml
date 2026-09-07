(* Quick interactive queries against the validated genealogy graph. *)

let graph =
  match
    Genealogy.create
      ~registry:Registry.registry
      ~parent_child_relations:
        Parent_child_relations.parent_child_relations
      ~spouse_relations:
        Spouse_relations.spouse_relations
  with
  | Ok genealogy_graph ->
      genealogy_graph

  | Error errors ->
      List.iter
        (fun validation_error ->
          prerr_endline
            (Validation.string_of_error
               validation_error))
        errors;

      exit 1

let () =
  let andrei_id = ":kotlykov_andrei" in
  let nina_id = ":rudkina_nina" in

  Printf.printf
    "=== Parents of Andrei ===\n";

  List.iter
    (Printf.printf "  %s\n")
    (Query.parents graph andrei_id);

  Printf.printf
    "\n=== Ancestors of Andrei ===\n";

  List.iter
    (Printf.printf "  %s\n")
    (Query.ancestors graph andrei_id);

  Printf.printf
    "\n=== Children of Nina ===\n";

  List.iter
    (Printf.printf "  %s\n")
    (Query.children graph nina_id);

  Printf.printf
    "\n=== Spouses of Nina ===\n";

  List.iter
    (Printf.printf "  %s\n")
    (Query.spouses graph nina_id);

  Printf.printf
    "\n=== Descendants of Ksenia ===\n";

  List.iter
    (Printf.printf "  %s\n")
    (Query.descendants
       graph
       ":korotueva_kseniia");

  begin
    match
      Genealogy.find_individual
        graph
        andrei_id
    with
    | Some individual_value ->
        Printf.printf
          "\n=== Andrei living? %b ===\n"
          (Individual.is_living individual_value);

        begin
          match
            Individual.birth_year individual_value
          with
          | Some birth_year ->
              Printf.printf
                "Andrei birth year: %d\n"
                birth_year

          | None ->
              ()
        end

    | None ->
        ()
  end;

  Printf.printf "\nOK\n"