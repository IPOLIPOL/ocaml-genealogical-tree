(* graph_export.ml *)

open Genealogy_types

module G = Imperative.Digraph.Concrete(struct
  type t = string
  let compare = String.compare
  let hash = Hashtbl.hash
  let equal = String.equal
end)

let build_graph people parent_child_relations =
  let graph = G.create () in
  
  List.iter (fun person ->
    if not (G.mem_vertex graph person.id) then
      G.add_vertex graph person.id
  ) people;
  
  List.iter (fun rel ->
    if not (G.mem_vertex graph rel.parent) then
      G.add_vertex graph rel.parent;
    if not (G.mem_vertex graph rel.child) then
      G.add_vertex graph rel.child;
    G.add_edge graph rel.parent rel.child
  ) parent_child_relations;
  
  graph

let rec read_all_lines chan =
  try
    let line = input_line chan in
    line :: read_all_lines chan
  with End_of_file -> []

let export_to_svg people parent_child_relations output_file =
  let graph = build_graph people parent_child_relations in
  
  (* Ensure output directory exists *)
  let dir = Filename.dirname output_file in
  if not (Sys.file_exists dir) then
    Unix.mkdir dir 0o755;
  
  (* Open process: stdin=DOT input, stdout=SVG output *)
  let (svg_out, dot_in) = Unix.open_process "dot -Tsvg" in
  
  (* Write DOT to Graphviz's stdin *)
  let dot_chan = Unix.out_channel_of_descr dot_in in
  Graph.Graphviz.Dot.output_graph dot_chan graph;
  flush dot_chan;
  close_out dot_chan;
  
  (* Read all SVG output *)
  let svg_chan = Unix.in_channel_of_descr svg_out in
  let svg_lines = read_all_lines svg_chan in
  close_in svg_chan;
  
  (* Wait for Graphviz to finish *)
  let exit_status = Unix.close_process (svg_out, dot_in) in
  
  (* Write SVG to file *)
  let out_chan = open_out output_file in
  List.iter (fun line ->
    output_string out_chan line;
    output_char out_chan '\n'
  ) svg_lines;
  close_out out_chan;
  
  match exit_status with
  | Unix.WEXITED 0 -> ()
  | Unix.WEXITED code -> failwith (Printf.sprintf "Graphviz failed with exit code %d" code)
  | _ -> failwith "Graphviz terminated abnormally"