(* registry.ml – GEDCOM-aligned name for the collection of asserted individuals *)

open Genealogy_types

let registry : individual list = [
  {
    id = ":kotlykov_andrei";
    name = "Kotlykov Andrei Pavlovich";
    name_ru = "Котлыков Андрей Павлович";
    birth_date = Exact_date { year = 1967; month = 4; day = 23 };
    death_date = Present;
    birth_place = Some "Ulan-Ude, USSR";
  };
  {
    id = ":kotlykov_pavel";
    name = "Kotlykov Pavel Innokentyevich";
    name_ru = "Котлыков Павел Иннокентьевич";
    birth_date = Exact_date { year = 1935; month = 4; day = 12 };
    death_date = Exact_date { year = 2001; month = 9; day = 3 };
    birth_place = Some "Ulan-Ude, USSR";
  };
  {
    id = ":rudkina_nina";
    name = "Rudkina Nina Nikolayevna";
    name_ru = "Рудкина Нина Николаевна";
    birth_date = Year_only 1910;
    death_date = Present;
    birth_place = Some "Ulan-Ude, USSR";
  };
  {
    id = ":kotlykov_innokentiy";
    name = "Kotlykov Innokentiy Petrovich";
    name_ru = "Котлыков Иннокентий Петрович";
    birth_date = Exact_date { year = 1935; month = 4; day = 12 };
    death_date = Exact_date { year = 2001; month = 9; day = 3 };
    birth_place = Some "Ulan-Ude, USSR";
  };
  {
    id = ":afanasyeva_proskovya";
    name = "Afanasyeva Proskovya Nikolaevna";
    name_ru = "Афанасьева Прасковья Николаевна";
    birth_date = Exact_date { year = 1910; month = 4; day = 12 };
    death_date = Exact_date { year = 2001; month = 9; day = 3 };
    birth_place = Some "Ulan-Ude, USSR";
  };
  {
    id = ":rudkin_nikolay";
    name = "Rudkin Nikolay Dmitrievich";
    name_ru = "Рудкин Николай Дмитриевич";
    birth_date = Exact_date { year = 1910; month = 4; day = 12 };
    death_date = Exact_date { year = 2001; month = 9; day = 3 };
    birth_place = Some "Ulan-Ude, USSR";
  };
  {
    id = ":korotueva_kseniia";
    name = "Korotueva Ksenia Ivanovna";
    name_ru = "Коротуева Ксения Ивановна";
    birth_date = Exact_date { year = 1910; month = 4; day = 12 };
    death_date = Exact_date { year = 2001; month = 9; day = 3 };
    birth_place = Some "Ulan-Ude, USSR";
  };
]