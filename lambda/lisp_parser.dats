(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)


extern
fun
parse_TMint(xs: stream_vt(string)): int

extern
fun
parse_TMstr(xs: stream_vt(string)): string

extern
fun
parse_TMtup(xs: stream_vt(string)): termlst

extern
fun
parse_TMproj(xs: stream_vt(string)): (term, int)

extern
fun
parse_TMvar(xs: stream_vt(string)): string

extern
fun
parse_TMlam(xs: stream_vt(string)): (string, term)

extern
fun
parse_TMapp(xs: stream_vt(string)): (term, term)

extern
fun
parse_TMfix(xs: stream_vt(string)): (string, string, term)

extern
fun
parse_TMopr(xs: stream_vt(string)): (string, termlst)

extern
fun
parse_TMifnz(xs: stream_vt(string)): (term, term, term)

extern
fun
parse_TMseq(xs: stream_vt(string)): (term, term)


(* ****** ****** *)


extern
fun
tokenize(xs: stream_vt(char)): stream_vt(string)

extern
fun
parse_lisp(f: string): term

extern
fun
parse_tokens(xs: stream_vt(string)): Option(term)

extern
fun
get_args(xs: stream_vt(string), n: int): list0(list0(string))

extern
fun
parse_list(xs: stream_vt(string)): termlst

extern
fun
file_write_code(v: value): void

(* ****** ****** *)

implement
file_write_code(v) = let
  val out = fileref_open_exn("./value.txt", file_mode_a)
  val () = fprint!(out, v)
  val () = fileref_close(out)
in
  ()
end

implement
parse_list(xs) = let
  fun mymap(xs: list0(string)): term = let 
      val-Some(t) = parse_tokens(streamize_list_elt<string>(g1ofg0(xs)))
    in
      t
    end
    

  fun aux(xs: stream_vt(string), cnt: int, arg: list0(string), res: list0(list0(string))): list0(term) =
    case- !xs of
    | ~stream_vt_cons(x, xs) => 
            if x = "(" then aux(xs, cnt + 1, cons0(x, arg), res)
            else
            (
              if x = ")" then aux(xs, cnt - 1, cons0(x, arg), res)
              else
              (
                if cnt = 1 then aux(xs, cnt, list0_sing(x), cons0(list0_reverse(arg), res))
                else 
                (
                  if cnt = 0 
                  then 
                  (
                    let
                      val tlst = list0_map(list0_reverse(res), lam(xs) => mymap(xs))
                    in
                      (~xs; tlst) 
                    end
                  )
                  else aux(xs, cnt, cons0(x, arg), res)
                )
              )
            )
in
  aux(xs, 1, nil0(), nil0())
end



implement
get_args(xs, n) = let
  fun aux(xs: stream_vt(string), cnt: int, arg: list0(string), res: list0(list0(string))): list0(list0(string)) =
    case- !xs of
    | ~stream_vt_cons(x, xs) => 
          if list0_length(res) = n then (~xs; res) 
          else
          (
            if x = "(" then aux(xs, cnt + 1, cons0(x, arg), res)
            else
            (
              if x = ")" then aux(xs, cnt - 1, cons0(x, arg), res)
              else
              (
                if cnt = 0 then aux(xs, cnt, nil0(), cons0(list0_reverse(arg), res))
                else aux(xs, cnt, cons0(x, arg), res)
              )
            )
          )
in
  aux(xs, 0, nil0(), nil0())
end


implement
parse_lisp(f) = let
  val myfile = fileref_open_opt(f, file_mode_r)
in
  case- myfile of
  | ~Some_vt(code_ref) => let
      val code = streamize_fileref_char(code_ref)
      val-Some(t) = parse_tokens(tokenize(code))
    in
      t
    end
end


(* ****** ****** *)


implement
parse_TMint(xs) = let
  val-~stream_vt_cons(x, xs) = !xs
in
  (~xs; string2int(x))
end


implement
parse_TMstr(xs) = let
  val-~stream_vt_cons(x, xs) = !xs
in
  (~xs; x)
end


implement
parse_TMtup(xs) = parse_list(xs)


implement
parse_TMproj(xs) = let
  val args = get_args(xs, 2)
  val-Some(t0) = parse_tokens(streamize_list_elt<string>(g1ofg0(args[0])))
  val-cons0(s, _) = args[1]
in
  (t0, string2int(s))
end


implement
parse_TMvar(xs) = let
  val-~stream_vt_cons(x, xs) = !xs
