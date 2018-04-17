(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

extern
fun
chain_init(s: string): void

extern
fun
file_write_block(e: block): void

extern
fun
get_chain(from: int, to: int): chain

extern
fun
chain_add(): void

(* ****** ****** *)

implement
chain_init(s) = let
  val myblockstr = "0,0,{"+ s + "}," + hash0() + ",," + get_time()
  val myblock = make_block(myblockstr)
  val (head, _, _) = myblock
  val block0 = mine(head)
in
  file_write_block(block0)
end


implement
file_write_block(e) = let
  val out = fileref_open_exn("./blockchain.txt", file_mode_a)
  val () = fprint_string(out, int2str(e.0.0) + "," + int2str(e.0.1) + ",{" + e.0.2 + "}," + e.0.3 + "," + e.1 + "," + e.2 + " \n")
  val () = fileref_close(out)
in
  ()
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
              then aux(lines, cons0(make_block(l), res), from, to - 1)
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
  | nil0() => chain_init(get_transact())
  | cons0(_, _) =>
      let
        val trns = get_transact()
        
        val-cons0(b0, c0) = list0_reverse(c)
        val (hd, currh, tstamp) = b0
        val (ind, _, _, _) = hd
        
        val myblockstr = int2str(ind + 1) + ",0,{" + trns + "}," + currh + "," + "," + get_time()
        val myblock = make_block(myblockstr)
        
        val (hd, _, _) = myblock
        val nextblock = mine(hd)
      in
        file_write_block(nextblock)
      end
end


(* ****** ****** *)

(* end of [chain_ops.dats] *)