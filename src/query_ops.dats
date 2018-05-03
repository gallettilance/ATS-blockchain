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

extern
fun
get_queries(): queries

(* ****** ****** *)

implement
file_write_state(s) = let
  val out = fileref_open_exn("./queries.txt", file_mode_a)
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
| Qrec(vs) =>  let val-cons0(v, vs) = vs in list0_foldleft<string>(vs, "(" + lisp2sql(v), lam(res, v) => res + " " + lisp2sql(v)) + ")" end
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



implement
get_queries() = let
  val ft = fileref_open_opt("./queries.txt", file_mode_r)
in
  case+ ft of
  | ~None_vt() => nil0()
  | ~Some_vt(trns) => let
      val theLines = streamize_fileref_line(trns)
    in
      case- !theLines of
      | ~stream_vt_cons(l, theLines) => (~theLines; decode_queries(l))
    end
end


(* ****** ****** *)

(* end of [state_ops.dats] *)