(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

#include "share/atspre_staload.hats"
#include "share/HATS/atspre_staload_libats_ML.hats"

(* ****** ****** *)

abstype chain
abstype block

(* ****** ****** *)

extern
fun
block_append(c: chain, b: block): chain

(* ****** ****** *)



(* ****** ****** *)

implement
main0() = ()
where
{
  
}

(* ****** ****** *)

(* end of [block.dats] *)