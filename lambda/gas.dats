(* ****** ****** *)
//
// LG 2018-02-22
//
(* ****** ****** *)

extern
fun
get_gas(t: term): int

(* ****** ****** *)

implement
get_gas(t) = let
  fun aux(t0: term, res: int): int =
    case+ t0 of
    | TMint(_)       =>    res + 1
    | TMstr(_)       =>    res + 1
    | TMtup(ts)      =>    list0_foldleft<int>(ts, res + 1, lam(res, t) => res + aux(t, 0))
    | TMproj(t1, _)  =>    aux(t1, res + 1) 
    | TMvar(_)       =>    res + 1
    | TMlam(_, t1)   =>    aux(t1, res + 1)
    | TMapp(t1, t2)  =>  
          (  
            let 
              val r1 = aux(t1, res)
              val r2 = aux(t2, res)
            in
              1 + r1 + r2
            end
          )
    | TMfix(_, _, t1)     =>  aux(t1, res + 1)
    | TMopr(_, ts)        =>  list0_foldleft<int>(ts, res + 1, lam(res, t) => res + aux(t, 0))
    | TMifnz(t1, t2, t3)  =>
          (   
            let 
              val r1 = aux(t1, res)
              val r2 = aux(t2, res)
              val r3 = aux(t3, res)
            in
              1 + r1 + r2 + r3
            end
          )
    | TMseq(t1, t2)  =>  
          (  
            let 
              val r1 = aux(t1, res)
              val r2 = aux(t2, res)
            in
              1 + r1 + r2
            end
          )
in
  aux(t, 0)
end

(* ****** ****** *)

(* end of [gas.dats] *)