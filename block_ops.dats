(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

extern
fun
mine(hd: header): block

extern
fun
make_block(s: string): block

(* ****** ****** *)

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
  
  fun aux0(xs: list0(char), s: string): (list0(char), string) =
    case- xs of
    | list0_cons(x, xs) => 
          if x = '}'
          then let val-cons0(x, xs) = xs in (xs, s) end
          else aux0(xs, s + string_implode(list0_sing(x)))
  
  fun aux(xs: list0(char), res: list0(string), s: string): list0(string) =
    case+ xs of
    | list0_nil() => list0_reverse(cons0(s, res))
    | list0_cons(x, xs) => 
          if x = '\{'
          then let val (xs, trns) = aux0(xs, "") in aux(xs, cons0(trns, res), "") end
          else
          (
            if x = ','
            then aux(xs, cons0(s, res), "")
            else aux(xs, res, s + string_implode(list0_sing(x)))
          )
          
in
  let
    val xs = aux(string_explode(s), nil0(), "")
    val-cons0(ind, xs) = xs
    val-cons0(nonce, xs) = xs
    val-cons0(trns, xs) = xs
    val-cons0(prevh, xs) = xs
    val-cons0(currh, xs) = xs
    val-cons0(tstamp, xs) = xs
  in
    ((g0string2int_int(ind), g0string2int_int(nonce), trns, prevh)
    , currh
    , tstamp )
  end
end

(* ****** ****** *)

(* end of [block_ops.dats] *)