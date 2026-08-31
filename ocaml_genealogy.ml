type iri = string

type class_ = Person | Source | ParentageAssertion

type relationship_type = Biological | Adoptive | Legal | Social | Unknown

type confidence = Certain | Probable | Possible | Rejected

type entity =
  | Person_entity of iri
  | Source_entity of iri
  | Assertion_entity of {
      id : iri;
      parent : iri;
      child : iri;
      relationship : relationship_type;
      source : iri;
      confidence : confidence;
    }

type model = entity list

let person id = Person_entity id
let source id = Source_entity id
let assertion id ~parent ~child ~relationship ~source ~confidence =
  Assertion_entity { id; parent; child; relationship; source; confidence }

let relationship_iri = function
  | Biological -> ":Biological"
  | Adoptive -> ":Adoptive"
  | Legal -> ":Legal"
  | Social -> ":Social"
  | Unknown -> ":Unknown"

let confidence_iri = function
  | Certain -> ":Certain"
  | Probable -> ":Probable"
  | Possible -> ":Possible"
  | Rejected -> ":Rejected"

let emit_entity = function
  | Person_entity id ->
      Printf.printf "%s a :Person .\n\n" id
  | Source_entity id ->
      Printf.printf "%s a :Source .\n\n" id
  | Assertion_entity a ->
      Printf.printf
        "%s a :ParentageAssertion ;\n  :parent %s ;\n  :child %s ;\n  :relationshipType %s ;\n  :supportedBy %s ;\n  :confidence %s .\n\n"
        a.id a.parent a.child (relationship_iri a.relationship)
        a.source (confidence_iri a.confidence)

let emit model =
  print_endline "@prefix : <urn:genealogy:> .\n";
  List.iter emit_entity model

let model =
  [ person ":maria";
    person ":alex";
    source ":parish-record-17";
    assertion ":assertion-1"
      ~parent:":maria"
      ~child:":alex"
      ~relationship:Biological
      ~source:":parish-record-17"
      ~confidence:Probable ]

let () = emit model
