open Genealogy_types

let rudkina_nina =
  {
    id = ":rudkina_nina";
    name = "Rudkina Nina Nikolayevna";
    name_ru = "Рудкина Нина Николаевна";
    birth_date = Year_only 1910;
    death_date = Present;
    birth_place = Some "Ulan-Ude, USSR";
  }

let kotlykov_pavel =
  {
    id = ":kotlykov_pavel";
    name = "Kotlykov Pavel Innokentyevich";
    name_ru = "Котлыков Павел Иннокентьевич";
    birth_date = Exact_date { year = 1935; month = 4; day = 12 };
    death_date = Exact_date { year = 2001; month = 9; day = 3 };
    birth_place = Some "Ulan-Ude, USSR";
  }

let kotlykov_andrei =
  {
    id = ":kotlykov_andrei";
    name = "Kotlykov Andrei Pavlovich";
    name_ru = "Котлыков Андрей Павлович";
    birth_date = Exact_date { year = 1967; month = 4; day = 23 };
    death_date = Present;
    birth_place = Some "Ulan-Ude, USSR";
  }