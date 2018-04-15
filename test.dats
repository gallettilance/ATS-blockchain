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
  val hd = (0, 0, "hello", "0000000000000000000000000000000000000000000000000000000000000000")
  val b = (hd, "d50ff4012e6c034db39371f9079af243dc544e380470ac4dbae85b6fb96bacf6")
  val () = fprint_block(stdout_ref, b)
}

(* ****** ****** *)

(* end of [test.dats] *)