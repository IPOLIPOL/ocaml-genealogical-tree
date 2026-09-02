open Genealogy_types

(*  Marriage relations    *)

let rudkina_nina_wife_of_kotlykov_pavel =
  {
    id = ":marriage-1a";
    subject = ":rudkina_nina";
    role = Wife;
    spouse = ":kotlykov_pavel";
    marriage_date = Unknown;
    place = Some "Ulan-Ude, USSR";
    source = Some ":parish-record-17";
    confidence = Certain;
  }

let kotlykov_pavel_husband_of_rudkina_nina =
  {
    id = ":marriage-1b";
    subject = ":kotlykov_pavel";
    role = Husband;
    spouse = ":rudkina_nina";
    marriage_date = Unknown;
    place = Some "Ulan-Ude, USSR";
    source = Some ":parish-record-17";
    confidence = Certain;
  }

  (*   Parent-child relations   *)

let rudkina_nina_mother_of_kotlykov_andrei =
  {
    id = ":parentage-1";
    parent = ":rudkina_nina";
    child = ":kotlykov_andrei";
    relation_type = Biological;
    source = Some ":parish-record-17";
    confidence = Certain;
  }

let kotlykov_pavel_father_of_kotlykov_andrei =
  {
    id = ":parentage-2";
    parent = ":kotlykov_pavel";
    child = ":kotlykov_andrei";
    relation_type = Biological;
    source = Some ":parish-record-17";
    confidence = Certain;
  }