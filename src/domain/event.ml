(* EVENT MODEL: temporal events derived from genealogical facts. *)

open Genealogy_types

type t =
  | Birth of {
      person : iri;
      date : date;
    }

  | Death of {
      person : iri;
      date : date;
    }

  | Marriage of {
      relation : iri;
      person1 : iri;
      person2 : iri;
      date : date;
      place : string option;
      source : iri option;
      confidence : confidence;
    }