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

extern
fun
do_execute(args: list0(string)): void

extern
fun
do_transact(args: list0(string)): void

extern
fun
do_code(args: list0(string)): void

extern
fun
do_mine(args: list0(string)): void

extern
fun
do_blockchain(args: list0(string)): void

extern
fun
do_define(args: list0(string)): void

extern
fun
do_balance(args: list0(string)): void

(* ****** ****** *)

implement
cli_start(lines) = let
  val () = println!()
  val () = println!(fg(reset(), YELLOW), "               Welcome to my blockchain in ATS!                                ", reset())
  val () = println!("                                                                               ")
  val () = println!(" Commands:                                                                     ")
  val () = println!("    blockchain <from block> <to block>        View current state of blockchain ")  
  val () = println!("    balance <miner>                           Get balance of miner             ")
  val () = println!("    code <lambda-lisp code>                   Code a smart contract            ")
  val () = println!("    define <miner>                            Defines a new miner              ")
  val () = println!("    execute <path/to/filename.txt>            Execute a new smart contract     ")
  val () = println!("    exit                                      Exits the application            ")
  val () = println!("    mine <miner>                              Specified miner mines a new block")
  val () = println!("    transact <from> <to> <ammount>            Create a new transaction         ")
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
      | "balance" => do_balance(args)
      | "blockchain" => do_blockchain(args)
      | "code" => do_code(args)
      | "define" => do_define(args)
      | "execute" => do_execute(args)
      | "mine" => do_mine(args)
      | "transact" => do_transact(args)
      | _ => ()


(* ****** ****** *)

implement
do_balance(args) =
case+ args of 
| nil0() => (println!("must provide miner argument"); ())
| cons0(a, _) => 
    if is_miner(a) 
    then let val coins = get_coins(a) in println!("Balance of ", a, " is ", coins) end
    else println!("unrecognized miner")


implement
do_execute(args) =
case+ args of 
| nil0() => (println!("must provide file path to execute"); ())
| cons0(f, args) => 
  if file_exists(f) 
  then file_write_contract((f, val2str(interp(parse_lisp(f)))))
  else (println!("Invalid file path"); ())

implement
do_code(args) = let
  val f = "./temp" + get_time() + ".txt"
  val out = fileref_open_exn(f, file_mode_a)
  val () = fprint_string(out, encode_usercode(args))
  val () = fileref_close(out)
in
  file_write_contract((f, val2str(interp(parse_lisp(f)))))
end


implement
do_transact(args) = 
case+ args of
| nil0() => (println!("must provide argument to transact"); ())
| cons0(a, args) =>
   case+ args of
   | nil0() => (println!("must provide <to> argument to transact"); ())
   | cons0(b, args) => 
     case+ args of
     | nil0() => (println!("must provide <amount> argument to transact"); ())
     | cons0(c, args) => 
        let val trns = (a, b, string2int(c)) 
        in transact(trns) end


implement
do_mine(args) = 
case+ args of
| nil0() => (println!("must provide <miner> argument"); ())
| cons0(a, _) => let
  val test_miner = is_miner(a)
  val test_transact = list0_length(list0_filter(get_data(), lam(t) => is_valid_transact(t))) > 0
  val test_code = list0_length(get_result()) > 0
  val test = test_miner andalso test_transact andalso test_code
in
  ifcase
  | test => (chain_add(); reward(a); clear_transact())
  | ~test_miner => (println!("unrecognized miner - please define miner first"); ())
  | ~test_transact => (println!("must have at least one valid transaction per block"); ())
  | ~test_code => (println!("must have at least one smart contract per block"); ())
  | _ => (println!("True = False?"); ())
end


implement
do_blockchain(args) = let 
  val (from, to) = parse_args_blockchain(args)
  val ch = get_chain(from, to)
in 
  print_chain(ch)
end


implement
do_define(args) = 
case+ args of
| nil0() => (println!("must provide argument to define"); ())
| cons0(a, _) => let
  val f = "./" + a + ".txt"
in
  if file_exists(f)
  then (println!(a + " is already defined"); ())
  else
  (
    let
      val out = fileref_open_exn(f, file_mode_a)
    in
      if file_exists("blockchain.txt") 
      then 
      (
        let
          val () = fprint_string(out, "0")
          val () = fileref_close(out)
        in
          ()
        end
      )
      else 
      (
        let
          val () = fprint_string(out, "10")
          val () = fileref_close(out)
        in
          ()
        end
      )
  end
  )
end

(* ****** ****** *)

(* end of [cli.dats] *)