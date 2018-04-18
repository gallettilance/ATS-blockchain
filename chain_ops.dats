(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

extern
fun
chain_init(d: list0(transaction)): void

extern
fun
get_chain(from: int, to: int): chain

extern
fun
chain_add(): void

(* ****** ****** *)

implement
chain_init(d) = let
  val head = (0, 0, d, hash0())
  val block0 = mine(head)
in
  file_write_block(block0)
end


implement
get_chain(from, to) = let
  val fb = fileref_open_opt("./blockchain.txt", file_mode_r)
  
  fun aux(lines: stream_vt(string), res: chain, from: int, to: int): chain =
      if to = 0 then (~lines; list0_reverse(res))
      else
      (
        case+ !lines of
        | ~stream_vt_nil() => list0_reverse(res)
        | ~stream_vt_cons(l, lines) => 
          if from > 0 then aux(lines, res, from - 1, to - 1)
          else 
          (
              if list0_length(string_explode(l)) > 135 //min length of block (check for empty lines)
              then aux(lines, cons0(decode_block(l), res), from, to - 1)
              else aux(lines, res, from, to - 1)
          )
      )

in
  case+ fb of
  | ~None_vt() => nil0()
  | ~Some_vt(blks) => 
    let
      val theLines = streamize_fileref_line(blks)
    in
      aux(theLines, nil0(), from, to)
    end
end


implement
chain_add() = let
  val c = get_chain(0, ~1)
in
  case+ c of
  | nil0() => chain_init(get_data())
  | cons0(_, _) =>
      let
        val trns = get_data()
        
        val-cons0(b0, c0) = list0_reverse(c)
        val (hd, currh, tstamp) = b0
        val (ind, _, _, _) = hd
        
        val head = (ind + 1, 0, trns, currh)
        val nextblock = mine(head)
        
      in
        file_write_block(nextblock)
      end
end


(* ****** ****** *)

(* end of [chain_ops.dats] *)