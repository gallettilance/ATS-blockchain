(* ****** ****** *)
//
// LG 2018-02-22
//
(* ****** ****** *)

extern
fun
get_gas_query(q: query): int

overload get_gas with get_gas_query

(* ****** ****** *)

implement
get_gas_query(q) = 0
(*
let
  fun aux(q0: query, res: int): int =
    case+ q0 of
    | Qint(_)         =>  res + 1
    | Qstr(_)         =>  res + 1
    | Qrec(qs)        =>  list0_foldleft<int>(qs, res + 1, lam(res, t) => res + aux(t, 0))
    | Qopr(_, q1)     =>  1 + aux(q1, res)
    | Qcrt(_, q1)     =>  1 + aux(q1, res)
    | Qsel(_, q1)     =>  1 + aux(q1, res)
    | Qins(_, q1, q2) =>  1 + aux(q1, res) + aux(q2, res)
in
  aux(q, 0)
end
*)

(* ****** ****** *)

(* end of [gas.dats] *)