let () =
  Ppx_driver.add_arg "-no-js-of-ocaml-wrapper"
    (Arg.Unit (fun () -> Ppx_js.wrapper := None))
    ~doc:" Undocumented";
  let js_mapper = Ppx_js.js_mapper [] in
  let module Js = Ppx_ast.Selected_ast in
  let module Ocaml = Migrate_parsetree.Ast_current in
  Ppx_driver.register_transformation "js_of_ocaml"
    ~impl:(fun st ->
      Js.ast_of_impl st
      |> Js.to_ocaml_ast
      |> Ocaml.impl_of_ast
      |> js_mapper.Ast_mapper.structure js_mapper
      |> Ocaml.ast_of_impl
      |> Js.of_ocaml_ast
      |> Js.impl_of_ast)
    ~intf:(fun sg ->
      Js.ast_of_intf sg
      |> Js.to_ocaml_ast
      |> Ocaml.intf_of_ast
      |> js_mapper.Ast_mapper.signature js_mapper
      |> Ocaml.ast_of_intf
      |> Js.of_ocaml_ast
      |> Js.intf_of_ast)
