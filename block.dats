(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

#include "./hash.dats"

(* ****** ****** *)

typedef header = ( (* index *) int, (* nounce *) int, (* data *) string, (* prevhash *) hash)
typedef block = ( header, (* currhash *) hash)
typedef chain = list0(block)

(* ****** ****** *)

(* end of [block.dats] *)