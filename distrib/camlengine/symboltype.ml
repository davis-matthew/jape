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

type idclass = Idclass.idclass 

type associativity =
  LeftAssoc | RightAssoc | AssocAssoc | TupleAssoc | CommAssocAssoc

type symbol =
	ID of (string * idclass option)
  | UNKNOWN of (string * idclass option)
  | NUM of string
  | STRING of string
  | BRA of string
  | SEP of string
  | KET of string
  | SUBSTBRA
  | SUBSTKET
  | SUBSTSEP
  | EOF
  | PREFIX of (int * string)
  | POSTFIX of (int * string)
  | INFIX of (int * associativity * string)
  | INFIXC of (int * associativity * string)
  | LEFTFIX of (int * string)
  | MIDFIX of (int * string)
  | RIGHTFIX of (int * string)
  | STILE of string
  | SHYID of string
