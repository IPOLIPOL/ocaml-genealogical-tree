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

let afanasyeva_proskovya_wife_of_kotlykov_innokentiy =
  {
    id = ":marriage-2a";
    subject = ":afanasyeva_proskovya";
    role = Wife;
    spouse = ":kotlykov_innokentiy";
    marriage_date = Unknown;
    place = Some "Ulan-Ude, USSR";
    source = Some ":parish-record-17";
    confidence = Certain;
  }

let kotlykov_innokentiy_husband_of_afanasyeva_proskovya =
  {
    id = ":marriage-2b";
    subject = ":kotlykov_innokentiy";
    role = Husband;
    spouse = ":afanasyeva_proskovya";
    marriage_date = Unknown;
    place = Some "Ulan-Ude, USSR";
    source = Some ":parish-record-17";
    confidence = Certain;
  }

let korotueva_kseniia_wife_of_rudkin_nikolay =
  {
    id = ":marriage-3a";
    subject = ":korotueva_kseniia";
    role = Wife;
    spouse = ":rudkin_nikolay";
    marriage_date = Unknown;
    place = Some "Ulan-Ude, USSR";
    source = Some ":parish-record-17";
    confidence = Certain;
  }

let rudkin_nikolay_husband_of_korotueva_kseniia =
  {
    id = ":marriage-3b";
    subject = ":rudkin_nikolay";
    role = Husband;
    spouse = ":korotueva_kseniia";
    marriage_date = Unknown;
    place = Some "Ulan-Ude, USSR";
    source = Some ":parish-record-17";
    confidence = Certain;
  }

  (*   Parent-child relations   *)

let rudkina_nina_mother_of_kotlykov_andrei =
  {
    id = ":parentage-1a";
    parent = ":rudkina_nina";
    child = ":kotlykov_andrei";
    relation_type = Biological;
    source = Some ":parish-record-17";
    confidence = Certain;
  }

let kotlykov_pavel_father_of_kotlykov_andrei =
  {
    id = ":parentage-1b";
    parent = ":kotlykov_pavel";
    child = ":kotlykov_andrei";
    relation_type = Biological;
    source = Some ":parish-record-17";
    confidence = Certain;
  }

let afanasyeva_proskovya_mother_of_kotlykov_pavel =
  {
    id = ":parentage-2a";
    parent = ":afanasyeva_proskovya";
    child = ":kotlykov_pavel";
    relation_type = Biological;
    source = Some ":parish-record-17";
    confidence = Certain;
  }

let kotlykov_innokentiy_father_of_kotlykov_pavel =
  {
    id = ":parentage-2b";
    parent = ":kotlykov_innokentiy";
    child = ":kotlykov_pavel";
    relation_type = Biological;
    source = Some ":parish-record-17";
    confidence = Certain;
  }

let korotueva_kseniia_mother_of_rudkina_nina =
  {
    id = ":parentage-3a";
    parent = ":korotueva_kseniia";
    child = ":rudkina_nina";
    relation_type = Biological;
    source = Some ":parish-record-17";
    confidence = Certain;
  }

let rudkin_nikolay_father_of_rudkina_nina =
  {
    id = ":parentage-3b";
    parent = ":rudkin_nikolay";
    child = ":rudkina_nina";
    relation_type = Biological;
    source = Some ":parish-record-17";
    confidence = Certain;
  }