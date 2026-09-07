open Genealogy_types

let spouse_relations : spouse_relation list =
  [
    {
      id = ":marriage-1";
      individual1_id = ":rudkina_nina";
      individual2_id = ":kotlykov_pavel";
      marriage_date = Unknown;
      place = Some "Ulan-Ude, USSR";
      source = Some ":parish-record-17";
      confidence = Certain;
    };
    {
      id = ":marriage-2";
      individual1_id = ":afanasyeva_proskovya";
      individual2_id = ":kotlykov_innokentiy";
      marriage_date = Unknown;
      place = Some "Ulan-Ude, USSR";
      source = Some ":parish-record-17";
      confidence = Certain;
    };
    {
      id = ":marriage-3";
      individual1_id = ":korotueva_kseniia";
      individual2_id = ":rudkin_nikolay";
      marriage_date = Unknown;
      place = Some "Ulan-Ude, USSR";
      source = Some ":parish-record-17";
      confidence = Certain;
    };
  ]