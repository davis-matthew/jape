(*
	$Id$

    Copyright (C) 2003 Richard Bornat & Bernard Sufrin
     
        richard@bornat.me.uk
        sufrin@comlab.ox.ac.uk

    This file is part of the jape proof engine, which is part of jape.

    Jape is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Jape is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with jape; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
    (or look at http://www.gnu.org).

*)

val atoi : string -> int
exception AtoI_
val error : string list -> 'a
exception Error_
val observe : string list -> unit
val sum : int list -> int
val charpred : string -> (string -> bool) * (string * bool -> unit)
val isdigit : string -> bool
val islcletter : string -> bool
val isletter : string -> bool
val isucletter : string -> bool
val iter : (int -> 'a) -> int * int -> unit
val curry2 : ('a * 'b -> 'c) -> 'a -> 'b -> 'c
val uncurry2 : ('a -> 'b -> 'c) -> 'a * 'b -> 'c
val create_reportfile : string -> unit
val close_reportfile : unit -> unit
val consolereport : string list -> unit
val consolequery : string list * string * string * int -> bool
val refstring : ('a -> string) -> 'a ref -> string
val earlierpair :
  ('a -> 'a -> bool) -> ('b -> 'b -> bool) -> ('a * 'b) -> ('a * 'b) -> bool
val onbra : char
val onket : char
val offbra : char
val offket : char
val outbra : char
val outket : char
val lockbra : char
val lockket : char
val invisible : string -> bool

(* whether to add context automatically to rule definitions *)
val autoAdditiveLeft  : bool ref
val autoAdditiveRight : bool ref
    
val lemmacount : int ref           (* number of lemmas during THIS proof *)
val applyconjectures : bool ref    (* conjectures allowed in proofs *)
val applyderivedrules : bool ref   (* derived rules allowed in proofs *)
val autoselect : bool ref          (* show 'goal' when printing proofs *)
val givenMenuTactic : string ref   (* what to use when the interface says applygiven *)
val foldformulae : bool ref        (* whether to fold long lines in boxdraw *)
val truncatereasons : bool ref     (* whether to shorten reasons in boxdraw *)
val seektipselection : bool ref    (* look for a tip to work on in boxdraw *)
val textselectionmode : string ref (* how to press-and-drag over text *)

val screenpositiondebug : bool ref
exception Catastrophe_ of string list
exception ParseError_ of string list
exception Tacastrophe_ of string list

