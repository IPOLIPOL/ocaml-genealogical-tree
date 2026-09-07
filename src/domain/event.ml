(* EVENT MODEL: temporal events derived from genealogical facts. *)

open Genealogy_types

type event =
  | Birth of {
      individual_id : iri;
      date : date;
    }
  | Death of {
      individual_id : iri;
      date : date;
    }
  | Marriage of {
      relation_id : iri;
      individual1_id : iri;
      individual2_id : iri;
      date : date;
      place : string option;
      source : iri option;
      confidence : confidence;
    }