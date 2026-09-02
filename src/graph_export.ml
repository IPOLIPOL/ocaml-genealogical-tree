(* graph_export.ml *)

open Genealogy_types

module G = Graph.Imperative.Digraph.Concrete (struct
  type t = string
  let compare = String.compare
  let hash = Hashtbl.hash
  let equal = String.equal
end)

module Dot = Graph.Graphviz.Dot (struct
  include G
  let graph_attributes _ = []
  let default_vertex_attributes _ = []
  let vertex_name v = Printf.sprintf "\"%s\"" v
  let vertex_attributes _ = []
  let get_subgraph _ = None
  let default_edge_attributes _ = []
  let edge_attributes _ = []
end)

let build_graph
    (people : person list)
    (parent_child_relations : parent_child_relation list) : G.t =
  let graph = G.create () in
  List.iter
    (fun (p : person) ->
      if not (G.mem_vertex graph p.id) then G.add_vertex graph p.id)
    people;
  List.iter
    (fun (rel : parent_child_relation) ->
      if not (G.mem_vertex graph rel.parent) then
        G.add_vertex graph rel.parent;
      if not (G.mem_vertex graph rel.child) then
        G.add_vertex graph rel.child;
      G.add_edge graph rel.parent rel.child)
    parent_child_relations;
  graph

let rec read_all_lines chan =
  try
    let line = input_line chan in
    line :: read_all_lines chan
  with End_of_file -> []

let export_to_svg
    (people : person list)
    (parent_child_relations : parent_child_relation list)
    (output_file : string) : unit =
  let graph = build_graph people parent_child_relations in

  let dir = Filename.dirname output_file in
  if not (Sys.file_exists dir) then Unix.mkdir dir 0o755;

  let svg_out, dot_in = Unix.open_process "dot -Tsvg" in
  Dot.output_graph dot_in graph;
  flush dot_in;
  close_out dot_in;

  let svg_lines = read_all_lines svg_out in
  close_in svg_out;

  let exit_status = Unix.close_process (svg_out, dot_in) in

  let out_chan = open_out output_file in
  List.iter
    (fun line ->
      output_string out_chan line;
      output_char out_chan '\n')
    svg_lines;
  close_out out_chan;

  match exit_status with
  | Unix.WEXITED 0 -> ()
  | Unix.WEXITED code ->
      failwith (Printf.sprintf "Graphviz failed with exit code %d" code)
  | _ -> failwith "Graphviz terminated abnormally"