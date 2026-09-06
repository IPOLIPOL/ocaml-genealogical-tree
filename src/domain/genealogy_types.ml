(* DOMAIN VOCABULARY: fundamental types used to represent genealogical facts. *)

type iri = string

type date =
  | Exact_date of {
      year : int;
      month : int;
      day : int;
    }
  | Year_only of int
  | Present
  | Unknown

type confidence =
  | Certain
  | Probable
  | Possible
  | Rejected

type individual = {
  id : iri;
  name : string;
  name_ru : string;
  birth_date : date;
  death_date : date;
  birth_place : string option;
}

type parent_child_relation_type =
  | Biological
  | Adoptive
  | Legal
  | Social
  | Unknown

type parent_child_relation = {
  id : iri;
  parent : iri;
  child : iri;
  relation_type : parent_child_relation_type;
  source : iri option;
  confidence : confidence;
}

type spouse_relation = {
  id : iri;
  person1 : iri;
  person2 : iri;
  marriage_date : date;
  place : string option;
  source : iri option;
  confidence : confidence;
}