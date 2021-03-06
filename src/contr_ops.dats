(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

extern
fun
get_result(): result

extern
fun
file_write_contract(c: contract): void

(* ****** ****** *)

implement
file_write_contract(c) = let
  val out = fileref_open_exn("./value.txt", file_mode_a)
  val () = fprint!(out, encode_contract(c))
  val () = fileref_close(out)
in
  ()
end

implement
get_result() = let
  val ft = fileref_open_opt("./value.txt", file_mode_r)
in
  case+ ft of
  | ~None_vt() => nil0()
  | ~Some_vt(trns) => let
      val theLines = streamize_fileref_line(trns)
    in
      case- !theLines of
      | ~stream_vt_cons(l, theLines) => (~theLines; decode_result(l))
    end
end

(* ****** ****** *)

(* end of [contr_ops.dats] *)