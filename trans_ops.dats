(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

extern
fun
transact(s: string): void

extern
fun
get_transact(): string

extern
fun
clear_transact(): void = "mac#"

extern
fun
file_write_transact(s: string): void

(* ****** ****** *)

%{
void clear_transact() {
  char filename[] = "transaction.txt";
  int ret = remove(filename);
  return;
}
%}


implement
file_write_transact(s) = let
  val out = fileref_open_exn("./transaction.txt", file_mode_a)
  val () = fprint_string(out, s + ",")
  val () = fileref_close(out)
in
  ()
end


implement
transact(s) = 
file_write_transact(s)


implement
get_transact() = let
  val ft = fileref_open_opt("./transaction.txt", file_mode_r)
in  
  case+ ft of
  | ~None_vt() => ""
  | ~Some_vt(trns) => let
      val theLines = streamize_fileref_line(trns)
    in
      case+ !theLines of
      | ~stream_vt_nil() => ""
      | ~stream_vt_cons(l, theLines) => (~theLines; l)
    end
end

(* ****** ****** *)

(* end of [block_ops.dats] *)

