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
chain_init(s: string): void

extern
fun
mine(hd: header): block

extern
fun
make_block(s: string): block

extern
fun
file_write(e: block): void

extern
fun
get_chain(): chain

extern
fun
chain_append(c: chain, data: string): void

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
  val myblock = mine(head)
in
  file_write(myblock)
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
file_write(e) = let
  val out = fileref_open_exn("./blockchain.txt", file_mode_a)
  val () = fprint_string(out, int2str(e.0.0) + "," + int2str(e.0.1) + "," + e.0.2 + "," + e.0.3 + "," + e.1 + "," + e.2 + " \n")
  val () = fileref_close(out)
in
  ()
end

implement
get_chain() = let
  val f = fileref_open_opt("./blockchain.txt", file_mode_r)
  
  fun aux(lines: stream_vt(string), res: chain): chain =
      case+ !lines of
      | ~stream_vt_nil() => list0_reverse(res)
      | ~stream_vt_cons(l, lines) => 
          if list0_length(string_explode(l)) > 135 //min length of block (check for empty lines)
          then aux(lines, cons0(make_block(l), res))
          else aux(lines, res)

in
  case+ f of
  | ~None_vt() => nil0()
  | ~Some_vt(inp) => 
    let
      val theLines = streamize_fileref_line(inp)
    in
      aux(theLines, nil0())
    end
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

implement
chain_append(c, data) = 
case+ c of
| nil0() => chain_init(data)
| cons0(_, _) =>
let
  val-cons0(b0, c0) = list0_reverse(c)
  val (hd, currh, tstamp) = b0
  val (ind, _, _, _) = hd
  val nexthd = (ind + 1, 0, data, currh)
  val nextblock = mine(nexthd)
in
  file_write(nextblock)
end

(* ****** ****** *)

(* end of [block_ops.dats] *)