(* ****** ****** *)
//
// LG 2018-04-03
//
(* ****** ****** *)

datasort stype = psend of (vt@ype) | precv of (vt@ype) | pclose | pwait | pseq of (stype, stype)
absvtype channel (int, stype)

stadef :: = pseq

(* ****** ****** *)

extern
fun
request
{r: int}{s:stype}
(string): channel(r, s) = "mac#"

extern
fun
accept
{r: int}{s:stype}
(string): channel(r, s) = "mac#"

(* ****** ****** *)

%{
socket_t request (addr a) {
  socket_t x = create_socket();
  connect(x, a);
  return x;
}

socket_t accept (addr a) {
  socket_t x = create_socket();
  bind(x, a);
  accept(x);
  return x;
}

void send (socket_t x, char* data) {
  int len = strlen(data);
  socket_sent(x, len, 4);
  socket_send(x, data, len*4);
}
%}


(* ****** ****** *)

(* end of [communication.dats] *)