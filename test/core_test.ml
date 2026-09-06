let fail message =
  prerr_endline ("FAIL: " ^ message);
  exit 1

let check condition message =
  if not condition then fail message

let unwrap = function
  | Ok x -> x
  | Error errors ->
      let text =
        errors
        |> List.map Validation.string_of_error
        |> String.concat "\n"
      in
      fail ("unexpected validation errors:\n" ^ text)

let () =
  let g =
    Genealogy.create
      ~registry:Registry.registry
      ~parent_child_relations:Parent_child_relations.parent_child_relations
      ~spouse_relations:Spouse_relations.spouse_relations
    |> unwrap
  in

  check
    (List.length (Genealogy.individuals g) = 7)
    "expected 7 individuals";

  check
    (List.mem ":rudkina_nina" (Query.parents g ":kotlykov_andrei"))
    "Nina should be Andrei's parent";

  check
    (List.mem ":kotlykov_pavel" (Query.parents g ":kotlykov_andrei"))
    "Pavel should be Andrei's parent";

  check
    (List.mem ":kotlykov_andrei" (Query.children g ":rudkina_nina"))
    "Andrei should be Nina's child";

  check
    (List.mem ":kotlykov_pavel" (Query.spouses g ":rudkina_nina"))
    "Pavel should be Nina's spouse";

  check
    (List.mem ":rudkina_nina" (Query.spouses g ":kotlykov_pavel"))
    "Nina should be Pavel's spouse";

  check
    (List.mem ":afanasyeva_proskovya" (Query.ancestors g ":kotlykov_andrei"))
    "Proskovya should be an ancestor of Andrei";

  check
    (List.mem ":kotlykov_andrei" (Query.descendants g ":korotueva_kseniia"))
    "Andrei should descend from Ksenia";

  print_endline "OK: core genealogy tests passed"