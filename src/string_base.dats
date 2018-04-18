(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

extern
fun
int2string(i: int, b: int): string

extern
fun
int2str(n: int): string

extern
fun
char2int(c: char): int

extern
fun
string2int(s: string): int

(* ****** ****** *)

implement
int2string(i, b) = let

    val () = assertloc(i >= 0)

    fun dig2str(i:int): string =    
        if i = 0 then "0"
        else if i = 1 then "1"
        else if i = 2 then "2"
        else if i = 3 then "3"
        else if i = 4 then "4"
        else if i = 5 then "5"
        else if i = 6 then "6"
        else if i = 7 then "7"
        else if i = 8 then "8"
        else if i = 9 then "9"
        else ""

    fun helper(i: int, res: string): string =
        if i > 0 then helper(i / b, dig2str(i % b) + res)
        else res
in
  if i = 0 then "0"
  else helper(i, "")
end

implement
int2str(n) = int2string(n, 10)

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

(* ****** ****** *)

(* end of [string_base.dats] *)