(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

#include "./mylibies.dats"

(* ****** ****** *)

implement
main0() = ()
where
{
  val () = cli_start(streamize_fileref_line(stdin_ref))
}

(* ****** ****** *)

(* end of [run_cli.dats] *)