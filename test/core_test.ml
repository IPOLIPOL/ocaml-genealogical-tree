let fail message =
  prerr_endline ("FAIL: " ^ message);
  exit 1

let check condition message =
  if not condition then
    fail message

let unwrap = function
  | Ok graph ->
      graph

  | Error errors ->
      let error_text =
        errors
        |> List.map Validation.string_of_error
        |> String.concat "\n"
      in

      fail
        ("unexpected validation errors:\n"
         ^ error_text)

let () =
  let graph =
    Genealogy.create
      ~registry:Registry.registry
      ~parent_child_relations:
        Parent_child_relations.parent_child_relations
      ~spouse_relations:
        Spouse_relations.spouse_relations
    |> unwrap
  in

  check
    (List.length
       (Genealogy.individuals graph)
     = 7)
    "expected 7 individuals";

  check
    (List.mem
       ":rudkina_nina"
       (Query.parents
          graph
          ":kotlykov_andrei"))
    "Nina should be Andrei's parent";

  check
    (List.mem
       ":kotlykov_pavel"
       (Query.parents
          graph
          ":kotlykov_andrei"))
    "Pavel should be Andrei's parent";

  check
    (List.mem
       ":kotlykov_andrei"
       (Query.children
          graph
          ":rudkina_nina"))
    "Andrei should be Nina's child";

  check
    (List.mem
       ":kotlykov_pavel"
       (Query.spouses
          graph
          ":rudkina_nina"))
    "Pavel should be Nina's spouse";

  check
    (List.mem
       ":rudkina_nina"
       (Query.spouses
          graph
          ":kotlykov_pavel"))
    "Nina should be Pavel's spouse";

  check
    (List.mem
       ":afanasyeva_proskovya"
       (Query.ancestors
          graph
          ":kotlykov_andrei"))
    "Proskovya should be an ancestor of Andrei";

  check
    (List.mem
       ":kotlykov_andrei"
       (Query.descendants
          graph
          ":korotueva_kseniia"))
    "Andrei should descend from Ksenia";

  print_endline
    "OK: core genealogy tests passed"