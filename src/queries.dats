(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

typedef statement = ((* sql command *) string, (* qvalue *) string, (* gas *) int)
typedef queries = list0(statement)

(* ****** ****** *)

(* end of [queries.dats] *)