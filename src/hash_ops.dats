(* ****** ****** *)
//
// LG 2018-04-03
//
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

char * sha256(char *s) {
  unsigned char * h = SHA256(s, strlen(s), 0);
  char *temp = malloc(4 * SHA256_DIGEST_LENGTH * sizeof(char));
  int i;
  
  for (i = 0; i < 2 * SHA256_DIGEST_LENGTH; i++)
    sprintf(temp+(i * 2), "%02x", h[i]);
  temp[i] = '\0';
  
  return temp;
}
%}

implement
hash0() =
let
  fun aux(res: string, n: int): string =
    if n = 0 then res
    else aux(res + "0", n - 1)
in
  aux("", 64)
end

implement
valid_hash(h) =
  if h <= "0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
  then true
  else false

(* ****** ****** *)

(* end of [hash_ops.dats] *)