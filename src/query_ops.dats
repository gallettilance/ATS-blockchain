(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

extern
fun
lisp2sql(q: query): string

extern
fun
file_write_state(s: statement): void

(* ****** ****** *)

implement
file_write_state(s) = let
  val out = fileref_open_exn("./qvalue.txt", file_mode_a)
  val () = fprint_string(out, encode_state(s))
  val () = fileref_close(out)
in
  ()
end

implement
lisp2sql(q) = 
case+ q of
| Qint(i)  =>  int2str(i)
| Qstr(s)  =>  s
| Qrec(vs) =>  let val-cons0(v, vs) = vs in list0_foldleft<string>(vs, "(" + lisp2sql(v), lam(res, v) => res + ", " + lisp2sql(v)) + ")" end
| Qopr(s, q0) =>  
  let
    val-Qrec(vs) = q0 
    val-cons0(v, vs) = vs 
  in 
    list0_foldleft<string>(vs,  lisp2sql(v), lam(res, v) => res + " " + s + " " + lisp2sql(v)) 
  end
| Qcrt(s, q0) =>  "CREATE TABLE " + s + lisp2sql(q0)
| Qsel(s, q0) =>  "SELECT " + lisp2sql(q0) + " FROM " + s
| Qins(s, q0, q1) =>  "INSERT INTO " + s + lisp2sql(q0) + " VALUES " + lisp2sql(q1)



(* ****** ****** *)

(* end of [state_ops.dats] *)