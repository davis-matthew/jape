(*
	$Id$

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

open Sml

let bracketedliststring = Listfuns.bracketedliststring
let consolereport = Miscellaneous.consolereport

(* this is the Unix version ... Linux and MacOS X ok; 
   Windoze needs '\\' so we stay in the world of unix filenames 
   and normalize filenames according to OS just before opening
*)

(* It's not good enough ... we ought to parse the strings. RB 3/i/2002 *)

let usestack = ref (if Sys.os_type="Win32" then [] else ["./"])

let isabsolute path =
if Sys.os_type="Win32" then (
  try
	String.index path ':'  < String.index path '\\'
  with
	Not_found -> false)
else (try String.sub path 0 1 = "/" with _ -> false)

let makerelative s =
  if isabsolute s then s else
  match !usestack with
  | []     -> s
  | top::_ -> top ^ s

let rec startusing path =
  usestack := Moresys.pathStem path :: !usestack

exception Matchinstopusing (* spurious *)

let rec stopusing () =
  match !usestack with
    [path] -> ()
  | path :: paths -> usestack := paths
  | _ -> raise Matchinstopusing


