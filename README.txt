Compile with: ocamlc -o genealogy.exe ocaml_genealogy.ml
Run: genealogy.exe > asserted-data.ttl

https://ipolipol.github.io/ocaml-genealogical-tree/

Run the compiler: 
```dune exec src/main.exe```
```dune exec cli/explore.exe```

Project structure: 
```
.
├── dune-project
│
├── src
│   ├── domain
│   │   ├── dune
│   │   ├── genealogy_types.ml          (* Core vocabulary: the fundamental types used to represent genealogical facts. *)
│   │   ├── person.ml                   (* Person semantics: operations and facts derived from an individual person's data. *)
│   │   ├── relation.ml                 (* Relation semantics: operations and properties of individual genealogical relationships. *)
│   │   ├── event.ml                    (* Events: temporal occurrences derived from or associated with genealogical facts. *)
│   │   ├── validation.ml               (* Validation: detect structural, semantic and consistency errors in the genealogy. *)
│   │   ├── query.ml                    (* Graph queries: derive genealogical relationships by traversing the family graph. *)
│   │   └── genealogy.ml                (* Complete family graph. *)
│   │
│   └── data                            (* authoritative assertions *)
│       ├── dune
│       ├── persons.ml
│       ├── parent_child_relations.ml
│       └── spouse_relations.ml
│
├── cli                                 (* CLI adapter *)
│   ├── dune
│   └── explore.ml
│ 
└── test
    ├── dune
    └── core_test.ml
```

```
                HUMAN ASSERTIONS
                       │
              ┌────────┴────────┐
              │                 │
           persons          relations
              │                 │
              └────────┬────────┘
                       ▼
                 VALIDATION
                       │
                       ▼
                 GENEALOGY
              validated graph
                       │
             ┌─────────┴─────────┐
             ▼                   ▼
           QUERY              EVENTS
             │
       ┌─────┴─────┐
       ▼           ▼
      CLI          GUI
```