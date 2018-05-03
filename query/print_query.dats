(* ****** ****** *)
//
// LG 2018-02-22
//
(* ****** ****** *)

extern
fun
print_query(t0: query): void
extern
fun
fprint_query(out: FILEref, t0: query): void

overload print with print_query
overload fprint with fprint_query

(* ****** ****** *)

implement
fprint_val<query> = fprint_query

(* ****** ****** *)

implement
print_query
(t0) = fprint_query(stdout_ref, t0)

implement
fprint_query(out, t0) =
(
case+ t0 of
| Qint(i)  =>  fprint!(out, "Qint(", i, ")")
| Qstr(s)  =>  fprint!(out, "Qstr(", s, ")")
| Qrec(vs) =>  fprint!(out, "Qrec(", vs, ")")
| Qopr(s, q0) =>  fprint!(out, "Qopr(", s, ", ", q0, ")")
| Qcrt(s, q0) =>  fprint!(out, "Qcrt(", s, ", ", q0, ")")
| Qsel(s, q0) =>  fprint!(out, "Qrec(", s, ", ", q0, ")")
| Qins(s, q0, q1) =>  fprint!(out, "Qrec(", s, ", ", q0, ", ", q1, ")")
)

(* ****** ****** *)

(* end of [print_query.dats] *)