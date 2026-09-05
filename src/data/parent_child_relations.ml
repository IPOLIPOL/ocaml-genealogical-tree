open Genealogy_types

let parent_child_relations : parent_child_relation list =
  [
    {
      id = ":parentage-1a";
      parent = ":rudkina_nina";
      child = ":kotlykov_andrei";
      relation_type = Biological;
      source = Some ":parish-record-17";
      confidence = Certain;
    };
    {
      id = ":parentage-1b";
      parent = ":kotlykov_pavel";
      child = ":kotlykov_andrei";
      relation_type = Biological;
      source = Some ":parish-record-17";
      confidence = Certain;
    };
    {
      id = ":parentage-2a";
      parent = ":afanasyeva_proskovya";
      child = ":kotlykov_pavel";
      relation_type = Biological;
      source = Some ":parish-record-17";
      confidence = Certain;
    };
    {
      id = ":parentage-2b";
      parent = ":kotlykov_innokentiy";
      child = ":kotlykov_pavel";
      relation_type = Biological;
      source = Some ":parish-record-17";
      confidence = Certain;
    };
    {
      id = ":parentage-3a";
      parent = ":korotueva_kseniia";
      child = ":rudkina_nina";
      relation_type = Biological;
      source = Some ":parish-record-17";
      confidence = Certain;
    };
    {
      id = ":parentage-3b";
      parent = ":rudkin_nikolay";
      child = ":rudkina_nina";
      relation_type = Biological;
      source = Some ":parish-record-17";
      confidence = Certain;
    };
  ]