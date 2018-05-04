(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

extern
fun
transact(t: transaction): void

extern
fun
is_valid_transact(t: transaction): bool

extern
fun
make_transact(t: transaction): bool //same as is_valid_transact with necessary side effect

extern
fun
get_data(): data

extern
fun
encode_transact(t: transaction): string

extern
fun
clear_transact(): void

extern
fun
file_write_transact(t: transaction): void

extern
fun
get_coins(a: string): int

extern
fun
set_coins(a: string, q: int): void

extern
fun
is_miner(a: string): bool

extern
fun
reward(a: string): void

(* ****** ****** *)

implement
is_miner(a) = file_exists("./" + a + ".txt")


implement
reward(a) = let
  val coins = get_coins(a)
  val () = set_coins(a, coins + 10)
in
  ()
end


implement
clear_transact() = (remove_file("./transaction.txt"); remove_file("./value.txt"); remove_file("./queries.txt"))  


implement
get_coins(a) = let
  val f = fileref_open_opt("./" + a + ".txt", file_mode_r)
in
  case- f of
  | ~Some_vt(coins) => let
      val theLines = streamize_fileref_line(coins)
    in
      case- !theLines of
      | ~stream_vt_cons(l, theLines) => (~theLines; string2int(l))
    end
end


implement
set_coins(a, q) = let
  val () = remove_file("./" + a + ".txt")
  val out = fileref_open_exn("./" + a + ".txt", file_mode_a)
  val () = fprint_string(out, int2str(q))
  val () = fileref_close(out)
in
  ()
end


implement
file_write_transact(t) = let
  val out = fileref_open_exn("./transaction.txt", file_mode_a)
  val () = fprint_string(out, encode_transact(t))
  val () = fileref_close(out)
in
  ()
end


implement
is_valid_transact(t) = let
  val sender = t.0
  val receiver = t.1
  val amount = t.2
  val test_exists = is_miner(sender) andalso is_miner(receiver)
in
  if test_exists
  then
  ( 
    let 
      val sender_balance = get_coins(sender)
      val receiver_balance = get_coins(receiver)
      val test_balance = sender_balance >= amount
    in
      if test_balance
      then true
      else false
    end
  )
  else false
end


implement
make_transact(t) = let
  val sender = t.0
  val receiver = t.1
  val amount = t.2
  val test_exists = is_miner(sender) andalso is_miner(receiver)
in
  if test_exists
  then
  ( 
    let 
      val sender_balance = get_coins(sender)
      val receiver_balance = get_coins(receiver)
      val test_balance = sender_balance >= amount
    in
      if test_balance
      then (set_coins(sender, sender_balance - amount); set_coins(receiver, receiver_balance + amount); true)
      else false
    end
  )
  else false
end


implement
transact(t) = 
file_write_transact(t)


implement
get_data() = let
  val ft = fileref_open_opt("./transaction.txt", file_mode_r)
in
  case- ft of
  | ~None_vt() => nil0()
  | ~Some_vt(trns) => let
      val theLines = streamize_fileref_line(trns)
    in
      case- !theLines of
      | ~stream_vt_cons(l, theLines) => (~theLines; decode_data(l))
    end
end

(* ****** ****** *)

(* end of [block_ops.dats] *)

