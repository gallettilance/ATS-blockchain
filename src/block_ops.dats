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
file_write_block(e: block): void

(* ****** ****** *)

implement
mine(hd) = let 
  val (ind, nonce, trns, code, qry, h) = hd
  val temp = list0_filter(trns, lam(t) => is_valid_transact(t))
  val theValids = list0_filter(temp, lam(t) => make_transact(t))
  
  fun aux(hd: header): block = let
      val currh = sha256(encode_header(hd))
    in
      if valid_hash(currh) then (hd, currh, get_time())
      else let
        val (ind, nonce, data, res, qry, prevh) = hd
      in
        aux((ind, nonce + 1, data, res, qry, prevh))
      end
    end
in
  aux((ind, nonce, theValids, code, qry, h))
end


implement
file_write_block(b) = let
  val out = fileref_open_exn("./blockchain.txt", file_mode_a)
  val () = fprint_string(out, encode_block(b))
  val () = fileref_close(out)
in
  ()
end


(* ****** ****** *)

(* end of [block_ops.dats] *)