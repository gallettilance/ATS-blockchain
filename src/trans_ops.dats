(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)
(*
extern
fun
is_valid_transact(t: transaction): bool
*)
extern
fun
transact(t: transaction): void

extern
fun
get_data(): data

extern
fun
encode_transact(t: transaction): string

extern
fun
clear_transact(): void = "mac#"

extern
fun
file_write_transact(t: transaction): void

(* ****** ****** *)

%{
void clear_transact() {
  char filename0[] = "transaction.txt";
  char filename1[] = "value.txt";
  int res0 = remove(filename0);
  int res1 = remove(filename1);
  return;
}
%}


implement
file_write_transact(t) = let
  val out = fileref_open_exn("./transaction.txt", file_mode_a)
  val () = fprint_string(out, encode_transact(t))
  val () = fileref_close(out)
in
  ()
end


implement
transact(t) = 
file_write_transact(t)


implement
get_data() = let
  val ft = fileref_open_opt("./transaction.txt", file_mode_r)
in
  case- ft of
  | ~Some_vt(trns) => let
      val theLines = streamize_fileref_line(trns)
    in
      case- !theLines of
      | ~stream_vt_cons(l, theLines) => (~theLines; decode_data(l))
    end
end

(* ****** ****** *)

(* end of [block_ops.dats] *)

