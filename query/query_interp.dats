(* ****** ****** *)
//
// LG 2018-02-12
//
(* ****** ****** *)

#include "./../mylibies.dats"
#include "./struct.dats"

(* ****** ****** *)

extern
fun
mkdir(f: string): int

(* ****** ****** *)

extern
fun
interp3(q0: query): qvalue

overload interp with interp3

extern
fun
interp_opr(q0: query): qvalue

extern
fun
interp_crt(q0: query): qvalue

extern
fun
interp_ins(q0: query): qvalue

extern
fun
interp_sel(q0: query): qvalue

(* ****** ****** *)

implement
interp3(q0) =
(
case q0 of
| Qint(i)  => QVint(i)
| Qstr(s)  => QVstr(s)
| Qrec(qs) => QVrec(list0_map<query><qvalue>(qs, lam(q) => interp(q)))
| Qcrt  _  => interp_crt(q0)
| Qins  _  => interp_ins(q0)
| Qsel  _  => interp_sel(q0)
| Qopr  _  => interp_opr(q0)
)


implement
interp_opr(t0) = let
  #define :: list0_cons
  #define nil list0_nil

  val-Qopr(opr, ts) = t0
  val qvs = list0_map<query><qvalue>(ts, lam(t) => interp(t))

in
  case- opr of
  | "=" =>
    (
      case- qvs of
      | QVint(i1)::QVint(i2)::nil() => QVbool(i1 = i2)
    )
  | ">" =>
    (
      case- qvs of
      | QVint(i1)::QVint(i2)::nil() => QVbool(i1 > i2)
    )
  | "<" =>
    (
      case- qvs of
      | QVint(i1)::QVint(i2)::nil() => QVbool(i1 < i2)
    )
  | ">=" =>
    (
      case- qvs of
      | QVint(i1)::QVint(i2)::nil() => QVbool(i1 >= i2)
    )
  | "<=" =>
    (
      case- qvs of
      | QVint(i1)::QVint(i2)::nil() => QVbool(i1 <= i2)
    )
  | "and" =>
    (
      case- qvs of
      | QVbool(i1)::QVbool(i2)::nil() => QVbool(i1 andalso i2)
    )
  | "or" =>
    (
      case- qvs of
      | QVbool(i1)::QVbool(i2)::nil() => QVbool(i1 orelse i2)
    )
end

%{
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

int make_dir(char* f) {
  struct stat st = {0};

  if (stat(f, &st) == -1) {
    mkdir(f, 0700);
    return 0;
  } else {
    return 1;
  }
%}


implement
interp_crt(q0) = let
  #define :: list0_cons
  #define nil list0_nil

  val-Qcrt(t_name, cs) = q0
  val qvs = list0_map<query><qvalue>(cs, lam(t) => interp(t))
  val table = "./BDB/"+ t_name +"/"
  
  fun aux(cs: list0(qvalue)): qvalue = 
    case+ cs of
    | nil0() => QVunit()
    | cons0(c, cs) => 
      let
        val-QVstr(s) = c
        val out = fileref_open_exn(table + s, file_mode_a)
        val () = fileref_close(out)
      in
        aux(cs)
      end
in
  aux(qvs)
end


implement
interp_ins(q0) = let
  #define :: list0_cons
  #define nil list0_nil

  val-Qins(q0, t_name, cs) = q0
  val cvs = list0_map<query><qvalue>(cs, lam(t) => interp(t))
  val-Qrec(rs) = q0
  val rvs = list0_map<query><qvalue>(rs, lam(t) => interp(t))
  val table = "./BDB/"+ t_name +"/"

  fun created_check(cs: list0(qvalue)): bool = 
    case+ cs of
    | nil0() => true
    | cons0(c, cs) =>
      let 
        val-QVstr(s) = c
      in
        if file_exists(table + s)
        then created_check(cs)
        else false
      end
   
  fun aux(cs: list0(qvalue), rs: list0(qvalue)): qvalue = 
    case- (cs, rs) of
    | (nil0(), nil0()) => QVunit()
    | (cons0(c, cs), cons0(r, rs)) =>
      let
        val-QVstr(s) = c
        val out = fileref_open_exn(table + s, file_mode_a)
      in
        case- r of
        | QVint(i) => 
          let
            val () = fprint_string(out, int2str(i) + ",")
            val () = fileref_close(out)
          in
            aux(cs, rs)
          end
        | QVstr(s) => 
          let
            val () = fprint_string(out, s + ",")
            val () = fileref_close(out)
          in
            aux(cs, rs)
          end
      end

in
  if created_check(cvs)
  then aux(cvs, rvs)
  else (println!("table or column not defined"); QVunit())
end


implement
interp_sel(q0) = let
  #define :: list0_cons
  #define nil list0_nil

  val-Qsel(cs, t_name) = q0
  val cvs = list0_map<query><qvalue>(cs, lam(t) => interp(t))
  val table = "./BDB/"+ t_name +"/"
  
  fun created_check(cs: list0(qvalue)): bool = 
    case+ cs of
    | nil0() => true
    | cons0(c, cs) =>
      let 
        val-QVstr(s) = c
      in
        if file_exists(table + s)
        then created_check(cs)
        else false
      end
  
  fun aux(xs: list0(qvalue)): qvalue =
    case+ cs of
    | nil0() => QVunit()
    | cons0(c, cs) =>
      let
        val-QVstr(s) = c
        val ft = fileref_open_opt(table + s, file_mode_r)
      in
        case- ft of
        | ~None_vt() => nil0()
        | ~Some_vt(lines) => let
            val theLines = streamize_fileref_line(lines)
          in
            case- !theLines of
            | ~stream_vt_cons(l, theLines) => 
          end
      end

in
  aux(cvs)
end


(* ****** ****** *)

(* end of [interp.dats] *)