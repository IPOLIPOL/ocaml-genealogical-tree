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
  let vertex_name vertex =
    Printf.sprintf "\"%s\"" vertex
  let vertex_attributes _ = []
  let get_subgraph _ = None
  let default_edge_attributes _ = []
  let edge_attributes _ = []
end)

let build_graph
    (individuals : individual list)
    (parent_child_relations : parent_child_relation list)
    : G.t =
  let graph = G.create () in

  List.iter
    (fun individual_value ->
      if not
           (G.mem_vertex graph individual_value.id)
      then
        G.add_vertex
          graph
          individual_value.id)
    individuals;

  List.iter
    (fun parent_child ->
      if not
           (G.mem_vertex graph parent_child.parent)
      then
        G.add_vertex
          graph
          parent_child.parent;

      if not
           (G.mem_vertex graph parent_child.child)
      then
        G.add_vertex
          graph
          parent_child.child;

      G.add_edge
        graph
        parent_child.parent
        parent_child.child)
    parent_child_relations;

  graph

let rec read_all_lines channel =
  try
    let line = input_line channel in
    line :: read_all_lines channel
  with
  | End_of_file ->
      []

let export_to_svg
    (individuals : individual list)
    (parent_child_relations : parent_child_relation list)
    (output_file : string)
    : unit =
  let graph =
    build_graph
      individuals
      parent_child_relations
  in

  let directory =
    Filename.dirname output_file
  in

  if not (Sys.file_exists directory) then
    Unix.mkdir directory 0o755;

  let svg_output, dot_input =
    Unix.open_process "dot -Tsvg"
  in

  Dot.output_graph dot_input graph;
  flush dot_input;
  close_out dot_input;

  let svg_lines =
    read_all_lines svg_output
  in

  close_in svg_output;

  let exit_status =
    Unix.close_process
      (svg_output, dot_input)
  in

  let output_channel =
    open_out output_file
  in

  List.iter
    (fun line ->
      output_string output_channel line;
      output_char output_channel '\n')
    svg_lines;

  close_out output_channel;

  match exit_status with
  | Unix.WEXITED 0 ->
      ()

  | Unix.WEXITED code ->
      failwith
        (Printf.sprintf
           "Graphviz failed with exit code %d"
           code)

  | _ ->
      failwith
        "Graphviz terminated abnormally"