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

open Answer
open Context.Type
open Context.ExteriorFuns
open Context.Cxt
open Facts
open Idclass
open Listfuns
open Mappingfuns
open Match
open Miscellaneous
open Optionfuns
open Provisotype (* ok, of course. RB *)
open Proviso
open Rewrite.Funs
open Sequent.Type
open Sml
open Stringfuns
open Substmapfuns
open Term.Funs
open Term.Store
open Term.Termstring
open Term.Type

let baseseqsides cxt =
  match getexterior cxt with
	Exterior((_,Seq(_,left,right)),_,fvi) -> 
	  (left,right,
	   (match fvi with Some(_,_,_,bhfvs,bcfvs) -> Some(bhfvs,bcfvs)
		| None                                 -> None
	   )
	  )
  | NoExterior -> raise (Catastrophe_ ["baseseqsides"])
   
let vv = bracketedliststring visprovisostring " AND "
(* just turn a proviso into a list of simpler provisos 
   (function designed for folding over proviso list) 
 *)
(* oh, and by the way, uncurried constructors and fold in SML are a PAIN. RB *)
let rec simplifyProviso facts (p, cats) =
  let parent = provisoparent p in
  let vis = provisovisible p in
  let rec new__ p' = mkparentedvisproviso parent (vis, p') in
  let rec np v (t, cats) =
	let rec addone p' ps = new__ p' :: ps in
	let rec def () = Some (addone (NotinProviso (v, t)) cats) in
	let rec fnp (t, cats) = foldterm (np v) cats t in
	match t with
	  Id _ -> def ()
	| Unknown _ -> def ()
	| Binding (_, (bs, ss, us), _, _) ->
		let rs = (substeqvarsq facts v <* bs) in
		if List.exists qDEF rs then Some (nj_fold fnp us cats)
		else if not (List.exists qUNSURE rs) then
		  Some (nj_fold fnp ss (nj_fold fnp us cats))
		else def ()
	| Subst (_, r, _P, vts) ->
		let rs = (substeqvarsq facts v <* (fst <* vts)) in
		if List.exists qDEF rs then
		  Some (nj_fold fnp ((snd <* vts)) cats)
		else if not (List.exists qUNSURE rs) then
		  match vts with
			[v', t'] ->
			  begin match varoccursinq facts v t' with
				Yes -> Some (foldterm (np v') (fnp (_P, cats)) _P)
			  | No -> Some (fnp (_P, cats))
			  | Maybe -> def ()
			  end
		  | _ ->
			  Some
				(nj_fold fnp
				   ((fun vt -> registerSubst (true, _P, [vt])) <* vts)
				   cats)
		else def ()
	| Collection (_, c, es) ->
		let rec npe (e, cats) =
		  match e with
			Segvar (_, _, v') ->
			  addone (NotinProviso (v, registerCollection (c, [e]))) cats
		  | Element (_, _, t) -> fnp (t, cats)
		in
		Some (nj_fold npe es cats)
	| _ -> None
  in
  let rec nop =
	fun (vs, pat, _C as n) ->
	  let rec expand env (v, cats) =
		match at (env, v) with
		  Some v' ->
			simplifyProviso facts (new__ (NotinProviso (v, v')), cats)
		| None -> raise (Catastrophe_ ["simplifyProviso nop"])
	  in
	  let rec simp t cats =
		match match3 false pat t (Certain empty) with
		  Some (Certain env) -> Some (nj_fold (expand env) vs cats)
		| Some (Uncertain env) -> None
		| None -> Some cats
	  in
	  match _C with
		Collection (_, class__, es) ->
		  let rec doel (e, (defers, cats)) =
			match e with
			  Element (_, _, t) ->
				begin match simp t cats with
				  Some cats' -> defers, cats'
				| None -> e :: defers, cats
				end
			| _ -> e :: defers, cats
		  in
		  let (defers, cats') = nj_fold doel es ([], cats) in
		  if null defers then cats'
		  else
			new__
			  (NotoneofProviso
				 (vs, pat, registerCollection (class__, defers))) ::
			  cats'
	  | t ->
		  match simp t cats with
			Some cats' -> cats'
		  | _ -> new__ (NotoneofProviso n) :: cats
  in
  match provisoactual p with
	NotinProviso (v, t) -> foldterm (np v) cats t
  | NotoneofProviso n -> nop n
  | _ -> p :: cats
let rec deferrable cxt (t1, t2) =
  simterms (t1, t2) &&
  (match t1, t2 with
	 Subst _, Subst _ -> true
   | Subst (_, _, (Unknown _ as _P1), vts), _ ->
	   not (qDEF (varoccursinq cxt _P1 t2)) ||
	   specialisesto (idclass _P1, VariableClass) &&
	   List.exists (fun t1' -> deferrable cxt (t1', t2))
		 ((snd <* vts))
   | _, Subst _ -> deferrable cxt (t2, t1)
   | _ -> true)
(* Is this proviso obviously satisfied (Yes) or obviously violated (No)
 * or can't we tell (Maybe)?
 * Make use of other, more basic, provisos as facts to help you decide, 
 * where appropriate - but be sure that you don't eliminate two mutually 
 * equivalent provisos (e.g. at this point don't use NOTINs to remove other NOTINs).
 *)
let rec _PROVISOq facts p =
  match p with
	FreshProviso _ ->(* can occur in a derived rule *)  Maybe
  | NotinProviso (v, t) -> notq (varoccursinq facts v t)
  | NotoneofProviso _ -> Maybe
  | UnifiesProviso (_P1, _P2) ->
	  if eqterms (_P1, _P2) then Yes
	  else if not (deferrable facts (_P1, _P2)) then No
	  else(* if termoccursin (debracket _P2) _P1 
		 orelse termoccursin (debracket _P1) _P2 then No
	  else *)  Maybe
(* the list of names must be sorted, which it will be if it comes out of termvars *)
(* because of hidden provisos, this thing now gets a visproviso list *)
(* iso means isolated, I think; so isot is an isolated term, isop an isolated proviso *)
let rec groundedprovisos names provisos =
  let rec isot t =
	let vs = ismetav <| termvars t in
	let rec diff a1 a2 =
	  match a1, a2 with
		x :: xs, y :: ys ->
		  earliervar x y && diff xs (y :: ys) ||
		  earliervar y x && diff (x :: xs) ys
	  | _, _ -> true
	in
	let r = diff vs names in
	if !provisodebug then
	  consolereport
		["isot checking "; termstring t; " against ";
		 termliststring names; " => "; string_of_bool r];
	r
  in
  let rec isop p =
	let r =
	  match p with
		FreshProviso (_, _, _, v) -> ismetav v && isot v
	  | NotinProviso (v, t) -> ismetav v && isot v || isot t
	  | NotoneofProviso (vs, pat, _C) ->
		  not (List.exists (not <*> isot) vs) || isot _C
	  | UnifiesProviso (_P1, _P2) -> isot _P1 && isot _P2
	in
	if !provisodebug then
	  consolereport
		["isop checking "; provisostring p; " => "; string_of_bool r];
	r
  in
  let r =
	if null provisos then None
	else
	  (* keep them? throw them away? *) match split (isop <*> provisoactual) provisos with
		[], _ -> None
	  | _, [] ->(* we kept them all *)
		 Some []
	  | isos, uses ->
		  (* we threw them all away *)
		  match
			groundedprovisos
			  (nj_fold (uncurry2 tmerge)
					   ((provisovars termvars tmerge <*> provisoactual) <* uses)
					   names)
			  isos
		  with
			Some more -> Some (uses @ more)
		  | None ->(* we kept some *)
			 None
  in
  if !provisodebug then
	consolereport
	  ["groundedprovisos "; termliststring names; " ";
	   bracketedliststring visprovisostring " AND " provisos; " => ";
	   optionstring vv r];
  r
let rec expandFreshProviso b (h, g, r, v) left right ps =
  nj_fold
	(function
	   (true, side), ps -> mkvisproviso (b, NotinProviso (v, side)) :: ps
	 | (false, side), ps -> ps)
	[h, left; g, right] ps
exception Verifyproviso_ of proviso

(* take out the first occurrence *)
let rec ( -- ) =
  function
	x :: xs, y -> if x = y then xs else x :: ( -- ) (xs, y)
  | [], y -> []
(* We find out which provisos from the set ps are independent of the set qs.
 * If op-- is the function above, p is deleted from the set qs before we start,
 * but there are other things we might want to do ...
 *)
let rec checker cxt ( -- ) ps qs =
  let rec ch a1 a2 =
	match a1, a2 with
	  [], qs -> []
	| p :: ps, qs ->
		let pp = provisoactual p in
		let qs' = ( -- ) (qs, p) in
		if List.exists (fun p' -> pp = provisoactual p') qs' then ch ps qs'
		else
		  match _PROVISOq (facts qs' cxt) pp with
			Yes -> ch ps qs'
		  | No -> raise (Verifyproviso_ (provisoparent p))
		  | Maybe -> p :: ch ps qs
  in
  ch ps qs
(* The correct interpretation of a FRESH proviso is given by expandFreshProviso above.  
 * But elsewhere -- see exterioreqvarsq -- I have taken FRESH to mean: doesn't appear 
 * free in the base sequent.  That second interpretation applies when proving theorems:
 * it's over-enthusiastic (too restrictive), but mixing them won't do: it causes us to
 * often have to add extra, strictly necessary, provisos to bolster FRESH.  Using the 
 * restrictive version includes those extra provisos all the time. 
 *
 * So now I use the restrictive version in verifyprovisos.
 * RB 20/i/00
 *)

let rec verifyprovisos cxt =
  try
	let cxt = rewritecxt cxt in
	let (left, right, fvopt) = baseseqsides cxt in
	let rec efp (h, g, r, v as f) =
	  match fvopt with
		Some (bhfvs, bcfvs) ->
		  let rec notins a1 a2 a3 =
			match a1, a2, a3 with
			  true, fvs, ps ->
				nj_fold
				  (fun (fv, ps) ->
					 mkvisproviso (true, NotinProviso (v, fv)) :: ps)
				  fvs ps
			| false, _, ps -> ps
		  in
		  notins h bhfvs (notins g bcfvs [])
	  | None -> expandFreshProviso true f left right []
	in
	(* the checker function above is wierd.  But it checks the list of provisos
	 * left-to-right, eliminating the ones that are a consequence of what is left,
	 * so we want the _visible_ provisos first
	 *)
	let (vis, invis) = split provisovisible (provisos cxt) in
	(* FreshProvisos are never invisible, I hope, so I just look at vis *)
	let (fresh, unfresh) =
	  nj_fold
		(fun (p, (fs, us)) ->
		   match provisoactual p with
			 FreshProviso f -> let ns = efp f in (f, ns) :: fs, ns @ us
		   | _ -> fs, p :: us)
		vis ([], [])
	in
	let pros =
	  let ps = unfresh @ invis in
	  let simpleps = nj_fold (simplifyProviso (facts ps cxt)) ps [] in
	  let _ =
		if !provisodebug then consolereport ["simpleps = "; vv simpleps]
	  in
	  checker cxt ( -- ) simpleps simpleps
	in
	(* FreshProviso now interacts with other provisos in a number of ways.
	 * If we have FRESH/IMPFRESH z, but z doesn't appear in the base sequent or the givens,
	 * then we can replace it by just the provisos which derive from it.
	 * If after that we still have FRESH z, then we can strip out all the provisos which 
	 * derive from it.
	 * If we still have IMPFRESH z, and we have all the provisos which derive from
	 * it, then we can strip them out and use FRESH z.
	 * If we already have a FRESH/IMPFRESH proviso then we can augment it to allow this one
	 *)
	let ps =
	  let rec dofresh (((h, g, r, v as f), ns), pros) =
		let news = nj_fold (simplifyProviso (facts (pros @ ns) cxt)) ns [] in
		let rec mm (xs, y) = xs in
		let rec def () = checker cxt mm pros news in
		let rec push f ps =
		  if List.exists
			   (
				  (function
					 FreshProviso (_, _, _, v') -> v = v'
				   | _ -> false) <*> provisoactual)
			   ps
		  then
			  ((fun vp ->
				  match provisoactual vp with
					FreshProviso (h', g', r', v') ->
					  if v = v' then
						mkvisproviso
						  (true,
						   FreshProviso (h || h', g || g', r && r', v))
					  else vp
				  | _ -> vp) <*
			   ps)
		  else mkvisproviso (true, FreshProviso f) :: ps
		in
		if knownproofvar (facts pros cxt) v then def ()
		else if(* no need for it at all *)
		 r then
		  (* IMPFRESH - check if news are needed *)
		  let news' =
			try checker cxt mm news pros with
			  Verifyproviso_ _ -> news
		  in
		  if null news' then(* we have the lot: just say FRESH *)
		   push (h, g, false, v) (def ())
		  else(* something missing: use IMPFRESH *)
		   push f pros
		else(* FRESH *)
							   (* take out copies of the new ones *)
		 push f (def ())
	  in
	  nj_fold dofresh fresh pros
	in
	if !provisodebug then
	  consolereport
		["verifyprovisos "; vv (provisos cxt); " (pros = "; vv pros; ") ";
		 " (vis = "; vv vis; ") "; " (invis = "; vv invis; ") ";
		 " (fresh = ";
		 bracketedliststring
		   (fun (f, ns) ->
			  pairstring provisostring vv "," (FreshProviso f, ns))
		   "," fresh;
		 ") "; " (unfresh = "; vv unfresh; ") "; " => "; vv ps];
	rewritecxt (withprovisos cxt ps)
  with
	Verifyproviso_ p ->
	  if !provisodebug then
		consolereport
		  ["proviso "; provisostring p; " failed in verifyprovisos"];
	  raise (Verifyproviso_ p)
let rec checkprovisos cxt =
  try Some (verifyprovisos cxt) with
	Verifyproviso_ _ -> None
(* this is for renaming provisos when a rule/theorem is instantiated *)
let rec remapproviso env p =
  let _T = remapterm env in
  match p with
	FreshProviso (h, g, r, v) -> FreshProviso (h, g, r, _T v)
  | NotinProviso (v, t) -> NotinProviso (_T v, _T t)
  | NotoneofProviso (vs, pat, _C) ->
	  NotoneofProviso ((_T <* vs), _T pat, _T _C)
  | UnifiesProviso (_P1, _P2) -> UnifiesProviso (_T _P1, _T _P2)
(* the drag and drop mapping is a list of (source,target) pairs, derived from
 * UnifiesProvisos thus:
 * if we have to unify two bag collections, either of which includes an unknown 
 * bag variable, then each such variable is a target and each of the formulae on 
 * the other side of the proviso is a source for that target.
 *)

(* and currently it is a dead duck.  RB 30/vii/01
fun draganddropmapping ps =
  let fun istarget (Segvar(_,_,Unknown _)) = true
	  |   istarget _                       = false
	  fun getsts (UnifiesProviso(Collection(_,BagClass FormulaClass, xs),
								 Collection(_,BagClass FormulaClass, ys)
								),
				  rs
				 ) = (xs,istarget<|ys)::(ys,istarget<|xs)::rs
	  |   getsts (_,rs) = rs
	  val sts = (not o null o #2) <| nj_fold getsts ps []
	  (* We need to run Warshall's algorithm to get the transitive closure.
	   * This implementation is slow, but these collections don't get large 
	   *)
	  val ists = (not o null o #1) <| ((fn (xs,ys) => (istarget<|xs,ys)) <* sts)
	  val ists = nj_fold (fn ((ss,ts),rs) => nj_fold (fn (s,rs) => (s,ts)::rs) ss rs) ists []
	  val sts = nj_fold (fn ((s,ts),sts) => 
						 (fn (ss',ts') => 
							 (ss',if List.exists (fn t' => s=t') ts' then ts'@ts else ts')
						 ) <* sts
					 ) ists sts
  in 
	  nj_fold (fn ((ss,ts),rs) => (ss><ts)@rs) sts []
  end
*)
 
(* for export *)
let deferrable cxt = deferrable (facts (provisos cxt) cxt)
