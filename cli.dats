(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

extern
fun
cli_start(lines: stream_vt(string)): void

extern
fun
cli_do(l: string): void

extern
fun
cli_stop(): void

extern
fun
parse_args(s: string): list0(string)

extern
fun
read_loop(lines: stream_vt(string)): void

(* ****** ****** *)

implement
cli_start(lines) = let
  val () = println!("Welcome to my blockchain in ATS!                         ")
  val () = println!()
  val () = println!()
  val () = println!("Commands:                                                ")
  val () = println!()
  val () = println!("    exit                Exits application                ")
  val () = println!("    mine <data>         Mines a new block                ")
  val () = println!("    blockchain          View current state of blockchain ")
  val () = println!()
in
  read_loop(lines)
end

implement
read_loop(lines) = let
  val () = fprint!(stdout_ref, "blockcain> ")
  val-~stream_vt_cons(l, lines) = !lines
in
   (cli_do(l); read_loop(lines))
end

implement
cli_stop() = let
  val () = println!()
in
  ()
end

implement
cli_do(l) = let
  val args = parse_args(l)
in
  case+ args of
  | list0_nil() => ()
  | list0_cons(a, args) =>
      case+ a of
      | "exit" => cli_stop()
      | "mine" => let val-cons0(a, _) = args in chain_append(get_chain(), a) end
      | "blockchain" => let val ch = get_chain() in (ch).foreach()(lam(b) => println!(b)) end
      | _ => fprint!(stdout_ref, "blockcain> ")
end

implement
parse_args(s) = let
  val xs = string_explode(s)
  
  fun aux(xs: list0(char), res: list0(string), s: string): list0(string) =
    case+ xs of
    | list0_nil() => list0_reverse(cons0(s, res))
    | list0_cons(x, xs) => 
          if x = ' ' 
          then aux(xs, cons0(s, res), "")
          else aux(xs, res, s + string_implode(list0_sing(x)))
in
  aux(xs, nil0(), "")
end

(* ****** ****** *)

(* end of [cli.dats] *)