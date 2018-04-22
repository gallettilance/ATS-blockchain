(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

typedef header = ( (* index *) int, (* nonce *) int, (* transaction data *) data, (* code result *) result, (* prevhash *) hash)
typedef block = ( header, (* currhash *) hash, (* timestamp *) string)
typedef chain = list0(block)

(* ****** ****** *)

(* end of [block.dats] *)