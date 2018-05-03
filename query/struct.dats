(* ****** ****** *)
//
// LG 2018-02-22
//
(* ****** ****** *)

datatype query =
| Qint of (int)
| Qstr of (string)
| Qrec of (querylst)
| Qcrt of (string (* table name *), querylst (* column names *))
| Qins of (query (* record *), string (* table name *), querylst (* column names *))
| Qsel of (querylst (* columns *), string (* from table *)) //, query (* condition *))
| Qopr of (string (* operator *), querylst (* operands *))

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