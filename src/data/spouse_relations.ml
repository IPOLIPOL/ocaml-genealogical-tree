open Genealogy_types

let spouse_relations : spouse_relation list =
  [
    {
      id = ":marriage-1";
      person1 = ":rudkina_nina";
      person2 = ":kotlykov_pavel";
      marriage_date = Unknown;
      place = Some "Ulan-Ude, USSR";
      source = Some ":parish-record-17";
      confidence = Certain;
    };
    {
      id = ":marriage-2";
      person1 = ":afanasyeva_proskovya";
      person2 = ":kotlykov_innokentiy";
      marriage_date = Unknown;
      place = Some "Ulan-Ude, USSR";
      source = Some ":parish-record-17";
      confidence = Certain;
    };
    {
      id = ":marriage-3";
      person1 = ":korotueva_kseniia";
      person2 = ":rudkin_nikolay";
      marriage_date = Unknown;
      place = Some "Ulan-Ude, USSR";
      source = Some ":parish-record-17";
      confidence = Certain;
    };
  ]