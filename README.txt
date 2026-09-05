Compile with: ocamlc -o genealogy.exe ocaml_genealogy.ml
Run: genealogy.exe > asserted-data.ttl

https://ipolipol.github.io/ocaml-genealogical-tree/

Run the compiler: 
```dune exec src/main.exe```
```dune exec src/explore.exe```

Project structure: 
```
src/
│
├── domain/
│   ├── genealogy_types.ml      (* Core vocabulary: the fundamental types used to represent genealogical facts. *)
│   ├── person.ml               (* Person semantics: operations and facts derived from an individual person's data. *)
│   ├── relation.ml             (* Relation semantics: operations and properties of individual genealogical relationships. *)
│   ├── event.ml                (* Events: temporal occurrences derived from or associated with genealogical facts. *)
│   ├── genealogy.ml            (* Complete family graph. *)
│   ├── query.ml                (* Graph queries: derive genealogical relationships by traversing the family graph. *)
│   └── validation.ml           (* Validation: detect structural, semantic and consistency errors in the genealogy. *)
│
├──  data/
│   ├── persons.ml
│   ├── spouse_relations.ml
│   └── parent_child_relations.ml
│
├──  test/
│   └── core_test.ml
│
└── explore.ml

```