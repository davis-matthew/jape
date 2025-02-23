(*
    Copyright (C) 2003-19 Richard Bornat & Bernard Sufrin
     
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

open Cxttype
open Sequent
open Forcedef
open Japeenv
open Name
open Paraparam
open Proofstage
open Proofstate
open Proviso
open Tactictype


val proofsdone : bool ref
val mkstate : visproviso list -> seq list -> prooftree -> bool -> proofstate
val startstate : japeenv -> visproviso list -> seq list -> seq -> proofstate
val addproof   : (string list -> unit) ->
                 (string list * string * string * int -> bool) -> 
                 name -> bool -> proofstate -> bool -> (seq * model) option -> 
                 bool
val doProof :
  (string list -> unit) ->
  (string list * string * string * int -> bool) -> japeenv -> name ->
  proofstage -> seq -> paraparam list * seq list * proviso list * tactic ->
  (seq * model) option ->
    (name * proofstate * (seq * model) option) option

val runprooftracing : bool ref
