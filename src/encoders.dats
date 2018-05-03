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

extern
fun
encode_contract(c: contract): string

extern
fun
encode_state(s: statement): string

extern
fun
encode_queries(q: queries): string

extern
fun
encode_result(r: result): string

extern
fun
encode_usercode(xs: list0(string)): string

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

extern
fun
decode_contract(s: string): contract

extern
fun
decode_state(s: string): statement

extern
fun
decode_queries(s: string): queries

extern
fun
decode_result(s: string): result

(* ****** ****** *)

implement
encode_header(hd) = let
  val s = int2str(hd.0) + int2str(hd.1) 
  val s = s + encode_data(hd.2) 
  val s = s + encode_result(hd.3)
  val s = s + encode_queries(hd.4)
  val s = s + hd.5
in
  s
end


implement
encode_transact(t) = "{" + t.0 + "," + t.1 + "," + int2str(t.2) + "}"


implement
encode_contract(c) = "{" + c.0 + "," + c.1 + "," + int2str(c.2) + "}"


implement
encode_state(s) = "{" + s.0 + "," + int2str(s.1) + "}"


implement
encode_block(b) = 
int2str(b.0.0) + "," + int2str(b.0.1) + ",[" + encode_data(b.0.2) + "][" + encode_result(b.0.3) + "][" + encode_queries(b.0.4) + "]" + b.0.5 + "," + b.1 + "," + b.2 + " \n"


implement
encode_data(d) = let 
  fun aux(d: data, res: string): string = 
    case+ d of 
    | nil0() => res
    | cons0(trns, d) => aux(d, res + encode_transact(trns))
in
  aux(d, "")
end


implement
encode_result(r) = let 
  fun aux(r: result, res: string): string = 
    case+ r of 
    | nil0() => res
    | cons0(cntr, r) => aux(r, res + encode_contract(cntr))
in
  aux(r, "")
end


implement
encode_queries(q) = let 
  fun aux(q: queries, res: string): string = 
    case+ q of 
    | nil0() => res
    | cons0(s, q) => aux(q, res + encode_state(s))
in
  aux(q, "")
end


implement
encode_usercode(xs) = let
  fun aux(xs: list0(string), s: string): string =
    case+ xs of
    | nil0() => s
    | cons0(x, xs) => 
      (
        case+ xs of
        | nil0() => aux(xs, s + x)
        | cons0(_, _) => aux(xs, s + x + " ")
      )
in
  aux(xs, "")
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
decode_contract(s) = let
  val xs = parse_csv(s)
  val-cons0(id, xs) = xs
  val-cons0(v, xs) = xs
  val-cons0(g, _) = xs
in
  (id, v, string2int(g))
end


implement
decode_state(s) = let
  val xs = parse_csv(s)
  val-cons0(q, xs) = xs
  val-cons0(g, _) = xs
in
  (q, string2int(g))
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
decode_result(s) = let
  fun aux(xs: list0(char), res: result, s: string): result = 
    case+ xs of
    | nil0() =>
            (
              let 
                val c = decode_contract(s) : contract
              in 
                cons0(c, res)
              end
            )
    | cons0(x, xs) => 
          if x = '}'
          then 
          (
            case+ xs of 
            | nil0() => aux(xs, res, s)
            | cons0(x, xs) => aux(xs, cons0( decode_contract(s), res), "") 
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
decode_queries(s) = let
  fun aux(xs: list0(char), res: queries, s: string): queries = 
    case+ xs of
    | nil0() =>
            (
              let 
                val c = decode_state(s)
              in 
                cons0(c, res)
              end
            )
    | cons0(x, xs) => 
          if x = '}'
          then 
          (
            case+ xs of 
            | nil0() => aux(xs, res, s)
            | cons0(x, xs) => aux(xs, cons0( decode_state(s), res), "") 
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
  
  fun strip(xs: list0(char), data: list0(char)): (list0(char), list0(char)) =
    case- xs of
    | list0_cons(d, xs) => if d = ']' then (xs, list0_reverse(data)) else strip(xs, cons0(d, data))
    
  fun aux(xs: list0(char), res: list0(string), s: string): list0(string) =
    case+ xs of
    | list0_nil() => list0_reverse(cons0(s, res))
    | list0_cons(x, xs) => 
          case x of
          | '\[' => 
                let 
                  val (xs, data) = strip(xs, nil0()) 
                in 
                  aux(xs, cons0(string_implode(data), res), "") 
                end
          | ',' => aux(xs, cons0(s, res), "")
          | _ => aux(xs, res, s + string_implode(list0_sing(x)))
          
in
  let
    val xs = aux(string_explode(s), nil0(), "")
    val-cons0(ind, xs) = xs
    val-cons0(nonce, xs) = xs
    val-cons0(d, xs) = xs
    val-cons0(r, xs) = xs
    val-cons0(q, xs) = xs
    val-cons0(prevh, xs) = xs
    val-cons0(currh, xs) = xs
    val-cons0(tstamp, xs) = xs
  in
    ((g0string2int_int(ind), g0string2int_int(nonce), decode_data(d), decode_result(r), decode_queries(q), prevh)
    , currh
    , tstamp )
  end
end

(* ****** ****** *)

(* end of [encoders.dats] *)
