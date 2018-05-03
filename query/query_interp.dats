(* ****** ****** *)
//
// LG 2018-02-12
//
(* ****** ****** *)

#include "share/atspre_staload.hats"
#include "share/HATS/atspre_staload_libats_ML.hats"
#include "./struct.dats"

(* ****** ****** *)

extern
fun
mkdir(f: string): int

(* ****** ****** *)

extern
fun
interp(q0: query): qvalue

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
interp(q0) =
(
case q0 of
| Qint(i)  => QVint(i)
| Qstr(s)  => QVstr(s)
| Qrec(qs) => QVrec(list0_map<query><qvalue>(qs, lam(q) => interp(q)))
| Qcrt(s, cs) => interp_crt(q0)
| Qins(q0, q1, qs) => interp_ins(q0)
| Qsel(qs, tb, cn) => interp_sel(q0)
| Qopr(s, qs) => interp_opr(q0)
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

  val-Qcrt(t, cs) = q0
  val qvs = list0_map<query><qvalue>(cs, lam(t) => interp(t))
  val table = "./BDB/"+ t +"/"
  
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


(* ****** ****** *)

(* end of [interp.dats] *)