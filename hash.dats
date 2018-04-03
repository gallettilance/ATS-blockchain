(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

#include "share/atspre_staload.hats"
#include "share/HATS/atspre_staload_libats_ML.hats"
%{
#include <openssl/sha.h>
%}

(* ****** ****** *)

abstype hash

(* ****** ****** *)

extern
fun
sha256(s: string): hash

extern
fun
eq_hash_hash(h1: hash, h2: hash): bool

extern
fun
gte_hash_hash(h1: hash, h2: hash): bool

(* ****** ****** *)

%{
  *char sha256(char *s) {
    return SHA256(s, strlen(s), 0); 
  }
%}

(* ****** ****** *)

(* end of [hash.dats] *)