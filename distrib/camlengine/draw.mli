(*
    $Id$

    Copyright (C) 2003-4 Richard Bornat & Bernard Sufrin
     
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

type text = Text.text
and textlayout = Text.textlayout
and textalign = Text.textalign
and textsize = Box.textsize
and pos = Box.pos
and size = Box.size
and box = Box.box
and textbox = Box.textbox
and font = Text.font
and displayclass = Displayclass.displayclass
and element = Termtype.element
and term = Termtype.term
and reason = Absprooftree.reason

type 'a plan = Formulaplan of (textlayout * textbox * 'a)

val measuretext : textalign -> text -> textsize * textlayout

val drawinproofpane : unit -> unit

val drawLine : pos -> pos -> unit
val drawBox  : box -> unit

val clearView : unit -> unit
val viewBox   : unit -> box
val highlight : pos -> displayclass option -> unit
val greyen : pos -> unit
val blacken : pos -> unit
val fontinfo : font -> int * int * int (* ascent, descent, leading *)
val linethickness : int -> int (* font leading to linethickness *)
   
val setproofparams : Japeserver.displaystyle -> int -> unit (* Tree/BoxStyle, line thickness *)
   
val debugstring_of_plan : ('a -> string) -> 'a plan -> string 
val string_of_plan  : 'a plan -> string (* for external viewing; only works for single-string plans *)
   
val plantextlayout : 'a plan -> textlayout
val plantextbox : 'a plan -> textbox
val planinfo : 'a plan -> 'a
val textsize_of_plan : 'a plan -> textsize
val textsize_of_planlist : 'a plan list -> textsize
val textinfo_of_text : text -> textsize * textlayout
val textinfo_of_string : font -> string -> textsize * textlayout
val textinfo_of_term : (term -> string) -> term -> textsize * textlayout
val textinfo_of_element : (element -> string) -> element -> textsize * textlayout
val textinfo_of_reason : reason -> textsize * textlayout
val textinfo_procrustes : int -> pos -> textsize * textlayout -> textsize * textlayout
val plan_of_textinfo : textsize * textlayout -> 'a -> pos -> 'a plan
val plan_of_string : font -> string -> 'a -> pos -> 'a plan
val plan_of_element : (element -> string) -> element -> 'a -> pos -> 'a plan

(* for building element lists and the like, with commas in between *)
val plancons : 'a plan -> (pos -> 'a plan list * textbox) -> 'a plan list * textbox
val plans_of_plan : 'a plan -> 'a plan list * textbox

(* plan modifier *)
val planOffset : 'a plan -> pos -> 'a plan
val plans_of_things :
  ('b -> pos -> 'a plan) -> (pos -> 'a plan) ->
    (pos -> 'a plan list * textbox) -> 'b list -> pos ->
    'a plan list * textbox

val drawplan : ('a -> displayclass) -> pos -> 'a plan -> unit
val findfirstplanhit : pos -> 'a plan list -> 'a plan option

val string_of_textinfo : textsize * textlayout -> string
