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
  val hs = sha256("hello")
  val hd = (0, 0, "hello", hash0())
  val mb = mine(hd)
  
  val xc = list0_sing(mb)
  val xc1 = chain_append(xc, "this is")  
  val xc2 = chain_append(xc1, "a blockchain...")
  val xc3 = chain_append(xc2, "neat!")
  val () = (xc3).foreach()(lam(b) => println!(b))
}

(* ****** ****** *)

(* end of [test.dats] *)