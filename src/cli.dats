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
  val () = println!("    transact <from> <to> <ammount>            Create a new transaction         ")
  val () = println!("    code <filename.txt>                       Create a new smart contract      ")
  val () = println!("    mine                                      Mines a new block                ")
  val () = println!("    blockchain <from block> <to block>        View current state of blockchain ")
  val () = println!("    exit                                      Exits the application            ")
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
      | "code" => 
        (
          case+ args of 
          | nil0() => ()
          | cons0(f, args) => file_write_contract((f, val2str(interp(parse_lisp(f)))))
        )
      | "transact" => 
        (
          case+ args of
          | nil0() => ()
          | cons0(a, args) =>
               case+ args of
               | nil0() => ()
               | cons0(b, args) => 
                     case+ args of
                     | nil0() => ()
                     | cons0(c, args) => 
                        let val trns = (a, b, string2int(c)) 
                        in transact(trns) end
        )
      | "mine" => (chain_add(); clear_transact())
      | "blockchain" => 
            let 
              val (from, to) = parse_args_blockchain(args)
              val ch = get_chain(from, to)
            in 
              print_chain(ch)
            end
      | _ => ()

(* ****** ****** *)

(* end of [cli.dats] *)