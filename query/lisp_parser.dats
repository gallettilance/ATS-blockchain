(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

extern
fun
parse_Qint(xs: stream_vt(string)): int

extern
fun
parse_Qstr(xs: stream_vt(string)): string

extern
fun
parse_Qrec(xs: stream_vt(string)): querylst

extern
fun
parse_Qopr(xs: stream_vt(string)): (string, query)

extern
fun
parse_Qcrt(xs: stream_vt(string)): (string, query)

extern
fun
parse_Qins(xs: stream_vt(string)): (string, query, query)

extern
fun
parse_Qsel(xs: stream_vt(string)): (string, query)

(* ****** ****** *)

extern
fun
qparse_lisp(f: string): query

extern
fun
qparse_tokens(xs: stream_vt(string)): Option(query)

(* ****** ****** *)

implement
qparse_lisp(f) = let
  val myfile = fileref_open_opt(f, file_mode_r)
in
  case- myfile of
  | ~Some_vt(code_ref) => let
      val code = streamize_fileref_char(code_ref)
      val alltokens = tokenize(code)
      val-Some(t) = qparse_tokens(alltokens)
    in
      t
    end
end

(* ****** ****** *)


implement
parse_Qint(xs) = let
  val-~stream_vt_cons(x, xs) = !xs
in
  (~xs; string2int(x))
end


implement
parse_Qstr(xs) = let
  val-~stream_vt_cons(x, xs) = !xs
in
  (~xs; x)
end


implement
parse_Qrec(xs) = let
  val args = get_args(xs)
in
  list0_map<list0(string)><query>
  (
    list0_filter(args, lam(a) => list0_length(a) > 0)
    ,
    lam(a) => let val-Some(t) = qparse_tokens(streamize_list_elt<string>(g1ofg0(a))) in t end
  )
end


implement
parse_Qopr(xs) = let
  val args = get_args(xs)
  val-cons0(s, args) = args
  val-cons0(s, _) = s
  val-cons0(args, _) = args
in
  ( 
    s
  ,
    let val-Some(t) = qparse_tokens(streamize_list_elt<string>(g1ofg0(args))) in t end
  )
end


implement
parse_Qcrt(xs) = let
  val args = get_args(xs)
  val-cons0(s, args) = args
  val-cons0(s, _) = s
  val-cons0(args, _) = args
in
  ( 
    s
  ,
    let val-Some(t) = qparse_tokens(streamize_list_elt<string>(g1ofg0(args))) in t end
  )
end


implement
parse_Qsel(xs) = let
  val args = get_args(xs)
  val-cons0(s, args) = args
  val-cons0(s, _) = s
  val-cons0(args, _) = args
in
  ( 
    s
  ,
    let val-Some(t) = qparse_tokens(streamize_list_elt<string>(g1ofg0(args))) in t end
  )
end


implement
parse_Qins(xs) = let
  val args = get_args(xs)
  val-cons0(s, args) = args
  val-cons0(s, _) = s
  val-cons0(cols, args) = args
  val-cons0(vals, _) = args
in
  ( 
    s
  ,
    let val-Some(t) = qparse_tokens(streamize_list_elt<string>(g1ofg0(cols))) in t end
  ,
    let val-Some(t) = qparse_tokens(streamize_list_elt<string>(g1ofg0(vals))) in t end
  )
end


(* ****** ****** *)

implement
qparse_tokens(xs) = 
  case+ !xs of
  | ~stream_vt_nil() => None()
  | ~stream_vt_cons(x, xs) => 
      case+ x of
      | "Qint"  =>  Some(Qint(parse_Qint(xs)))
      | "Qstr"  =>  Some(Qstr(parse_Qstr(xs)))
      | "Qrec"  =>  Some(Qrec(parse_Qrec(xs)))
      | "Qopr"  =>  let val opr = parse_Qopr(xs)  in Some(Qopr(opr.0, opr.1)) end
      | "Qcrt"  =>  let val crt = parse_Qcrt(xs)  in Some(Qcrt(crt.0, crt.1)) end
      | "Qsel"  =>  let val sel = parse_Qsel(xs)  in Some(Qsel(sel.0, sel.1)) end
      | "Qins"  =>  let val ins = parse_Qins(xs)  in Some(Qins(ins.0, ins.1, ins.2)) end
      | "(" => qparse_tokens(xs)
      | ")" => qparse_tokens(xs)
      | _ => (~xs; None())
    
(* ****** ****** *)

(* end of [lisp_parser.dats] *)