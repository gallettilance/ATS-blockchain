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
cli_do(args: list0(string)): void

extern
fun
cli_stop(): void

extern
fun
read_loop(lines: stream_vt(string)): void

(* ****** ****** *)

implement
cli_start(lines) = let
  val () = println!()
  val () = println!(fg(reset(), YELLOW), "               Welcome to my blockchain in ATS!                                ", reset())
  val () = println!("                                                                               ")
  val () = println!(" Commands:                                                                     ")
  val () = println!("    exit                                      Exits the application            ")
  val () = println!("    mine <data>                               Mines a new block                ")
  val () = println!("    blockchain <from block> <to block>        View current state of blockchain ")
  val () = println!("                                                                               ")
  val () = println!("                                                                               ")
  
in
  read_loop(lines)
end

implement
read_loop(lines) = let
  val () = fprint!(stdout_ref, fg(reset(), YELLOW), "blockchain", reset(), "> ")
  val-~stream_vt_cons(l, lines) = !lines
  val args = parse_args(l)
in
  case+ args of
  | list0_nil() => read_loop(lines)
  | list0_cons(a, _) =>
      case+ a of
      | "exit" => (~lines; ())
      | _ => (cli_do(args); read_loop(lines))
end

implement
cli_stop() = let
  val () = println!()
in
  ()
end

implement
cli_do(args) = 
  case+ args of
  | list0_nil() => ()
  | list0_cons(a, args) =>
      case+ a of
      | "mine" => let val a = list0_foldleft<string>(args, "", lam(res, x) => res + " " + x) in chain_append(get_chain(0, ~1), a) end
      | "blockchain" => 
            let 
              val (from, to) = parse_fromto(args)
              val ch = get_chain(from, to) 
            in 
              print_chain(ch) 
            end
      | _ => ()

(* ****** ****** *)

(* end of [cli.dats] *)