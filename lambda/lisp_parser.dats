(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

extern
fun
parse_TMint(xs: stream_vt(char)): int

extern
fun
parse_TMstr(xs: stream_vt(char)): string

extern
fun
parse_TMtup(xs: stream_vt(char)): termlst

extern
fun
parse_TMproj(xs: stream_vt(char)): (term, int)

extern
fun
parse_TMvar(xs: stream_vt(char)): string

extern
fun
parse_TMlam(xs: stream_vt(char)): (string, term)

extern
fun
parse_TMapp(xs: stream_vt(char)): (term, term)

extern
fun
parse_TMfix(xs: stream_vt(char)): (string, string, term)

extern
fun
parse_TMopr(xs: stream_vt(char)): (string, termlst)

extern
fun
parse_TMifnz(xs: stream_vt(char)): (term, term, term)

extern
fun
parse_TMseq(xs: stream_vt(char)): (term, term)

(* ****** ****** *)

extern
fun
step_one(v: value): void

extern
fun
parse_lisp(f: string): term

extern
fun
parse_tree(xs: stream_vt(char)): term

extern
fun
get_args(xs: stream_vt(char), n: int): list0(list0(char))

extern
fun
parse_list(xs: stream_vt(char)): termlst

(* ****** ****** *)

implement
parse_lisp(f) = let
  val myfile = fileref_open_opt(f, file_mode_r)
in
  case- myfile of
  | ~Some_vt(code_ref) => let
      val code = streamize_fileref_char(code_ref)
    in
      parse_tree(code)
    end
end


implement
parse_TMint(xs) = let
  fun aux(xs: stream_vt(char), s: string): int =
    case- !xs of
    | ~stream_vt_cons(x, xs) => 
        (
          if x = ')' then (~xs; string2int(s)) 
          else aux(xs, s + string_implode(list0_sing(x)))
        )
in
  aux(xs, "")
end


implement
parse_TMstr(xs) = let
  fun aux(xs: stream_vt(char), s: string): string =
    case- !xs of
    | ~stream_vt_cons(x, xs) => 
        if x = ')' then (~xs; s) 
        else aux(xs, s + string_implode(list0_sing(x)))
in
  aux(xs, "")
end


implement
parse_TMtup(xs) = parse_list(xs)


implement
parse_TMproj(xs) = let
  val args = get_args(xs, 2)
in
  (parse_tree(streamize_list_elt<char>(g1ofg0(args[0]))), string2int(string_implode(args[1])))
end


implement
parse_TMvar(xs) = let
  fun aux(xs: stream_vt(char), s: string): string =
    case- !xs of
    | ~stream_vt_cons(x, xs) => 
        if x = ')' then (~xs; s) 
        else aux(xs, s + string_implode(list0_sing(x)))
in
  aux(xs, "")
end


implement
parse_TMlam(xs) = let
  val args = get_args(xs, 2)
in
  (string_implode(args[0]), parse_tree(streamize_list_elt<char>(g1ofg0(args[1]))))
end


implement
parse_TMapp(xs) = let
  val args = get_args(xs, 2)
in
  (parse_tree(streamize_list_elt<char>(g1ofg0(args[0]))), parse_tree(streamize_list_elt<char>(g1ofg0(args[1]))))
end


implement
parse_TMfix(xs) = let
  val args = get_args(xs, 3)
in
  (
    string_implode(args[0]), 
    string_implode(args[1]),
    parse_tree(streamize_list_elt<char>(g1ofg0(args[2])))
  )
end


implement
parse_TMopr(xs) = let
  val args = get_args(xs, 2)
in
  (string_implode(args[0]), parse_list(streamize_list_elt<char>(g1ofg0(args[1]))))
end


implement
parse_TMifnz(xs) = let
  val args = get_args(xs, 3)
in
  (
    parse_tree(streamize_list_elt<char>(g1ofg0(args[0]))), 
    parse_tree(streamize_list_elt<char>(g1ofg0(args[1]))),
    parse_tree(streamize_list_elt<char>(g1ofg0(args[2])))
  )
end


implement
parse_TMseq(xs) = let
  val args = get_args(xs, 2)
in
  (parse_tree(streamize_list_elt<char>(g1ofg0(args[0]))), parse_tree(streamize_list_elt<char>(g1ofg0(args[1]))))
end


implement
parse_tree(xs) = let
  fun get_keyword(xs: stream_vt(char), s: string): term =
    case- s of
    | "TMint"  =>  TMint(parse_TMint(xs))
    | "TMstr"  =>  TMstr(parse_TMstr(xs))
    | "TMtup"  =>  TMtup(parse_TMtup(xs))
    | "TMproj" =>  let val tup = parse_TMproj(xs) in TMproj(tup.0, tup.1) end
    | "TMvar"  =>  TMvar(parse_TMvar(xs))
    | "TMlam"  =>  let val lmd = parse_TMlam(xs)  in TMlam(lmd.0, lmd.1) end
    | "TMapp"  =>  let val app = parse_TMapp(xs)  in TMapp(app.0, app.1) end
    | "TMfix"  =>  let val fxp = parse_TMfix(xs)  in TMfix(fxp.0, fxp.1, fxp.2) end
    | "TMopr"  =>  let val opr = parse_TMopr(xs)  in TMopr(opr.0, opr.1) end
    | "TMifnz" =>  let val ifz = parse_TMifnz(xs) in TMifnz(ifz.0, ifz.1, ifz.2) end
    | "TMseq"  =>  let val seq = parse_TMseq(xs)  in TMseq(seq.0, seq.1) end

  fun parse_keyword(xs: stream_vt(char), s: string): term =
    case- !xs of
    | ~stream_vt_cons(x, xs) => 
          if x = ' ' 
          then get_keyword(xs, s) 
          else 
          (
            if x = '\('
            then parse_keyword(xs, "")
            else parse_keyword(xs, s + string_implode(list0_sing(x)))
          )

in
  parse_keyword(xs, "")
end

(* ****** ****** *)

(* end of [lisp_parser.dats] *)