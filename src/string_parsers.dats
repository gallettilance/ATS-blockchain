(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

extern
fun
{a:t@ype}
pop_last(xs: list0(a)): list0(a)

(* ****** ****** *)

extern
fun
parse_args(s: string): list0(string)

extern
fun
parse_args_blockchain(list0(string)): (int, int)

extern
fun
parse_args_transact(list0(string)): (string, string, int)

extern
fun
parse_csv(s: string): list0(string)

(* ****** ****** *)

extern
fun
cget_time(): string = "mac#cget_time"

extern
fun
get_time(): string

extern
fun
get_date(): string

(* ****** ****** *)

implement
{a}
pop_last(xs) = let
  fun 
  {a:t@ype}
  aux(xs: list0(a), res: list0(a)): list0(a) =
    case- xs of
    | cons0(x, xs) =>
      (
        case+ xs of
        | nil0() => list0_reverse(res)
        | cons0(_, _) => aux(xs, cons0(x, res))
      ) 
in
  aux(xs, nil0())
end


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


implement
parse_csv(s) = let
  fun aux(xs: list0(char), res: list0(string), s: string): list0(string) =
    case+ xs of
    | list0_nil() => list0_reverse(cons0(s, res))
    | list0_cons(x, xs) => 
            if x = ','
            then aux(xs, cons0(s, res), "")
            else aux(xs, res, s + string_implode(list0_sing(x)))
in
  aux(string_explode(s), nil0(), "")
end

(* ****** ****** *)

%{
#include <time.h>

char *cget_time() {
  time_t curtime;
  time(&curtime);
  char * s = ctime(&curtime);
  return s;
}
%}


implement
get_date() = let
  
  fun parse(s: string): string = let
    val xs = string_explode(s)
  
    fun aux(xs: list0(char), ys: list0(char)): string =
      case+ xs of
      | list0_nil() => string_make_rlist(g1ofg0(ys))
      | list0_cons(x, xs) => 
        if x = ' ' then aux(xs, cons0('-', ys))
        else 
        (
          if x = '\n' then aux(xs, ys)
          else aux(xs, cons0(x, ys))
        )
  in
    aux(xs, nil0())
  end

in
  parse(cget_time())
end


implement
get_time() = let
  
  fun parse(s: string): string = let
    val xs = string_explode(s)
  
    fun aux(xs: list0(char), ys: list0(char), i: int): string =
      case+ xs of
      | list0_nil() => string_make_rlist(g1ofg0(ys))
      | list0_cons(x, xs) => 
        if x = ' '
        then 
        (
          if i <= 3
          then aux(xs, ys, i + 1)
          else aux(xs, cons0('-', ys), i)
        )
        else 
        (
          if x = '\n' then aux(xs, ys, i)
          else 
          (
            if i >= 3
            then aux(xs, cons0(x, ys), i)
            else aux(xs, ys, i)
          )
        )
  in
    aux(xs, nil0(), 0)
  end

in
  parse(cget_time())
end

(* ****** ****** *)

(* end of [string_parsers.dats] *)