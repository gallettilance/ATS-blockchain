(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

extern
fun
parse_args_blockchain(list0(string)): (int, int)

extern
fun
parse_args_transact(list0(string)): (string, string, int)

(* ****** ****** *)

implement
parse_args_blockchain(args) = 
case+ args of
| nil0() => (0, ~1)
| cons0(a, args) => let
    val inta = string2int(a)
  in
    if inta < ~1 
    then parse_args_blockchain(nil0())
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


implement
parse_args_transact(args) = 
case- args of
| cons0(a, args) => 
      case- args of
      | cons0(b, args) => 
            case- args of
            | cons0(c, args) => (a, b, string2int(c))



(* ****** ****** *)

(* end of [string_parsers.dats] *)