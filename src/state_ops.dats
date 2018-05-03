(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

extern
fun
encode_userquery(list0(string)): string

extern
fun
lisp2sql(q: query): string

extern
fun
file_write_state(s: statement): void

extern
fun
get_gas_query(q: query): int

overload get_gas with get_gas_query

(* ****** ****** *)



(* ****** ****** *)

(* end of [state_ops.dats] *)