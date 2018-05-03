(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

extern
fun
remove_file(f: string): void = "mac#remove_file_c"

extern
fun
file_exists_aux(f: string): int = "mac#file_exists_c"

extern
fun
file_exists(f: string): bool

(* ****** ****** *)

%{
#include <unistd.h>
#include <stdbool.h>

int file_exists_c(char* f) {
  if (access(f, F_OK) != -1) {
    return 1;
  } else {
    return 0;
  }
}

void remove_file_c(char* f) {
  int res = remove(f);
  return;
}
%}

implement
file_exists(f) = if file_exists_aux(f) = 1 then true else false

(* ****** ****** *)

(* end of [file_base.dats] *)
