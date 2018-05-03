(* ****** ****** *)
//
// LG 2018-02-12
//
(* ****** ****** *)

typedef matrix(a) = list0(list0(a))

(*
extern
fun
mkdir(f: string): int
*)

extern
fun
{b:t@ype}
matrix_get_col
( A: matrix b ) : int

extern
fun
{b:t@ype}
matrix_get_row
( A: matrix b ) : int

extern
fun
{b:t@ype}
matrix_transpose
( A: matrix b ) : matrix b

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
{a}
matrix_get_col(A) = 
case+ A of
| nil0() => 0
| cons0(row, _) => list0_length(row)


implement
{a}
matrix_get_row(A) = list0_length(A)


implement
{a}
matrix_transpose(A) = let

  val row = matrix_get_row(A)
  val col = matrix_get_col(A)
  val () = assertloc(row > 0 andalso col > 0)

  fun get_col
  (i: int): list0(a) = let
      val () = assertloc(i >= 0 andalso i < col)
    in
      list0_map(A, lam(row) => row[i])
    end
    
  fun aux(i: int, res: matrix a): matrix a =
    if i < 0 then res
    else aux(i - 1, cons0(get_col(i), res))

in
  aux(col - 1, nil0())
end

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

  val-Qopr(opr, terms) = t0
  val-Qrec(ts) = terms
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

(*
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
*)

implement
interp_crt(q0) = let
  #define :: list0_cons
  #define nil list0_nil

  val-Qcrt(t_name, cols) = q0
  val-Qrec(cs) = cols
  val qvs = list0_map<query><qvalue>(cs, lam(t) => interp(t))
  val table = "./BDB/"+ t_name +"/"
  val err = $extfcall(int, "mkdir", table, 0700)
  val () = assertloc(err = 0)
  
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

  val-Qins(t_name, cols, q1) = q0
  val-Qrec(cs) = cols
  val cvs = list0_map<query><qvalue>(cs, lam(t) => interp(t))
  val-Qrec(rs) = q1
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

  val-Qsel(t_name, cols) = q0
  val-Qrec(cs) = cols
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
  
  fun aux(cs: list0(qvalue), res: list0(list0(string))): list0(list0(string)) =
    case+ cs of
    | nil0() => matrix_transpose(list0_reverse(res))
    | cons0(c, cs) =>
      let
        val-QVstr(s) = c
        val ft = fileref_open_opt(table + s, file_mode_r)
      in
        case- ft of
        | ~None_vt() => aux(cs, cons0(nil0(), res))
        | ~Some_vt(lines) => let
            val theLines = streamize_fileref_line(lines)
          in
            case- !theLines of
            | ~stream_vt_cons(l, theLines) => (~theLines; aux(cs, cons0(parse_csv(l), res)))
          end
      end
  
  fun is_not_nil(v: qvalue): bool =
    case- v of
    | QVstr(s) => list0_length(string_explode(s)) = 0
    | QVrec(xs) => list0_length(list0_filter(xs, lam(x) => is_not_nil(x))) = 0
    
in
  let
    val xs = aux(cvs, nil0())
    val qs = list0_map<list0(string)><qvalue>(xs, lam(ys) => QVrec(list0_map<string><qvalue>(ys, lam(y) => QVstr(y))))
  in
    QVrec(list0_filter(qs, lam(q) => is_not_nil(q)))
  end
end

(* ****** ****** *)

(* end of [interp.dats] *)