(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

extern
fun
cget_time(): string = "mac#cget_time"

extern
fun
get_time(): string

extern
fun
mine(hd: header): block

extern
fun
make_block(s: string): block

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
make_block(s) = let
  
  fun aux(xs: list0(char), res: list0(string), s: string): list0(string) =
    case+ xs of
    | list0_nil() => list0_reverse(cons0(s, res))
    | list0_cons(x, xs) => 
          if x = ',' 
          then aux(xs, cons0(s, res), "")
          else aux(xs, res, s + string_implode(list0_sing(x)))
in
  let
    val xs = aux(string_explode(s), nil0(), "")
    val-cons0(ind, xs) = xs
    val-cons0(nonce, xs) = xs
    val-cons0(data, xs) = xs
    val-cons0(prevh, xs) = xs
    val-cons0(currh, xs) = xs
    val-cons0(tstamp, xs) = xs
  in
    ((g0string2int_int(ind), g0string2int_int(nonce), data, prevh)
    , currh
    , tstamp )
  end
end

(* ****** ****** *)

(* end of [block_ops.dats] *)