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
print_sha256(hs: hash): void = "mac#"

(* ****** ****** *)

extern
fun
sha256(s: string): string = "mac#"

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

unsigned char * sha256(char *s) {
  return SHA256(s, strlen(s), 0); 
}

void print_sha256(unsigned char *s) {
  int i;
  for (i = 0; i < SHA256_DIGEST_LENGTH; i++)
    printf("%02x", s[i]);
  printf("\n");
  return;
}
%}

(* ****** ****** *)

implement 
main0() = ()
where
{
  val s = "hello"
  val hash_s = sha256(s)
  val () = print!("sha256(", s, ") is ")
  val () = print_sha256(hash_s)
}

(* ****** ****** *)

(* end of [hash.dats] *)