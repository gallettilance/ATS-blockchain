(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

#include "./hash.dats"

(* ****** ****** *)
(*
#include "share/atspre_staload.hats"
#include "share/HATS/atspre_staload_libats_ML.hats"
*)
(* ****** ****** *)

extern
fun
print_sha256(hs: hash): void = "mac#"

(* ****** ****** *)

extern
fun
sha256(s: string): string = "mac#"

extern
fun
hash0(): string

extern
fun
valid_hash(h: hash): bool

(* ****** ****** *)

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/sha.h>

unsigned char * sha256(char *s) {
  return SHA256(s, strlen(s), 0); 
}

void print_sha256(unsigned char *s) {
  int i;
  for (i = 0; i < SHA256_DIGEST_LENGTH; i++)
    printf("%02x", s[i]);
  return;
}
%}

implement
hash0() = let
  fun aux(res: string, n: int): string =
    if n = 0 then res
    else aux(res + "0", n - 1)
in
  aux("", 64)
end

implement
valid_hash(h) = let
  val hs = string_explode(h)
in
  if hs[0] = '0' andalso hs[1] = '0' andalso hs[2] = '0' andalso hs[3] = '0'
  then true
  else false
end

(* ****** ****** *)

(*
implement 
main0() = ()
where
{
  val s = "hello"
  val hash_s = sha256(s)
  val () = print!("sha256(", s, ") is ")
  val () = print_sha256(hash_s)
}
*)

(* ****** ****** *)

(* end of [hash_ops.dats] *)