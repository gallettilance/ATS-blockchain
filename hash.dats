(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

#include "share/atspre_staload.hats"
#include "share/HATS/atspre_staload_libats_ML.hats"

(* ****** ****** *)

typedef hash = string

(* ****** ****** *)

extern
fun
get_sha256(s: string): string = "mac#"

extern
fun
sha256(s: string): string

extern
fun
hex(c: char): char = "mac#"

extern
fun
eq_hash_hash(h1: hash, h2: hash): bool

extern
fun
gte_hash_hash(h1: hash, h2: hash): bool

(* ****** ****** *)

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/sha.h>

unsigned char * get_sha256(char *s) {
  return SHA256(s, strlen(s), 0); 
}

unsigned char hex(unsigned char c) {
  return strtol (&c, NULL, 16);
}
%}

implement
sha256(s) = let
  val xs = string_explode(s)
in
  string_implode(list0_map(xs, lam(x) => hex(x)))
end

(* ****** ****** *)

implement 
main0() = ()
where
{
  val s = "hello"
  val hash_s = sha256(s)
  val () = println!("sha256(", s, ") is ", hash_s)
}

(* ****** ****** *)

(* end of [hash.dats] *)