(* ****** ****** *)
//
// LG 2018-02-17
//
(* ****** ****** *)

#include "./../mylibies.dats"
#include "./mylibies.dats"

(* ****** ****** *)

implement
main0() = ()
where
{
  val err = $extfcall(int, "mkdir", "./BDB", 0700)
  val () = assertloc(err = 0)
(*
  val create_table = Qcrt("mytable", Qrec(list0_tuple(Qstr("col1"), Qstr("col2"))))
  val-QVunit() = interp(create_table)
  val insert1 = Qins("mytable", Qrec(list0_tuple(Qstr("col1"), Qstr("col2"))), Qrec(list0_tuple(Qstr("hello"), Qint(1))))
  val-QVunit() = interp(insert1)
  val insert2 = Qins("mytable", Qrec(list0_tuple(Qstr("col1"), Qstr("col2"))), Qrec(list0_tuple(Qstr("world"), Qint(2))))
  val-QVunit() = interp(insert2)
  val insert3 = Qins("mytable", Qrec(list0_tuple(Qstr("col1"), Qstr("col2"))), Qrec(list0_tuple(Qstr("!!!"), Qint(3))))
  val-QVunit() = interp(insert3)
  val select = Qsel("mytable", Qrec(list0_tuple(Qstr("col1"), Qstr("col2"))))
  val-QVrec(xs) = interp(select)
  val () = (xs).foreach()(lam(x) => println!(x))
*)
  val file1 = "example/query1.txt"
  val file2 = "example/query2.txt"
  val file3 = "example/query3.txt"
  val out1 = fileref_open_exn("example/output1.txt", file_mode_a)
  val out2 = fileref_open_exn("example/output2.txt", file_mode_a)
  val out3 = fileref_open_exn("example/output3.txt", file_mode_a)
  val () = fprint!(out1, interp(qparse_lisp(file1)))
  val () = fprint!(out2, interp(qparse_lisp(file2)))
  val () = fprint!(out3, interp(qparse_lisp(file3)))
  val () = fileref_close(out1)
  val () = fileref_close(out2)
  val () = fileref_close(out3)
}

(* ****** ****** *)

(* end of [test.dats] *)