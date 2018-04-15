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
chain_init(s: string): block

extern
fun
mine(b: block): block

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
  val hs = sha256(stringize(head))
in
  (head, hs)
end

implement
mine(b) = let 
  fun aux(hd: header): block = let
      val currh = sha256(stringize(hd))
    in
      if valid_hash(currh) then (hd, currh)
      else let
        val (ind, nonce, data, prevh) = hd
      in
        aux((ind, nonce + 1, data, prevh))
      end
    end
in
  aux(b.0)
end

implement
chain_append(c, data) = let
  val-cons0(b0, c0) = list0_reverse(c)
  val (hd, currh) = b0
  val (ind, _, _, _) = hd
  val nexthd = (ind + 1, 0, data, currh)
  val nextblock = (nexthd, sha256(stringize(nexthd)))
in
  list0_append<block>(c, list0_sing(mine(nextblock)))
end


(* ****** ****** *)

(* end of [block_ops.dats] *)