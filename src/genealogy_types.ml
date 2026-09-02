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

type person = {
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

type marriage_role =
  | Husband
  | Wife
  | Spouse

type marriage_relation = {
  id : iri;
  subject : iri;
  role : marriage_role;
  spouse : iri;
  marriage_date : date;
  place : string option;
  source : iri option;
  confidence : confidence;
}