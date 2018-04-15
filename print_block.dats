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

(* ****** ****** *)

extern
fun
print_line(out: FILEref, n: int): void

extern
fun
print_blank(out: FILEref, n: int): void

extern
fun
print_centered(out: FILEref, s: string, n: int): void

(* ****** ****** *)

extern
fun
print_block(b0: block): void // stdout
and
prerr_block(b0: block): void // stderr

extern
fun
fprint_block(out: FILEref, b0: block): void

(* ****** ****** *)

overload print with print_block
overload prerr with prerr_block
overload fprint with fprint_block

(* ****** ****** *)

implement
print_block(b0) =
fprint_block(stdout_ref, b0)
implement
prerr_block(b0) =
fprint_block(stderr_ref, b0)

(* ****** ****** *)

implement
fprint_block(out, b0) = let

  val head = b0.0
  val currh = b0.1
  val tstamp = b0.2
  
  val block_num = "block #0" + int2str(head.0)
  val nounce = int2str(head.1)
  val data = head.2
  
  val prevh = head.3
  
  val col = 17
  val row = 70 + col

in
(
  print_line(out, row);
  fprint!(out, "|");
  print_centered(out, block_num, row - 2);
  fprint!(out, "|\n");
  
  print_line(out, row);
  fprint!(out, "|");
  print_centered(out, "TimeStamp", col);
  fprint!(out, "|");
  print_centered(out, tstamp, row - col - 3);
  fprint!(out, "|\n");
  
  print_line(out, row);
  fprint!(out, "|");
  print_centered(out, "Nounce", col);
  fprint!(out, "|");
  print_centered(out, nounce, row - col - 3);
  fprint!(out, "|\n");

  print_line(out, row);
  fprint!(out, "|");
  print_centered(out, "Data", col);
  fprint!(out, "|");
  print_centered(out, data, row - col - 3);
  fprint!(out, "|\n");  
  
  print_line(out, row);
  fprint!(out, "|");
  print_centered(out, "Previous Hash", col);
  fprint!(out, "|");
  print_centered(out, prevh, row - col - 3);
  fprint!(out, "|\n");
  
  print_line(out, row);
  fprint!(out, "|");
  print_centered(out, "Hash", col);
  fprint!(out, "|");
  print_centered(out, currh, row - col - 3);
  fprint!(out, "|\n");

  print_line(out, row);
)
end

(* ****** ****** *)

implement
print_blank(out, n) =
if n = 0 then fprint!(out, "")
else (fprint!(out, " "); print_blank(out, n - 1))

implement
print_line(out, n) =
if n = 0 then fprint!(out, "\n")
else (fprint!(out, "-"); print_line(out, n - 1))

implement
print_centered(out, s, n) = let
  val len = list0_length(string_explode(s))
  val lpad = (n - len) / 2
  val rpad = n - len - lpad
in
  (
    print_blank(out, lpad);
    fprint!(out, s);
    print_blank(out, rpad)
  )
end

(* ****** ****** *)

(* end of [print_block.dats] *)