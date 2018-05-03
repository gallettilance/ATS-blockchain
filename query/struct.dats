(* ****** ****** *)
//
// LG 2018-02-22
//
(* ****** ****** *)

datatype query =
| Qint of (int)
| Qstr of (string)
| Qrec of (querylst)
| Qcrt of (string (* table name *), query (* column names *))
| Qins of (string (* table name *), query (* column names *), query (* record *))
| Qsel of (string (* from table *), query (* columns *)) //, query (* condition *))
| Qopr of (string (* operator *), query (* operands *))

where querylst = list0(query)

(* ****** ****** *)

datatype qvalue =
  | QVunit of ()
  | QVint of int
  | QVstr of string
  | QVbool of bool
  | QVrec of qvaluelst
  
where qvaluelst = list0(qvalue)

(* ****** ****** *)

(* end of [struct.dats] *)