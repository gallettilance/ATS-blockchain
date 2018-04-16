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
parse_args(s: string): list0(string)

extern
fun
parse_fromto(list0(string)): (int, int)

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

extern
fun
char2int(c: char): int

extern
fun
string2int(s: string): int

extern
fun
max(xs: list0(int)): int

extern
fun
myfold(xs: list0(int), ys: list0(int)): list0(int)

extern
fun
max_path(xss: list0(list0(int))): int

(* ****** ****** *)

implement
char2int(c) =
case+ c of
| '0' => 0
| '1' => 1
| '2' => 2
| '3' => 3
| '4' => 4
| '5' => 5
| '6' => 6
| '7' => 7
| '8' => 8
| '9' => 9
| _ => ~1

implement
string2int(s) = let
  val xs = string_explode(s)
in
  list0_foldleft<int><int>
  (
  list0_map<char><int>(xs, lam(x) => char2int(x))
  , 0
  , lam(res, x) => x + (res * 10)
  )
end

implement
parse_fromto(args) = 
case+ args of
| nil0() => (0, ~1)
| cons0(a, args) => let
    val inta = string2int(a)
  in
    if inta < ~1 
    then parse_fromto(nil0())
    else 
    (
      case+ args of
      | nil0() => (inta, ~1)
      | cons0(b, args) => let
          val intb = string2int(b)
        in
          if intb < ~1 
          then (inta, ~1)
          else (inta, intb)
        end
    )
  end

(* ****** ****** *)

(* end of [cli.dats] *)