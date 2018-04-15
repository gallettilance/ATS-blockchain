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
  val hd = (0, 0, "hello", hash0())
  val b = (hd, sha256(stringize(hd)))
  val () = println!(b)
  val mb = mine(b)
  val () = println!(mb)
}

(* ****** ****** *)

(* end of [test.dats] *)