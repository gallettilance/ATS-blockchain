(* ****** ****** *)
//
// LG 2018-02-22
//
(* ****** ****** *)

extern
fun
print_qvalue(t0: qvalue): void
extern
fun
fprint_qvalue(out: FILEref, t0: qvalue): void

overload print with print_qvalue
overload fprint with fprint_qvalue

(* ****** ****** *)

implement
fprint_val<qvalue> = fprint_qvalue

(* ****** ****** *)

implement
print_qvalue
(t0) = fprint_qvalue(stdout_ref, t0)

implement
fprint_qvalue(out, t0) =
(
case+ t0 of
| QVunit() => fprint!(out, "QVunit()")
| QVint(i) => fprint!(out, "QVint(", i, ")")
| QVstr(s) => fprint!(out, "QVstr(", s, ")")
| QVbool(b) => fprint!(out, "QVbool(", b, ")")
| QVrec(vs) => fprint!(out, "QVrec(", vs, ")")
)

(* ****** ****** *)

(* end of [print_qval.dats] *)