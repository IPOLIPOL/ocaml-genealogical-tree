(* Quick interactive queries against the validated genealogy graph. *)

let g =
  match
    Genealogy.create
      ~registry:Registry.registry
      ~parent_child_relations:Parent_child_relations.parent_child_relations
      ~spouse_relations:Spouse_relations.spouse_relations
  with
  | Ok graph -> graph
  | Error errors ->
      List.iter
        (fun e -> prerr_endline (Validation.string_of_error e))
        errors;
      exit 1

let () =
  let andrei = ":kotlykov_andrei" in
  let nina = ":rudkina_nina" in

  Printf.printf "=== Parents of Andrei ===\n";
  List.iter (Printf.printf "  %s\n") (Query.parents g andrei);

  Printf.printf "\n=== Ancestors of Andrei ===\n";
  List.iter (Printf.printf "  %s\n") (Query.ancestors g andrei);

  Printf.printf "\n=== Children of Nina ===\n";
  List.iter (Printf.printf "  %s\n") (Query.children g nina);

  Printf.printf "\n=== Spouses of Nina ===\n";
  List.iter (Printf.printf "  %s\n") (Query.spouses g nina);

  Printf.printf "\n=== Descendants of Ksenia ===\n";
  List.iter
    (Printf.printf "  %s\n")
    (Query.descendants g ":korotueva_kseniia");

  (* Example of using Individual derived operations *)
  begin match Genealogy.individual g andrei with
  | Some ind ->
      Printf.printf "\n=== Andrei living? %b ===\n" (Individual.is_living ind);
      begin match Individual.birth_year ind with
      | Some y -> Printf.printf "Andrei birth year: %d\n" y
      | None -> ()
      end
  | None -> ()
  end;

  Printf.printf "\nOK\n"