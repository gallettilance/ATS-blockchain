(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

extern
fun
encode_header(hd: header): string

extern
fun
encode_block(b: block): string

extern
fun
encode_transact(t: transaction): string

extern
fun
encode_data(d: data): string

(* ****** ****** *)

extern
fun
decode_data(s: string): data

extern
fun
decode_transact(s: string): transaction

extern
fun
decode_block(s: string): block

(* ****** ****** *)

implement
encode_header(hd) = let
  val s = int2str(hd.0) + int2str(hd.1) 
  val s = s + encode_data(hd.2) 
  val s = s + hd.3
in
  s
end

implement
encode_transact(t) = "{" + t.0 + "," + t.1 + "," + int2str(t.2) + "}"


implement
encode_block(b) = 
int2str(b.0.0) + "," + int2str(b.0.1) + ",[" + encode_data(b.0.2) + "]" + b.0.3 + "," + b.1 + "," + b.2 + " \n"


implement
encode_data(d) = let 
  fun aux(d: data, res: string): string = 
    case+ d of 
    | nil0() => res
    | cons0(trns, d) => aux(d, res + encode_transact(trns))
in
  aux(d, "")
end

(* ****** ****** *)

implement
decode_transact(s) = let
  val xs = parse_csv(s)
  val-cons0(from, xs) = xs
  val-cons0(to, xs) = xs
  val-cons0(amount, xs) = xs
in
  (from, to, string2int(amount))
end


implement
decode_data(s) = let
  fun aux(xs: list0(char), res: data, s: string): data = 
    case+ xs of
    | nil0() =>
            ( 
              let 
                val t = decode_transact(s) : transaction
              in 
                cons0(t, res) 
              end
            )
    | cons0(x, xs) => 
          if x = '}'
          then 
          (
            case+ xs of 
            | nil0() => aux(xs, res, s)
            | cons0(x, xs) => aux(xs, cons0( decode_transact(s), res), "") 
          )
          else
          (
            if x = '\{' orelse x = '\0'
            then aux(xs, res, s)
            else aux(xs, res, s + string_implode(list0_sing(x)))
          )
in
  aux(string_explode(s), nil0(), "")
end


implement
decode_block(s) = let
  
  fun strip(trns: list0(char), xs: list0(char)): (list0(char), list0(char)) =
    case- trns of
    | list0_cons(t, trns) => if t = ']' then (xs, trns) else strip(trns, cons0(t, xs))
  
  fun aux(xs: list0(char), res: list0(string), s: string): list0(string) =
    case+ xs of
    | list0_nil() => list0_reverse(cons0(s, res))
    | list0_cons(x, xs) => 
          if x = '\['
          then 
          (
            let 
              val (xs, data) = strip(list0_reverse(xs), nil0()) 
            in 
              aux(xs, cons0(string_implode(list0_reverse(data)), res), "") 
            end
          )
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
    val-cons0(d, xs) = xs
    val-cons0(prevh, xs) = xs
    val-cons0(currh, xs) = xs
    val-cons0(tstamp, xs) = xs
  in
    ((g0string2int_int(ind), g0string2int_int(nonce), decode_data(d), prevh)
    , currh
    , tstamp )
  end
end

(* ****** ****** *)

(* end of [encoders.dats] *)