in
  (~xs; x)
end


implement
parse_TMlam(xs) = let
  val args = get_args(xs, 2)
  val-Some(t1) = parse_tokens(streamize_list_elt<string>(g1ofg0(args[1])))
  val-cons0(s, _) = args[0]
in
  (s, t1)
end


implement
parse_TMapp(xs) = let
  val args = get_args(xs, 2)
  val-Some(t0) = parse_tokens(streamize_list_elt<string>(g1ofg0(args[0])))
  val-Some(t1) = parse_tokens(streamize_list_elt<string>(g1ofg0(args[1])))
in
  (t0, t1)
end


implement
parse_TMfix(xs) = let
  val args = get_args(xs, 3)
  val-Some(t2) = parse_tokens(streamize_list_elt<string>(g1ofg0(args[2])))
  val-cons0(s0, _) = args[0]
  val-cons0(s1, _) = args[1]
in
  (s0, s1, t2)
end


implement
parse_TMopr(xs) = let
  val args = get_args(xs, 2)
  val t1 = parse_list(streamize_list_elt<string>(g1ofg0(args[1])))
  val-cons0(s, _) = args[0]
in
  (s, t1)
end


implement
parse_TMifnz(xs) = let
  val args = get_args(xs, 3)
  val-Some(t0) = parse_tokens(streamize_list_elt<string>(g1ofg0(args[0])))
  val-Some(t1) = parse_tokens(streamize_list_elt<string>(g1ofg0(args[1])))
  val-Some(t2) = parse_tokens(streamize_list_elt<string>(g1ofg0(args[2])))
in
  (t0, t1, t2)
end


implement
parse_TMseq(xs) = let
  val args = get_args(xs, 2)
  val-Some(t0) = parse_tokens(streamize_list_elt<string>(g1ofg0(args[0])))
  val-Some(t1) = parse_tokens(streamize_list_elt<string>(g1ofg0(args[1])))
in
  (t0, t1)
end


(* ****** ****** *)


implement
tokenize(xs) = let
  fun get_token(xs: stream_vt(char), s: string): (stream_vt(char), string) =
    case+ !xs of
    | ~stream_vt_nil() => ($ldelay(stream_vt_nil()), "")
    | ~stream_vt_cons(x, xs1) => 
        case+ x of
        | '\(' => (xs1, "(")
        | ' ' => (xs1, s)
        | ')' => if s = "" then (xs1, ")") else ($ldelay(stream_vt_cons(x, xs1), ~xs1), s)
        | _ => get_token(xs1, s + string_implode(list0_sing(x)))
in
    case+ !xs of
    | ~stream_vt_nil() => $ldelay( stream_vt_nil() )
    | ~stream_vt_cons(x, xs1) => let
          val (xs, tok) = get_token(xs1, "")
        in
          $ldelay( stream_vt_cons(tok, tokenize(xs)), ~xs)
        end
end


implement
parse_tokens(xs) =
  case+ !xs of
  | ~stream_vt_nil() => None()
  | ~stream_vt_cons(x, xs) => 
    case+ x of
    | "TMint"  =>  Some(TMint(parse_TMint(xs)))
    | "TMstr"  =>  Some(TMstr(parse_TMstr(xs)))
    | "TMtup"  =>  Some(TMtup(parse_TMtup(xs)))
    | "TMproj" =>  let val tup = parse_TMproj(xs) in Some(TMproj(tup.0, tup.1)) end
    | "TMvar"  =>  Some(TMvar(parse_TMvar(xs)))
    | "TMlam"  =>  let val lmd = parse_TMlam(xs)  in Some(TMlam(lmd.0, lmd.1)) end
    | "TMapp"  =>  let val app = parse_TMapp(xs)  in Some(TMapp(app.0, app.1)) end
    | "TMfix"  =>  let val fxp = parse_TMfix(xs)  in Some(TMfix(fxp.0, fxp.1, fxp.2)) end
    | "TMopr"  =>  let val opr = parse_TMopr(xs)  in Some(TMopr(opr.0, opr.1)) end
    | "TMifnz" =>  let val ifz = parse_TMifnz(xs) in Some(TMifnz(ifz.0, ifz.1, ifz.2)) end
    | "TMseq"  =>  let val seq = parse_TMseq(xs)  in Some(TMseq(seq.0, seq.1)) end
    | _ => (~xs; None())


(* ****** ****** *)

(* end of [lisp_parser.dats] *)