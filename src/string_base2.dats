(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

extern
fun
val2str(v: value): string

extern
fun
term2str(t: term): string

extern
fun
env2str(e: envir): string

extern
fun
qval2str(v: qvalue): string

(* ****** ****** *)

implement
qval2str(v) =
case+ v of
| QVunit()  => "QVunit()"
| QVint(i)  => "QVint("  + int2str(i) + ")"
| QVstr(s)  => "QVstr("  + s + ")"
| QVbool(b) => if b then "QVbool(T)" else "QVbool(F)"
| QVrec(vs) => "QVrec(" + list0_foldleft<string>(vs, " ", lam(res, x) => res + qval2str(x) + " ") + ")"


implement
val2str(v) =
  case+ v of
  | VALunit() => "VALunit"
  | VALint(i) => "VALint("+ int2str(i) + ")"
  | VALstr(s) => "VALstr("+ s + ")"
  | VALtup(xs) => "VALtup("+ list0_foldleft(xs, " ", lam(res, x) => res + val2str(x) + " ") + ")"
  | VALfix(t, e) => "VALfix("+ term2str(t) + env2str(e) + ")"
  | VALlam(t, e) => "VALlam("+ term2str(t) + env2str(e) + ")"


implement
term2str(t) =
  case+ t of
  | TMint(i) => "TMint(" + int2str(i) + ")"
  | TMstr(s) => "TMstr(" + s + ")"
  | TMtup(xs) => "TMtup(" + list0_foldleft(xs, " ", lam(res, x) => res + term2str(x) + " ") + ")"
  | TMproj(t, i) => "TMproj(" + term2str(t) + "," + int2str(i) + ")"
  | TMvar(x) => "TMvar(" + x + ")"
  | TMlam(s, t) => "TMlam(" + s + "," + term2str(t) + ")"
  | TMapp(t0, t1) => "TMapp(" + term2str(t0) + "," + term2str(t1) + ")"
  | TMfix(s0, s1, t) => "TMfix(" + s0 + "," + s1 + "," + term2str(t) + ")"
  | TMopr(s, xs) => "TMopr(" + s + "," + list0_foldleft(xs, " ", lam(res, x) => res + term2str(x) + " ") + ")"
  | TMifnz(t0, t1, t2) => "TMifnz(" + term2str(t0) + "," + term2str(t1) + "," + term2str(t2) +")"
  | TMseq(t0, t1) => "TMseq(" + term2str(t0) + "," + term2str(t1) + ")"


implement
env2str(e) = list0_foldleft(e, " ", lam(res, x) => res + "(" + x.0 + "," + val2str(x.1) + ") ")

(* ****** ****** *)

(* end of [string_base2.dats] *)