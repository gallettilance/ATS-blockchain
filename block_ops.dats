(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

extern
fun
stringize(hd: header): string

(* ****** ****** *)

extern
fun
cget_time(): string = "mac#cget_time"

extern
fun
get_time(): string

extern
fun
chain_init(s: string): block

extern
fun
mine(hd: header): block

extern
fun
check_pfow(b: block): bool

extern
fun
validate(c: chain): block

extern
fun
chain_append(c: chain, data: string): chain

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
get_time() = let
  
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
stringize(hd) = let
  val s = int2str(hd.0) + int2str(hd.1) 
  val s = s + hd.2 
  val s = s + hd.3
in
  s
end

implement
chain_init(s) = let
  val head = (0, 0, s, hash0())
in
  mine(head)
end

implement
mine(hd) = let 
  fun aux(hd: header): block = let
      val currh = sha256(stringize(hd))
    in
      if valid_hash(currh) then (hd, currh, get_time())
      else let
        val (ind, nonce, data, prevh) = hd
      in
        aux((ind, nonce + 1, data, prevh))
      end
    end
in
  aux(hd)
end

implement
chain_append(c, data) = let
  val-cons0(b0, c0) = list0_reverse(c)
  val (hd, currh, tstamp) = b0
  val (ind, _, _, _) = hd
  val nexthd = (ind + 1, 0, data, currh)
in
  list0_append<block>(c, list0_sing(mine(nexthd)))
end


(* ****** ****** *)

(* end of [block_ops.dats] *)