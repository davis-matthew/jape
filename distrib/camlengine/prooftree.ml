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

module type Access =
  sig
    type fmt and path and prooftree
     and seq and rewinf and element and name
    val followPath : prooftree -> path -> prooftree
    val onestep : prooftree -> path -> (path * prooftree) option
    val pathPrefix : prooftree -> path -> path -> bool
    val findTip : prooftree -> path -> seq
    val getTip : prooftree -> path -> seq * rewinf * fmt
    val allTipPaths : prooftree -> path list
    val allTipConcs : prooftree -> (path * element list) list
    val validelement : bool -> prooftree -> element -> path -> bool
    val validhyp : prooftree -> element -> path -> bool
    val validconc : prooftree -> element -> path -> bool
    val stillopen : prooftree -> path -> bool
    val maxtreeresnum : prooftree -> int
    val isTip : prooftree -> bool
    val hasTip : prooftree -> bool
    val rootPath : prooftree -> path
    val parentPath : prooftree -> path -> path
    val siblingPath : prooftree -> path -> bool -> path
    (* true gives left, false gives right *)
    val subgoalPath : prooftree -> path -> int list -> path
    val reason : (name -> bool) -> prooftree -> string option
    val subtrees : prooftree -> prooftree list
    val sequent : prooftree -> seq
    val rule : prooftree -> name option
    val thinned : prooftree -> element list * element list
    val format : prooftree -> fmt
    val depends : prooftree -> name list
    val findAnyGoal : prooftree -> path option
    val findRightwardsGoal : bool -> prooftree -> path -> path option
    val fmtstring : fmt -> string
    val pathstring : path -> string
    val prooftreestring : prooftree -> string
  end

module type Tree =
  sig
    type term and seq and vid and element and name
    and 'a prooftree and treeformat and fmtpath and visformat
    and vispath and cxt and thing and proviso and rewinf
    
    type prooftree_step =
        Apply of (name * term list * bool)
      | Given of (string * int * bool)
      | UnRule of (string * name list)
    (* step name, rule dependencies *)

    val prooftree_stepstring : prooftree_step -> string
    val step_label : prooftree_step -> string
    val step_resolve : prooftree_step -> bool
    val mkTip : cxt -> seq -> treeformat -> treeformat prooftree
    val mkJoin :
      cxt -> string -> prooftree_step -> term list -> treeformat -> seq ->
        treeformat prooftree list -> element list * element list ->
        treeformat prooftree
    val get_prooftree_fmt : treeformat prooftree -> fmtpath -> treeformat
    val set_prooftree_fmt :
      treeformat prooftree -> fmtpath -> treeformat -> treeformat prooftree
    val get_prooftree_cutnav :
      treeformat prooftree -> fmtpath -> (int * int) option
    val set_prooftree_cutnav :
      treeformat prooftree -> fmtpath -> (int * int) option ->
        treeformat prooftree
    val rewriteProoftree :
      seq list -> bool -> cxt -> treeformat prooftree ->
        cxt * treeformat prooftree * vid list
    val insertprooftree :
      cxt -> fmtpath -> treeformat prooftree -> treeformat prooftree ->
        fmtpath * treeformat prooftree
    val truncateprooftree :
      cxt -> fmtpath -> treeformat prooftree -> fmtpath * treeformat prooftree
    val replaceTip :
      cxt -> fmtpath -> treeformat prooftree -> seq -> treeformat prooftree
    val makewhole :
      cxt -> (treeformat prooftree * fmtpath) option ->
        treeformat prooftree -> fmtpath -> fmtpath * treeformat prooftree
    val augmenthyps :
      cxt -> treeformat prooftree -> element list -> treeformat prooftree
    val deepest_samehyps : treeformat prooftree -> fmtpath -> fmtpath
    val isCutStep : treeformat prooftree -> fmtpath -> bool
    val catelim_prooftree2tactic :
      treeformat prooftree -> proviso list -> seq list -> string list ->
        string list
    val visproof :
      (name -> bool) -> bool -> bool -> treeformat prooftree ->
        visformat prooftree
    (* showallsteps    proved          hideuselesscuts *)
    val visible_subtrees : bool -> treeformat prooftree -> treeformat prooftree list option
                        (* showallsteps *)
    
    val pathtoviewpath : bool -> treeformat prooftree -> fmtpath -> vispath option
                      (* showallsteps *)
    val viewpathtopath : bool -> treeformat prooftree -> vispath -> fmtpath option
                      (* showallsteps *)

    module Fmttree : Access
                     with type fmt = treeformat and type seq = seq and type name = name
                      and type prooftree = treeformat prooftree
                      and type path = fmtpath and type element = element
                      and type rewinf = rewinf
    module Vistree : Access
                     with type fmt = visformat and type seq = seq and type name = name
                      and type prooftree = visformat prooftree
                      and type path = vispath and type element = element
                      and type rewinf = rewinf
    
    val foldedfmt : string ref (* LAYOUT "" ()    *)
    val filteredfmt : string ref (* LAYOUT "" (...) *)
    val unfilteredfmt : string ref (* LAYOUT ""       *)
    val rawfmt : string ref
    (* when named layouts are exhausted by doubleclicking *)
       
    val showallproofsteps : bool ref
    val hideuselesscuts : bool ref
    val prooftreedebug : bool ref
    val prooftreedebugheavy : bool ref
    val prooftreerewinfdebug : bool ref
    val cuthidingdebug : bool ref
    exception FollowPath_ of (string * int list)
    exception FindTip_
    exception AlterProof_ of string list
    val reasonstyle : string ref
  end


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

module Tree : Tree with type term = Term.Type.term
					and type seq = Sequent.Type.seq
					and type vid = Term.Type.vid
					and type element = Term.Type.element
					and type name = Name.name
					and type treeformat = Treeformat.Fmt.treeformat
					and type fmtpath = Treeformat.Fmt.fmtpath
					and type visformat = Treeformat.VisFmt.visformat
					and type vispath = Treeformat.VisFmt.vispath
					and type cxt = Context.Cxt.cxt
					and type thing = Thing.thing
					and type proviso = Proviso.proviso
					and type rewinf = Rewinf.rewinf
=
  struct
    open Context.Cxt
    open Context.Cxtstring
    open Context.ExteriorFuns
    open Idclass
    open Listfuns
    open Mappingfuns
    open Miscellaneous
    open Name
    open Optionfuns
    open Proviso
    open Provisofuns
    open Rewinf
    open Rewrite.Funs
    open Rewrite.Rew
    open Sequent.Funs
    open Sequent.Type
    open Sml
    open Stringfuns
    open Tactictype
    open Tactic
    open Term.Funs
    open Term.Store
    open Term.Termstring
    open Term.Type
    open Thing
    open Treeformat.Fmt
    open Treeformat.VisFmt
    open Treelayout

    type term = Term.Type.term
     and seq = Sequent.Type.seq
     and vid = Term.Type.vid
     and element = Term.Type.element
     and name = Name.name
     and treeformat = Treeformat.Fmt.treeformat
     and fmtpath = Treeformat.Fmt.fmtpath
     and visformat = Treeformat.VisFmt.visformat
     and vispath = Treeformat.VisFmt.vispath
     and cxt = Context.Cxt.cxt
     and thing = Thing.thing
     and proviso = Proviso.proviso
     and rewinf = Rewinf.rewinf
    
    (* -------------------------------------------------------------------------------- *)
              
    let prooftreedebug = ref false
    let prooftreedebugheavy = ref false
    (* these two affect the translation of proof -> visproof and also path -> vispath.
     * That makes it tricky to deal with the translation of old paths (see displaystyle.sml).
     * As we say: bugger.
     *)
    let showallproofsteps = ref false
    let hideuselesscuts = ref false
    let cuthidingdebug = ref false
    let foldedfmt = ref "{%s}"
    (* LAYOUT "" ()    *)
    and filteredfmt = ref "%s"
    (* LAYOUT "" (...) *)
    and unfilteredfmt = ref "%s"
    (* LAYOUT ""       *)
    and rawfmt = ref "[%s]"
    (* when named layouts are exhausted by doubleclicking *)
       
    type prooftree_step =
        Apply of (name * term list * bool)
      | Given of (string * int * bool)
      | UnRule of (string * name list)
    (* step name, rule dependencies *)

(* the 'hastipval' optimisation, added to stop exponential behaviour when traversing the tree, 
* may or may not be an optimisation ...
*)
    type 'a prooftree =
        Tip of (seq * rewinf * 'a)
      | Join of
          (string * prooftree_step * (int * int) option *
             (term list * rewinf) * 'a * bool * (seq * rewinf) *
             ('a prooftree list * rewinf) *
             ((element list * element list) * rewinf))
    (* resources consumed - elements that 
       matched hypotheses and conclusions
       when the rule was applied.  This information is 
       essential for the boxdraw display module; it 
       isn't possible to get it from the rule and its 
       arguments
     *) 

(* some functions to extract things from trees, because otherwise I get confused. RB *)

    let rec join_why
      (why, how, cutnav, args, fmt, hastipval, seq, trs, ress) =
      why
    let rec join_how
      (why, how, cutnav, args, fmt, hastipval, seq, trs, ress) =
      how
    let rec join_cutnav
      (why, how, cutnav, args, fmt, hastipval, seq, trs, ress) =
      cutnav
    let rec join_args
      (why, how, cutnav, (args, rewinf), fmt, hastipval, seq, trs, ress) =
      args
    let rec join_fmt
      (why, how, cutnav, args, fmt, hastipval, seq, trs, ress) =
      fmt
    let rec join_hastip
      (why, how, cutnav, args, fmt, hastipval, seq, trs, ress) =
      hastipval
    let rec join_seq
      (why, how, cutnav, args, fmt, hastipval, (seq, rewinf), trs, ress) =
      seq
    let rec join_subtrees
      (why, how, cutnav, args, fmt, hastipval, seq, (trs, rewinf), ress) =
      trs
    let rec join_subtrees_rewinf
      (why, how, cutnav, args, fmt, hastipval, seq, (trs, rewinf), ress) =
      rewinf
    let rec join_thinned
      (why, how, cutnav, args, fmt, hastipval, seq, trs, (ress, rewinf)) =
      ress
    
    let rec withsubtrees
      ((why, how, cutnav, args, fmt, hastipval, seq, _, ress), ts) =
      why, how, cutnav, args, fmt, hastipval, seq, ts, ress
    let rec withhastipval
      ((why, how, cutnav, args, fmt, _, seq, trs, ress), hastipval) =
      why, how, cutnav, args, fmt, hastipval, seq, trs, ress
    let rec withfmt
      ((why, how, cutnav, args, _, hastipval, seq, trs, ress), fmt) =
      why, how, cutnav, args, fmt, hastipval, seq, trs, ress
    let rec step_label =
      function
        Apply (n, _, _) -> parseablenamestring n
      | Given (s, _, _) -> s
      | UnRule (s, _) -> s
    let rec step_resolve =
      function
        Apply (_, _, b) -> b
      | Given (_, _, b) -> b
      | _ -> false
    let rec rewinfProoftree =
      function
        Tip (seq, rewinf, fmt) -> rewinf
      | Join (why, how, cutnav, args, fmt, hastipval, seq, trs, ress) ->
          rewinf_merge
            (snd args,
             rewinf_merge
               (snd seq,
                rewinf_merge (snd trs, snd ress)))
    let rec tip_seq (seq, rewinf, hastipval) = seq
    let rec joinopt a1 a2 =
      match a1, a2 with
        f, Tip _ -> None
      | f, Join j -> Some (f j)
    let rec rule =
      function
        Tip _ -> None
      | Join j ->
          match join_how j with
            Apply (r, _, _) -> Some r
          | _ -> None
    let rec thinned =
      function
        Join j -> join_thinned j
      | _ -> [], []
    let rec isTip =
      function
        Tip _ -> true
      | _ -> false
    let rec hasTip =
      function
        Tip _ -> true
      | Join j -> join_hastip j
    let rec tshaveTip ts =
      nj_fold (fun (a, b) -> a || b) ((hasTip <* ts)) false
    let rec subtrees =
      function
        Tip _ -> []
      | Join j -> join_subtrees j
    let rec sequent =
      function
        Tip t -> tip_seq t
      | Join j -> join_seq j
    let rec format =
      function
        Tip (_, _, fmt) -> fmt
      | Join j -> join_fmt j
    let rec depends tree =
      let rec d =
        function
          Tip _, ds -> ds
        | Join j, ds ->
            let rest = nj_fold d (join_subtrees j) ds in
            match join_how j with
              UnRule (_, ss) -> ss @ rest
            | Apply (n, _, _) -> n :: rest
            | Given _ -> rest
      in
      sortunique nameorder (nj_fold d [tree] [])
    (* -------------------------- navigation with int lists -------------------------- *)
        
    exception FollowPath_ of (string * int list) exception FindTip_
    (* A new means of addressing the tree, to serve the needs of the CUTIN tactic, which
     * inserts cuts low down in a tree.
     *
     * A cut inserted into a tree produces two new nodes, and wrecks all paths to nodes
     * above it, if we use the old nth-subtree way of describing a path. But it is essential
     * that old paths continue to work -- think of goals, targets, paths stored by
     * LETGOALPATH, and maybe other things as well -- so we can't use that old navigation system.
     *
     * Luckily a cut introduces exactly two unique elements into a proof: the conclusion element
     * and the hypothesis element. They can be used to label the two new nodes uniquely. If
     * we include them in paths, they have to be negative numbers.  I rely on the fact that 
     * resources are never zero, so that addresses of the two new nodes are just negative numbers.
     *
     * Then there is a choice: which are the two new nodes?  The apparently obvious choice is
     * to label the left subtree with the conclusion resource, the right with the hypothesis
     * resource.  But that doesn't work, because if we do a CUTIN at a tip, having recorded
     * the path to the tip for some reason, the old path would lead to the root of the internal
     * cut, not the reconstructed tip.  So the conclusion resource labels the left subtree, 
     * and the hypothesis resource labels the cut node itself.  Odd, but (given considerable 
     * ingenuity in the design of algorithms) it works.  Drawback: it makes comparison of paths
     * (e.g. by looking at prefixes) almost impossible.  Sorry.
     * 
     * To make old paths work, we skip to the right subtree if we are addressing
     * an inner cut node with a path that doesn't start with the right or left subtree label.
     *
     * RB 19/i/00
     *)
     
    type 'a navkind =
        NormalNav of 'a prooftree list
      | CutNav of (int * int * 'a prooftree * 'a prooftree)
    let rec decode_cutnav j =
      match j with
        why, how, Some (l, r), args, fmt, hastipval, seq, ([tl; tr], rewinf),
        ress ->
          CutNav (l, r, tl, tr)
      | why, how, _, args, fmt, hastipval, seq, (ts, rewinf), ress ->
          NormalNav ts
    (* I've tried to make this fast *)
    let rec joinstep go stop skip j path =
      match j with
        why, how, Some (l, r), args, fmt, hastipval, seq, ([tl; tr], rewinf),
        ress ->
          begin match path with
            n :: ns ->
              if n = l then go n tl ns
              else if n = r then
                if null ns then stop () else joinstep go stop skip j ns
              else skip (l, r, tl, tr) path
          | [] -> skip (l, r, tl, tr) path
          end
      | why, how, _, args, fmt, hastipval, seq, (ts, rewinf), ress ->
          (* this is what makes the tip path work *)
          match path with
            n :: ns ->
              begin try go n (List.nth (ts) (n)) ns with
                Failure "nth" -> raise (FollowPath_ ("out of range", path))
              end
          | [] -> stop ()
    let rec pathto t =
      match t with
        Join
          (why, how, Some (l, r), args, fmt, hastipval, seq, (ts, rewinf),
           ress) ->
          [r]
      | _ -> []
    let rec followPath_ns t ns =
      match t with
        Tip _ -> if null ns then t else raise (FollowPath_ ("at tip", ns))
      | Join j ->
          joinstep (fun _ -> followPath_ns) (fun _ -> t)
            (fun (l, r, tl, tr) -> followPath_ns tr) j ns
    let rec onestep_ns t path =
      match t with
        Tip _ ->
          if null path then None
          else raise (FollowPath_ ("onestep at tip", path))
      | Join (_, _, Some (l, r), _, _, _, _, ([tl; tr], _), _) ->
          begin match path with
            n :: ns ->
              if n = l then Some (ns, tl)
              else if n = r then Some (ns, tr)
              else Some (path, tr)
          | [] -> Some (path, tr)
          end
      | Join (_, _, _, _, _, _, _, (ts, _), _) ->
          match path with
            n :: ns ->
              begin try Some (ns, List.nth (ts) (n)) with
                Failure "nth" -> raise (FollowPath_ ("onestep out of range", path))
              end
          | [] -> None
    let rec fakePath_ns rf t ns =
      match t with
        Tip _ ->
          if null ns then List.rev rf else raise (FollowPath_ ("at tip", ns))
      | Join j ->
          joinstep (fun n -> fakePath_ns (n :: rf)) (fun _ -> List.rev rf)
            (fun (l, r, tl, tr) -> fakePath_ns (r :: rf) tr) j ns
    let rec getTip_ns t ns =
      match followPath_ns t ns with
        Tip t -> t
      | _ -> raise FindTip_
    let rec findTip_ns t p = (fun (s,_,_)->s) (getTip_ns t p)
    let rec allTips_ns t =
      let rec moretips a1 a2 a3 =
        match a1, a2, a3 with
          ns, (Tip _ as t), tips -> (List.rev ns, t) :: tips
        | ns, Join j, tips ->
            match decode_cutnav j with
              NormalNav ts ->
                nj_fold (fun ((n, t), tips) -> moretips (n :: ns) t tips)
                  (numbered ts) tips
            | CutNav (l, r, tl, tr) ->
                moretips (l :: ns) tl (moretips ns tr tips)
      in
      moretips [] t []
    let rec allTipPaths_ns t = (fst <* allTips_ns t)
    let rec allTipConcs_ns t =
         (function
            ns, Tip (Seq (_, hs, gs), _, _) -> ns, explodeCollection gs
          | _ ->
              raise
                (Catastrophe_ ["allTips gave non-Tip in allTipConcs_ns"])) <*
         allTips_ns t
    (* functions which look for a path *)
    let rec search opt n = (opt &~~ (fun ns -> Some (n :: ns)))
    let rec _F =
      function
        [] -> None
      | (n, t) :: nts -> (search (_G t) n |~~ (fun _ -> _F nts))
    and _G t =
      match t with
        Tip _ -> Some []
      | Join j ->
          match decode_cutnav j with
            NormalNav ts -> _F (numbered ts)
          | CutNav (l, r, tl, tr) -> (search (_G tl) l |~~ (fun _ -> _G tr))
    let findAnyGoal_ns = _G
    let rec findRightwardsGoal_ns skip t path =
      match t with
        Tip _ -> if skip || not (null path) then None else Some []
      | Join j ->
          let rec go n subt ns =
            (search (findRightwardsGoal_ns skip subt ns) n |~~
               (fun _ ->
                  match decode_cutnav j with
                    NormalNav ts -> _F (drop (n + 1) (numbered ts))
                  | CutNav (l, r, tl, tr) -> _G tr))
          in
          joinstep go (fun _ -> _G t)
            (fun (l, r, tl, tr) -> findRightwardsGoal_ns skip tr) j path
    (* Find the deepest parent of a particular node which has the same hypotheses.
     * I check on the way back down, because it is more efficient, and actually it is the only right thing to do!
     * Note that a FRESH proviso in effect introduces a var hypothesis, so we don't go past a rule which has a
     * FRESH proviso.
     *)
    let rec deepest_samehyps tree =
      fun (FmtPath ks) ->
        let rec shs t path =
          let rec topres () =
            let (Seq (_, hs, _)) = sequent t in Some hs, pathto t
          in
          let unFRESH =
            not <*> List.exists isFreshProviso <*> List.map snd
          in
          let rec check a1 a2 =
            match a1, a2 with
              (None, ns), f -> None, f ns
            | (Some hs, ns), f ->
                let (Seq (_, hs', _)) = sequent t in
                if (match hs, hs' with
                      Collection (_, BagClass FormulaClass, es),
                      Collection (_, BagClass FormulaClass, es') ->
                        null (listsub sameresource es es')
                    | _ -> hs = hs') &&
                   (match joinopt join_how t with
                      Some (Apply (name, _, _)) ->
                        begin match thinginfo name with
                          Some (Rule ((_, provisos, _, _), _), _) ->
                            unFRESH provisos
                        | Some (Theorem (_, provisos, _), _) ->
                            unFRESH provisos
                        | _ ->
                            raise
                              (Catastrophe_
                                 ["deepest_samehyps can't find thing named ";
                                  namestring name])
                        end
                    | _ -> true)
                then
                  Some hs, pathto t
                else None, f ns
          in
          let rec go n subt ns = check (shs subt ns) (fun ns -> n :: ns) in
          let rec skip (l, r, tl, tr) ns = check (shs tr ns) (fun ns -> ns) in
          match t with
            Tip _ ->
              if null path then topres ()
              else raise (FollowPath_ ("overflow in deepest_samehyps", path))
          | Join j -> joinstep go topres skip j path
        in
        FmtPath (snd (shs tree ks))
    let rec rootPath_ns t = pathto t
    let rec parentPath_ns t path =
      let rec f t ns =
        match t with
          Tip _ ->
            if null ns then None
            else raise (FollowPath_ ("overflow in parentPath", path))
        | Join j ->
            let rec me _ = Some (pathto t) in
            let rec go n t ns = (search (f t ns) n |~~ me) in
            let rec skip (l, r, tl, tr) ns = (f tr ns |~~ me) in
            joinstep go (fun _ -> None) skip j ns
      in
      match f t path with
        Some res -> res
      | None -> raise (FollowPath_ ("parentPath of root", path))
    let rec siblingPath_ns t path left =
      let rec badLeft () =
        raise (FollowPath_ ("left sibling of leftmost", path))
      in
      let rec badRight () =
        raise (FollowPath_ ("right sibling of rightmost", path))
      in
      let rec f t ns =
        match t with
          Tip _ ->
            if null ns then None
            else raise (FollowPath_ ("overflow in siblingPath", path))
        | Join j ->
            let rec go n t ns =
              (search (f t ns) n |~~
                 (fun _ ->
                    match decode_cutnav j with
                      NormalNav ts ->
                        if left then
                          if n = 0 then badLeft () else Some [n - 1]
                        else if n + 1 >= List.length ts then badRight ()
                        else Some [n + 1]
                    | CutNav (l, r, tl, tr) ->
                        if left then badLeft () else Some (pathto tr)))
            in
            let rec skip (l, r, tl, tr) ns =
              (f tr ns |~~ (fun _ -> if left then Some [l] else badRight ()))
            in
            joinstep go (fun _ -> None) skip j ns
      in
      match f t path with
        Some res -> res
      | None -> raise (FollowPath_ ("siblingPath of root", path))
    (* for subgoalPath we could use path@extras but I don't like leaving cutroot addresses in paths *)
    let rec subgoalPath_ns t path extras =
      let rec f t ns =
        match t with
          Tip _ ->
            if not (null ns) then
              raise (FollowPath_ ("overflow in subgoalPath", path))
            else if not (null extras) then
              raise (FollowPath_ ("subgoal of Tip", path))
            else pathto t
        | Join j ->
            let rec go n t ns = n :: f t ns in
            let rec skip (l, r, tl, tr) ns = f tr ns in
            joinstep go
              (fun _ ->
                 if null extras then pathto t else subgoalPath_ns t extras [])
              skip j ns
      in
      f t path
    (* Hypothesis/conclusion el occurs at position ns;
     * check that it's still there at position ns'.
     * ns must be a prefix of ns', but because resources work the way they do, 
     * I don't check that.  
     * (Which is lucky, given that paths just got more complicated. RB 18/i/00)
     * (But oh dear, since we need to combine hypothesis clicks, we need to know which is a prefix of what! RB 25/vii/00)
     *)
    let rec validelement_ns ishyp proof el ns =
      (* because of resource identity we can do this thing really quickly! *)
      (* nj 109.19 complains if this next thing is written as a val *)
      let rec isin es = List.exists (fun e' -> sameresource (el, e')) es in
      let rec elements tree =
        let (Seq (_, hs, cs)) =
          match tree with
            Join j -> join_seq j
          | Tip t -> tip_seq t
        in
        explodeCollection (if ishyp then hs else cs)
      in
      try isin (elements (followPath_ns proof ns)) with
        _ -> false
    let validhyp_ns = validelement_ns true
    let validconc_ns = validelement_ns false
    let rec stillopen_ns proof ns =
      try
        match followPath_ns proof ns with
          Tip _ -> true
        | _ -> false
      with
        _ -> false
    (* -------------------------- printing proof trees -------------------------- *)
        
	let shyidforFORMULAE = "FORMULAE"
	let shyidforFROM     = "FROM"
	let shyidforINFER    = "INFER"
	let shyidforIS       = "IS"
	let shyidforWHERE    = "WHERE"
	
	let givenssep        = " AND "
	let provisosep       = " AND "
	
    let rec prooftree_stepstring =
      function
        Apply a ->
          "Apply" ^
            triplestring parseablenamestring termliststring string_of_bool "," a
      | Given g ->
          "Given" ^
            triplestring (fun s -> s) string_of_int string_of_bool "," g
      | UnRule u ->
          "Unrule" ^
            pairstring (fun s -> s) (bracketedliststring parseablenamestring ",") "," u
    let nsstring = bracketedliststring string_of_int ","
    let rec join_string
      tlf subtreesf (why, how, cutnav, args, fmt, hastipval, seq, trs, ress) =
      implode
        ["Join("; "reason="; why; ", how="; prooftree_stepstring how;
         ", cutnav=";
         optionstring (pairstring string_of_int string_of_int ",")
           (cutnav : (int * int) option);
         ", args="; pairstring termliststring rewinfstring ", " args;
         ", fmt="; tlf fmt; ", hastipval="; string_of_bool hastipval;
         ", seq="; pairstring elementseqstring rewinfstring ", " seq;
         ", subtrees="; pairstring subtreesf rewinfstring ", " trs; ", ress=";
         begin
           let thsstring =
             bracketedliststring (smlelementstring termstring) ", "
           in
           pairstring (pairstring thsstring thsstring ", ") rewinfstring ", "
             ress
         end;
         ")"]
    let rec prooftreestring tlf t =
      let rec pft tlf rp t =
        (nsstring (pathto t @ List.rev rp) ^ " = ") ^
          (match t with
             Tip t ->
               "Tip" ^ triplestring elementseqstring rewinfstring tlf ", " t
           | Join j ->
               implode
                 (interpolate "\n"
                    (join_string tlf (fun _ -> "... see below ...") j ::
                       (match decode_cutnav j with
                          NormalNav ts ->
                              ((fun (i, t) -> pft tlf (i :: rp) t) <*
                               numbered ts)
                        | CutNav (l, r, tl, tr) ->
                            [pft tlf (l :: rp) tl; pft tlf rp tr]))))
      in
      pft tlf [] t
    exception Can'tHash_
    (* moved outside for OCaml *)
       
	let mkUnRuleTac u =
	  match u with
		("FLATTEN", [t]) -> AssocFlatTac t
	  | ("EVALUATE", ts) -> EvalTac ts
	  | _ -> raise (Catastrophe_
			   ["mkUnRuleTac given "; 
				pairstring 
				  (fun s -> s) (bracketedliststring termstring ",") "," u
			   ])
    
    let rec catelim_prooftree2tactic tree provisos givens tail =
      (* a proof as an executable tactic *)
      let seq = sequent tree in
      let rec thisone j =
        let rec res b t = if b then ResolveTac t else t in
        match join_how j with
          Apply (n, ps, b) ->
            res b
              (try SubstTac (n, (ps ||| join_args j)) with
                 Zip_ -> raise (Catastrophe_ ["Zip_ in prooftree2tactic"]))
        | Given (_, i, b) -> res b (GivenTac (int2term i))
        | UnRule (r, _) -> mkUnRuleTac (r, join_args j)
      in
      let rec traverse =
        function
          Tip t, ts -> NextgoalTac :: ts
        | Join j, ts ->
            let rec tr ts = thisone j :: nj_fold traverse (join_subtrees j) ts in
            match format2layouts (join_fmt j) with
              [] -> tr ts
            | ls ->
                nj_fold (fun (l, t) -> LayoutTac (t, l)) ls
                  (SeqTac (tr [])) ::
                  ts
      in
      let rec hashables =
        function
          Tip _, hs -> hs
        | Join j, hs ->
            let rec catalogue =
              function
                Collection (_, _, els), hs ->
                  nj_fold
                    (function
                       Element (_, _, t), hs -> catalogue (t, hs)
                     | _, hs -> hs)
                    els hs
              | arg, hs ->
                  match hashterm arg with
                    Some h -> arg :: hs
                  | None ->
                      if existsterm
                           (function
                              Literal (_, Number _) -> true
                            | _ -> false)
                           arg
                      then
                        raise Can'tHash_
                      else hs
            in
            nj_fold hashables (join_subtrees j)
              (match join_how j with
                 Apply (_, ps, _) -> nj_fold catalogue (join_args j) hs
               | _ -> hs)
      in
      let rec proof tail =
        try
          let count = ref 0 in
          let rec intorder (i, _) (j, _) = i < j in
          let (lookup, reset) =
            (* terms in the tree get mapped to numbers, so that it can be read in
               more quickly.
             *)
            let module Cache =
              struct
                open Hashtbl
                module Store = Make (struct
									   type t = term
									   let equal = (=)
									   let hash = _The <*> hashterm
									 end
									)
                let store = Store.create 17 (* it will grow *)
                let lookup t = 
                  try Store.find store t
                  with Not_found -> let r = !count in
                                    incr count; Store.add store t r; r
                let reset () = Store.clear store
              end
            in Cache.lookup, Cache.reset
          in
          let hs = try sortunique (<) (hashables (tree, [])) with Can'tHash_ -> []
          in
          let body =
            if null hs then () else showargasint := Some lookup;
            let r = "\n" :: shyidforIS :: "\n" ::
					catelim_tacticstring (SeqTac (traverse (tree, [])))
					  ("\n" :: tail) 
			in showargasint := None; r
          in
          let hashables_body =
            if null hs then body
            else
              "\n" :: shyidforFORMULAE :: "\n" ::
                catelim_liststring
                  (fun (i, t) tail ->
                     string_of_int i :: " " :: catelim_termstring t tail)
                  ",\n"
                  (sortunique intorder ((fun t -> lookup t, t) <* hs))
                  body
          in
          let infer_body =
            "\n" :: shyidforINFER :: " " :: catelim_seqstring seq hashables_body
          in
          let givens_body =
            if null givens then infer_body
            else
              "\n" :: shyidforFROM :: " " ::
                catelim_liststring catelim_seqstring givenssep givens
                  infer_body
          in
          if null provisos then givens_body
          else
            "\n" :: shyidforWHERE :: " " ::
              catelim_liststring catelim_provisostring provisosep provisos
                givens_body
        with
          exn -> showargasint := None; raise exn
      in
      proof tail
    (* -------------------------- rewriting proof trees -------------------------- *)
        
    let rec rew_ress cxt = rew_Pair (rew_elements true cxt)
    let rec getrawinfList rawf (xs, z) = nj_fold rawf xs z
    let rec getrawinfPair rawf ((x1, x2), z) = rawf (x1, rawf (x2, z))
    let rec getrawinfPairDiff rawf1 rawf2 ((x1, x2), z) =
      rawf1 (x1, rawf2 (x2, z))
    let rec getrewinfList rawf xs =
      raw2rew_ (getrawinfList rawf (xs, nullrawinf))
    let rec getrewinfPair rawf pair =
      raw2rew_ (getrawinfPair rawf (pair, nullrawinf))
    let rec getrewinfProoftreeList ts =
      nj_fold rewinf_merge (List.map rewinfProoftree ts) nullrewinf
    let prooftreerewinfdebug = ref false
    (* if we just rewrite a couple of unknowns in a huge sequent, getrewinfSeq is a very
     * expensive way (it turns out) of assessing the state of the new sequent.  In general
     * the rewinf is much smaller than the sequent.  The same applies elsewhere.
     *)
    let rec updaterewinf cxt rewinf =
      let (vars, uVIDs, badres, psig) = rew2rawinf rewinf in
      let changedres =
        nj_fold
          (fun (i, irs) ->
             match rew_resnum cxt (ResUnknown i) with
               None -> irs
             | Some r -> (i, r) :: irs)
          badres []
      in
      let changeduts =
        nj_fold
          (fun (u, uts) ->
             match at (varmap cxt, u) with
               None -> uts
             | Some t -> (u, rewrite cxt t) :: uts)
          uVIDs []
      in
      let addedinf =
        getrewinfList (rawinfTerm cxt) ((snd <* changeduts))
      in
      let changedus = (fst <* changeduts) in
      let vars' =
        sortedlistsub
          (function
             Unknown (_, u, _), u' -> u = u'
           | _ -> false)
          vars changedus
      in
      let uVIDs' = sortedlistsub (fun (x, y) -> x = y) uVIDs changedus in
      let badres' =
        sortedlistsub (fun (x, y) -> x = y) badres
          ((fst <* changedres)) @
          nj_fold
            (function
               ResUnknown i, is -> i :: is
             | _, is -> is)
            ((snd <* changedres)) []
      in
      rewinf_merge
        (raw2rew_ (mkrawinf (vars', uVIDs', badres', psig)), addedinf)
    let rec rew_stuff cxt rew (x, inf) =
      match rew cxt x with
        Some x -> x, updaterewinf cxt inf
      | None -> x, inf
    let rec getrewinfSeq s cxt seq =
      if !prooftreerewinfdebug then
        consolereport ["getrewinfSeq "; s; " "; seqstring seq];
      raw2rew_ (rawinfSeq cxt (seq, nullrawinf))
    let rec getrewinfargs cxt = getrewinfList (rawinfTerm cxt)
    let rec getrewinfress cxt = getrewinfPair (rawinfElements cxt)
    let rec rew_Prooftree a1 a2 =
      match a1, a2 with
        cxt, (Tip (seq, rewinf, fmt) as t) ->
          if rew_worthwhile true cxt rewinf then
            begin
              if !prooftreerewinfdebug then
                consolereport
                  ["rewriting tip "; seqstring seq; "; ";
                   rewinfstring rewinf];
              match rew_Seq true cxt seq with
                Some seq -> Some (Tip (seq, updaterewinf cxt rewinf, fmt))
              | _ -> None
            end
          else None
      | cxt,
        Join
          (why, how, cutnav, (args, argsinf as a), fmt, hastipval,
           (seq, seqinf as s), (ts, tsinf as t), (ress, ressinf as res)) ->
          let ra = rew_worthwhile true cxt argsinf in
          let rs = rew_worthwhile true cxt seqinf in
          let rts = rew_worthwhile true cxt tsinf in
          let rress = rew_worthwhile true cxt ressinf in
          if ((ra || rs) || rts) || rress then
            let rec fst (x, _) = x in
            let a =
              if ra then
                rew_stuff cxt
                  (fun cxt -> option_rewritelist (rew_Term true cxt)) a
              else a
            in
            let s =
              if rs then
                begin
                  if !prooftreerewinfdebug then
                    consolereport
                      ["rewriting join "; seqstring seq; "; ";
                       rewinfstring seqinf];
                  rew_stuff cxt (rew_Seq true) s
                end
              else s
            in
            let t =
              if rts then
                rew_stuff cxt
                  (fun cxt -> option_rewritelist (rew_Prooftree cxt)) t
              else t
            in
            let res = if rress then rew_stuff cxt rew_ress res else res in
            Some (Join (why, how, cutnav, a, fmt, hastipval, s, t, res))
          else None
    let rec rewriteProoftree givens grounded cxt tree =
      let cxt = rewritecxt cxt in
      (* desperation ... *)
      let _ =
        if !prooftreedebug then
          consolereport
            ["before rewrite prooftree is ";
             prooftreestring treeformatstring tree]
      in
      (* ... end desperation *)
      let tree = anyway (rew_Prooftree cxt) tree in
      let inf = rewinfProoftree tree in
      let _ =
        if !prooftreedebug then
          consolereport
            ["context is "; cxtstring cxt; "\nprooftree is ";
             prooftreestring treeformatstring tree]
      in
      let _ =
        if not (null (rewinf_badres inf)) then
          raise
            (Catastrophe_
               ["rewriteProoftree found ResUnknowns ";
                bracketedliststring string_of_int ", " (rewinf_badres inf)])
      in
      (* don't forget the givens when considering grounded provisos *)
      let tvars =
        tmerge
          (rewinf_vars inf)
		  (match exteriorinf cxt with
			 Some ri -> rewinf_vars ri
		   | None -> [])
      in
      let cxt =
        match
          if grounded then groundedprovisos tvars (provisos cxt) else None
        with
          Some ps -> anyway rew_cxt (withprovisos cxt ps)
        | None -> anyway rew_cxt cxt
      in
      let cinf = rewinfCxt cxt in
      (* vars only in givens are in the exterior of the proof, but they aren't thereby 'in use' *)
      let gvars = nj_fold (uncurry2 tmerge) ((seqvars termvars tmerge <* givens)) [] in
      let cvars = sorteddiff earliervar (rewinf_vars cinf) gvars in
      (* val _ =
        consolereport ["gvars are ", termliststring gvars, 
                       "; rewinf_vars cinf are ", termliststring (rewinf_vars cinf), 
                       "; cvars are ", termliststring cvars,
                       "; rewinf_vars inf are ", termliststring (rewinf_vars inf)]
       *)
      let usedVIDs =
        orderVIDs (vid_of_var <* mergevars (rewinf_vars inf) cvars)
      in
      withusedVIDs (withresmap (withvarmap cxt empty) empty) usedVIDs,
      tree, usedVIDs
    (* -------------------------- Tree construction : only for treeformat prooftrees ----------------------------- *)
        
        (* There is an important subtlety in the design of mkTip.
         * It is necessary to record the uVIDs which occur at each
         * node, and at the same time to record if there are any substitutions which might
         * be reduced.  It is important, however, *not* to rewrite the tip sequent at this
         * point, else we can't construct tips which contain 'stable substitutions' (see
         * the WITHSUBSTSEL stuff).  So the cxt which is provided as an argument must be
         * one with which the tip sequent has already been rewritten; use dont_rewrite_with_this
         * if you want a neutral reading.
         * RB 10/x/96
         *)
        
    let rec mkTip cxt seq fmt = Tip (seq, getrewinfSeq "mkTip" cxt seq, fmt)
    (* I can see no reason why mkJoin ought not to rewrite away - it will save 
     * work in rewriteProoftree later.  Hope I'm not wrong ...
     * RB 10/x/96
     *)
    let rec mkJoin cxt why how args fmt seq tops ress =
      let args = (rewrite cxt <* args) in
      let seq = rewriteseq cxt seq in
      let ress = anyway (rew_ress cxt) ress in
      Join
        (why, how, None, (args, getrewinfargs cxt args), fmt, tshaveTip tops,
         (seq, getrewinfSeq "mkJoin" cxt seq),
         (tops, getrewinfProoftreeList tops), (ress, getrewinfress cxt ress))
    exception AlterProof_ of string list
    let rec applytosubtree_ns path t f =
      let rec ans () =
        let (infchanged, t') = f t in infchanged, pathto t', t'
      in
      match t with
        Tip _ ->
          if null path then ans ()
          else raise (AlterProof_ ["path extends beyond tip"])
      | Join j ->
          let rec res infchanged ns subts =
            let subinf =
              if infchanged then getrewinfProoftreeList subts
              else join_subtrees_rewinf j
            in
            let t' =
              Join
                (withhastipval
                   (withsubtrees (j, (subts, subinf)), tshaveTip subts))
            in
            let nextinf = infchanged && subinf <> join_subtrees_rewinf j in
            nextinf, ns, t'
          in
          let rec go n subt ns =
            let (infchanged, ns, subt) = applytosubtree_ns ns subt f in
            res infchanged (n :: ns)
              (match decode_cutnav j with
                 NormalNav sts -> take n sts @ subt :: drop (n + 1) sts
               | CutNav (l, r, tl, tr) -> [subt; tr])
          in
          let rec skip (l, r, tl, tr) ns =
            let (infchanged, ns, subt) = applytosubtree_ns ns tr f in
            res infchanged ns [tl; subt]
          in
          joinstep go ans skip j path
    let rec get_prooftree_fmt tree =
      fun (FmtPath ns) -> format (followPath_ns tree ns)
    let rec set_prooftree_fmt tree =
      fun (FmtPath ns) fmt' ->
        if !prooftreedebug then
          consolereport
            ["setting format "; treeformatstring fmt'; " at "; nsstring ns];
        thrd 
          (applytosubtree_ns ns tree
             (function
                Join (why, how, cutnav, args, fmt, htv, seq, ts, ress) ->
                  false,
                  Join (why, how, cutnav, args, fmt', htv, seq, ts, ress)
              | Tip (seq, rewinf, fmt) -> false, Tip (seq, rewinf, fmt')))
    let rec get_prooftree_cutnav tree =
      fun (FmtPath ns) ->
        match followPath_ns tree ns with
          Join j -> join_cutnav j
        | Tip _ -> raise FindTip_
    (* or should it be FollowPath_ ? *)

    let rec set_prooftree_cutnav tree =
      fun (FmtPath ns) cutnav ->
        thrd 
          (applytosubtree_ns ns tree
             (function
                Join (why, how, _, args, fmt, htv, seq, ts, ress) ->
                  if match cutnav, ts with
                       None, _ -> true
                     | Some _, ([_; _], _) -> true
                     | _ -> false
                  then
                    false,
                    Join (why, how, cutnav, args, fmt, htv, seq, ts, ress)
                  else
                    raise
                      (AlterProof_
                         ["cutnav applied to obviously non-cut node"])
              | Tip _ -> raise (AlterProof_ ["cutnav applied to tip"])))
    let rec truncateprooftree cxt =
      fun (FmtPath ns) tree ->
        let (_, ns, tree) =
          applytosubtree_ns ns tree
            (function
               Join j ->
                 let t' =
                   mkTip cxt (rewriteseq cxt (join_seq j)) (join_fmt j)
                 in
                 true, t'
             | tip -> false, tip)
        in
        FmtPath ns, tree
    let rec insertprooftree cxt =
      fun (FmtPath ns) tree subtree ->
        let (_, ns, tree) =
          applytosubtree_ns ns tree
            (fun inspoint ->
               if eqseqs
                    (rewriteseq cxt (sequent inspoint),
                     rewriteseq cxt (sequent subtree))
               then
                 let t' =
                   set_prooftree_fmt subtree (FmtPath (rootPath_ns subtree))
                     (treeformatmerge (format inspoint, format subtree))
                 in
                 true, t'
               else
                 raise
                   (AlterProof_
                      ["sequents not equal (insertprooftree) -- ";
                       seqstring (sequent tree); " => ";
                       seqstring (anyway (rew_Seq true cxt) (sequent tree));
                       " -- "; seqstring (sequent subtree); " => ";
                       seqstring
                         (anyway (rew_Seq true cxt) (sequent subtree))]))
        in
        FmtPath ns, tree
    (* the same comment as in mkTip, about contexts and rewriting, applies to replaceTip *)
    (* this looks a bit dangerous ... I guess I've used it carefully *)
    let rec replaceTip cxt =
      fun (FmtPath ns) tree seq ->
        let (_, ns, tree) =
          applytosubtree_ns ns tree
            (function
               Tip (_, _, fmt) -> let t = mkTip cxt seq fmt in true, t
             | _ -> raise (AlterProof_ ["replaceTip applied to Join"]))
        in
        tree
    let rec makewhole a1 a2 a3 a4 =
      match a1, a2, a3, a4 with
        cxt, Some (oldtree, (FmtPath oldns as oldpath)), newtree,
        FmtPath newns ->
          let (FmtPath ns, tree) =
            insertprooftree cxt oldpath oldtree newtree
          in
          FmtPath (subgoalPath_ns tree ns newns), tree
      | cxt, None, newtree, newpath -> newpath, newtree
    (* this is the most dangerous thing I have tried so far. It must be done ONLY if
     * autoAdditiveLeft is true.  It must not be applied to a subtree which contains
     * a rule that has a FRESH proviso.
     *)
    let rec augmenthyps cxt tree els =
      let rewinf = raw2rew_ (rawinfElements cxt (els, nullrawinf)) in
      let rec augseq =
        fun (Seq (st, hs, cs)) ->
          try Seq (st, _The (augmentCollection hs els), cs) with
            _The_ ->
              raise (Catastrophe_ ["can't augment non-Collection hyps"])
      in
      let rec aug =
        function
          Tip (seq, inf, fmt) ->
            Tip (augseq seq, rewinf_merge (inf, rewinf), fmt)
        | Join
            (why, how, cutnav, (args, arginf), fmt, hastipval, (seq, seqinf),
             (trs, trsinf), ress) ->
            let rec augargs =
              function
                [] ->
                  raise
                    (Catastrophe_
                       ["no Collection argument for sequent "; seqstring seq])
              | arg :: args ->
                  if isCollection arg then
                    _The (augmentCollection arg els) :: args
                  else arg :: augargs args
            in
            Join
              (why, how, cutnav,
               (match how with
                  UnRule _ ->
                    (try augargs args with
                       _ -> args),
                    arginf
                | _ -> augargs args, rewinf_merge (arginf, rewinf)),
               fmt, hastipval, (augseq seq, rewinf_merge (seqinf, rewinf)),
               ((aug <* trs), rewinf_merge (trsinf, rewinf)), ress)
      in
      aug tree
    let rec maxtreeresnum t =
      match t with
        Join j ->
          nj_fold (uncurry2 max)
            (maxseqresnum (join_seq j) ::
               (maxtreeresnum <* join_subtrees j))
            0
      | Tip t -> maxseqresnum (tip_seq t)
            
    let isCutRule = isstructurerule CutRule
    let rec isCutStep t =
      fun (FmtPath ns) ->
        try
          match rule (followPath_ns t ns) with
            Some name -> isCutRule name
          | None -> false
        with
          _ -> false
    let rec isCutjoin j =
      match join_how j with
        Apply (r, _, _) -> isCutRule r
      | _ -> false
    (* ---------------------- translating trees and paths -------------------------- *)

    let rec join_fmtNsubts j = join_fmt j, join_subtrees j
    let fmtNsubts = joinopt join_fmtNsubts
    let rec pathedsubtrees =
      function
        why, how, Some (l, r), args, fmt, hastipval, seq, ([tl; tr], rewinf),
        ress ->
          [[l], tl; [], tr]
      | why, how, _, args, fmt, hastipval, seq, (ts, rewinf), ress ->
          (fun (i, t) -> [i], t) <* numbered ts
    let rec visibles showall j =
      let pts = pathedsubtrees j in
      let rec default () = pts, [] in
      let rec hideroots fmt ascut (ins, outs) =
        let rec h ((p, t as pt), (ins, outs)) =
          let rec nohide () = pt :: ins, outs in
          let rec hr j' =
            let (Seq (_, hs, _)) = join_seq j in
            let (Seq (_, hs', _)) = join_seq j' in
            if hs = hs' then
              let hs =
                   (fun (ns, t) -> p @ ns, t) <*
                   fst (visibles showall j')
              in
              hs @ ins, pt :: outs
            else nohide ()
          in
          match t with
            Tip _ -> nohide ()
          | Join j ->
              match join_fmt j with
                TreeFormat (HideRootFormat, _) ->
                  let r = hr j in
                  (* cut steps keep their shape, else they don't mean anything *)
                  if ascut && List.length (fst r) <> 1 + List.length ins then
                    begin
                      if !cuthidingdebug then
                        consolereport
                          ["visibles not HIDEROOTING ";
                           join_string treeformatstring
                             (bracketedliststring
                                (seqstring <*> sequent) ",")
                             j];
                      nohide ()
                    end
                  else r
              | TreeFormat (_, RotatingFormat (i, nfs)) ->
                  if try
                       match fmt, List.nth (nfs) (i) with
                         Some (true, s, _), (true, s', _) -> s = s'
                       | _ -> false
                     with
                       _ -> false
                  then
                    hr j
                  else nohide ()
              | _ -> nohide ()
        in
        nj_fold h ins ([], outs)
      in
      let res =
        if showall then default ()
        else
          match join_fmt j with
            TreeFormat (_, RotatingFormat (i, nfs)) ->
              begin try
                match List.nth (nfs) (i) with
                  _, _, Some which as fmt ->
                    let inouts =
                      nj_fold
                        (fun ((i, (_, t as pt)), (ins, outs)) ->
                           if hasTip t || member (i, which) then
                             pt :: ins, outs
                           else ins, pt :: outs)
                        (numbered pts) ([], [])
                    in
                    hideroots (Some fmt) false inouts
                | fmt -> hideroots (Some fmt) (isCutjoin j) (pts, [])
              with
                Failure "nth" -> default ()
              end
          | _ -> hideroots None (isCutjoin j) (pts, [])
      in
      if !prooftreedebug then
        begin
          let onelevel =
            bracketedliststring (seqstring <*> sequent) ","
          in
          let ptstring =
            bracketedliststring
              (pairstring nsstring (seqstring <*> sequent) ",")
              ", "
          in
          consolereport
            ["visibles "; string_of_bool showall; " ";
             join_string treeformatstring onelevel j; " => ";
             pairstring ptstring ptstring ", " res]
        end;
      res
    let rec visfn a1 a2 a3 =
      match a1, a2, a3 with
        f, showall, Tip _ -> None
      | f, showall, Join j -> Some (f showall j)
    let rec visible_subtrees showall =
      try__ fst <*> joinopt (visibles showall)
    let rec invisible_subtrees showall =
      try__ snd <*> joinopt (visibles showall)

    let rec pathtoviewpath showall t =
      fun (FmtPath ns) ->
        let rec _P ns rns t =
          let r = pathto t in
          if r = ns then Some (VisPath (List.rev rns))
          else if not (null r) && isprefix (fun (x, y) -> x = y) r ns then
            _P (drop (List.length r) ns) rns t
          else
		    visible_subtrees showall t &~~
			  (fun ts ->
				 let rec find (i, (tns, t)) =
				   if isprefix (fun (x, y) -> x = y) tns ns then
					 Some (i, drop (List.length tns) ns, t)
				   else None
				 in
				 (findfirst find (numbered ts) &~~
					(fun (i, ns', t) -> _P ns' (i :: rns) t)))
        in
        _P ns [] t
    (* this didn't get the right answer for the root of cuts, so I added pathto to the final result. RB 22/ii/00 *) 
    let rec viewpathtopath showall t =
      fun (VisPath ns) ->
        let rec rev1 a1 a2 =
          match a1, a2 with
            [], ys -> ys
          | x :: xs, ys -> rev1 xs (x :: ys)
        in
        let rec _P a1 a2 a3 =
          match a1, a2, a3 with
            n :: ns, rns, t ->
              (visible_subtrees showall t &~~
                 (fun ts ->
                    try
                      let (ns', t) = List.nth (ts) (n) in _P ns (rev1 ns' rns) t
                    with
                      Failure "nth" -> None))
          | [], rns, t -> Some (FmtPath (rev1 rns (pathto t)))
        in
        _P ns [] t
    (* for export *)
    let reasonstyle = ref "long"
    let visible_subtrees showall =
      try__ (fun pts -> (snd <* pts)) <*> visible_subtrees showall
    let rec visreason proved showall t =
      joinopt (join_visreason proved showall) t
    and join_visreason proved showall j =
      let shortnames = !reasonstyle = "short" in
      let rec rprintf cs f =
        (* doesn't evaluate f() until it's needed *)
        let rec rpr =
          function
            [] -> []
          | "%" :: "s" :: cs ->
              let ss = f () in ss @ rprintf cs (fun () -> ss)
          | "%" :: c :: cs -> c :: rpr cs
          | c :: cs -> c :: rpr cs
        in
        rpr cs
      in
      let rec justify name =
        if shortnames then [namestring name]
        else
          match thingnamed name with
            Some (Theorem _, _) ->
              [if proved name then "Theorem" else "Conjecture"; " ";
               namestring name]
          | Some (Rule (_, false), _) ->
              [if proved name then "Derived Rule" else "Conjectured Rule";
               " "; namestring name]
          | _ -> [namestring name]
      in
      let rec default_reason () =
        match join_how j with
          Given _ -> [join_why j]
        | Apply (n, _, _) -> justify n
        | UnRule (s, _) -> [s]
      in
      implode
        (if showall then
           if step_resolve (join_how j) then "Resolve " :: default_reason ()
           else default_reason ()
         else
           let rec f =
             fun (TreeFormat (_, fmt)) ->
               match fmt with
                 RotatingFormat (i, nfs) ->
                   begin try
                     let rec invisf () =
                       interpolate ","
                         (implode (default_reason ()) ::
                            invisiblereasons proved showall j)
                     in
                     let (fmt, strf) =
                       match List.nth (nfs) (i) with
                         _, "", Some [] -> !foldedfmt, invisf
                       | _, "", Some _ -> !filteredfmt, invisf
                       | _, "", None -> !unfilteredfmt, default_reason
                       | _, s, Some _ -> s, invisf
                       | _, s, None -> s, default_reason
                     in
                     rprintf (explode fmt) strf
                   with
                     Failure "nth" -> rprintf (explode !rawfmt) default_reason
                   end
               | _ -> default_reason ()
           in
           f (join_fmt j))
    and invisiblereasons proved showall j =
         _The <*
           (opt2bool <|
            List.concat
              ((allreasons proved showall <*> snd) <*
                  snd (visibles showall j)))
    and allreasons proved showall t =
      visreason proved showall t ::
        (match t with
           Tip _ -> []
         | Join j ->
             List.concat ((allreasons proved showall <* join_subtrees j)))
    let rec join_multistep j vissubts =
      step_resolve (join_how j) ||
      List.exists (fun (ns, _) -> List.length ns > 1) vissubts
    let hyps =
      explodeCollection <*> snd_of_3 <*> seqexplode
    let concs =
      explodeCollection <*> thrd <*> seqexplode
    let rec tranproof proved showall hideuselesscuts t =
      let rec visp =
        function
          Tip (seq, rewinf, _) ->
            [], Tip (seq, rewinf, VisFormat (false, false))
        | Join (why, how, cutnav, args, fmt, htv, seq, subts, ress as j) as
            it ->
            let (viss, _) = visibles showall j in
            let lpsNsubts' =
              ((visp <*> snd) <* viss)
            in
            let lps =
              nj_fold (uncurry2 (sortedmerge earlierresource))
                ((fst <* lpsNsubts'))
                (sort earlierresource (fst (fst ress)))
            in
            let subts' = (snd <* lpsNsubts') in
            let hidecut =
              (not showall && isCutjoin j) &&
              (match fmt with
                 TreeFormat (HideCutFormat, _) -> true
               | _ ->
                   match subts with
                     [t1; t2], _ ->
                       (* if we have a cut whose left subtree has been HIDEROOTED away, we can't 
                        * allow the HIDEROOT or we would generate an assumption box.  
                        * But we would like to hide them, so we have to try to hide the cut.
                        * Note that visibles doesn't reshape cuts.
                        *)
                       (match joinopt join_fmt t1 with
                          Some (TreeFormat (HideRootFormat, _)) -> true
                        | _ -> false) ||
                       hideuselesscuts &&
                       (match
                          concs (sequent t1),
                          listsub sameresource (hyps (sequent t2))
                            (hyps (fst seq))
                        with
                          [cc], [ch] ->
                            not
                              (hasTip t2 ||
                               List.exists (fun el -> sameresource (el, ch)) lps)
                        | _ -> false)
                   | _ -> false)
            in
            lps,
            Join
              (_The (visreason proved showall it), how, None, args,
               VisFormat (join_multistep j viss, hidecut), tshaveTip subts',
               seq, (subts', snd subts), ress)
      in
      visp t
    (* for export *)
    
    let rec visproof proved showall hideuselesscuts =
      snd <*> tranproof proved showall hideuselesscuts
    (* there surely ought to be a way to make these structures into one -- I suppose functors inside functors
     * ain't SML.
     *)
    module Fmttree : Access with type fmt = treeformat
							 and type path = fmtpath
							 and type prooftree = treeformat prooftree
							 and type seq = seq
							 and type rewinf = rewinf
							 and type element = element
							 and type name = name
    =
      struct
        type fmt = treeformat
        and  path = fmtpath
        type temp_prooftree = fmt prooftree
         and temp_seq = seq
         and temp_rewinf = rewinf
         and temp_element = element
         and temp_name = name
        type prooftree = temp_prooftree
         and seq = temp_seq
		 and rewinf = temp_rewinf
		 and element = temp_element
		 and name = temp_name
        
        let fFmtPath v = FmtPath v
        let rec dePath = fun (FmtPath ns) -> ns
        let rec rePath (ns, x) = FmtPath ns, x
        let rec followPath t = followPath_ns t <*> dePath
        let rec onestep t =
          try__ rePath <*> onestep_ns t <*> dePath
        let rec fakePath t = fakePath_ns [] t <*> dePath
        let rec pathPrefix t p1 p2 =
          isprefix (fun (x, y) -> x = y) (fakePath t p1) (fakePath t p2)
        let rec findTip t = findTip_ns t <*> dePath
        let rec getTip t = getTip_ns t <*> dePath
        let rec allTipPaths t = (fFmtPath <* allTipPaths_ns t)
        let rec allTipConcs t = (rePath <* allTipConcs_ns t)
        let rec validelement b t el =
          fun (FmtPath ns) -> validelement_ns b t el ns
        let validhyp = validelement true
        let validconc = validelement false
        let rec stillopen t = stillopen_ns t <*> dePath
        let maxtreeresnum = maxtreeresnum
        let isTip = isTip
        let hasTip = hasTip
        let rootPath = fFmtPath <*> rootPath_ns
        let rec parentPath t =
          fFmtPath <*> parentPath_ns t <*> dePath
        let rec siblingPath t path =
          fFmtPath <*> siblingPath_ns t (dePath path)
        let rec subgoalPath t path =
          fFmtPath <*> subgoalPath_ns t (dePath path)
        let rec reason proved = visreason proved !showallproofsteps
        let subtrees = subtrees
        let sequent = sequent
        let rule = rule
        let thinned = thinned
        let format = format
        let depends = depends
        let findAnyGoal = optioncompose (fFmtPath, findAnyGoal_ns)
        let rec findRightwardsGoal skip t =
          fun (FmtPath ns) -> try__ fFmtPath (findRightwardsGoal_ns skip t ns)
        let fmtstring = treeformatstring
        let pathstring = fmtpathstring
        let prooftreestring = prooftreestring fmtstring
      end
    
    module Vistree : Access  with type fmt = visformat
							 and type path = vispath
							 and type prooftree = visformat prooftree
							 and type seq = seq
							 and type rewinf = rewinf
							 and type element = element
							 and type name = name
    =
      struct
        type fmt = visformat
        and path = vispath
        type temp_prooftree = fmt prooftree
         and temp_seq = seq
         and temp_rewinf = rewinf
         and temp_element = element
         and temp_name = name
        type prooftree = temp_prooftree
         and seq = temp_seq
		 and rewinf = temp_rewinf
		 and element = temp_element
		 and name = temp_name
        
        let fVisPath v = VisPath v
        let rec dePath = fun (VisPath ns) -> ns
        let rec rePath (ns, x) = VisPath ns, x
        let rec followPath t = followPath_ns t <*> dePath
        let rec onestep t =
          try__ rePath <*> onestep_ns t <*> dePath
        let rec fakePath t = fakePath_ns [] t <*> dePath
        let rec pathPrefix t p1 p2 =
          isprefix (fun (x, y) -> x = y) (fakePath t p1) (fakePath t p2)
        let rec findTip t = findTip_ns t <*> dePath
        let rec getTip t = getTip_ns t <*> dePath
        let rec allTipPaths t = (fVisPath <* allTipPaths_ns t)
        let rec allTipConcs t = (rePath <* allTipConcs_ns t)
        let rec validelement b t el =
          fun (VisPath ns) -> validelement_ns b t el ns
        let validhyp = validelement true
        let validconc = validelement false
        let rec stillopen t = stillopen_ns t <*> dePath
        let maxtreeresnum = maxtreeresnum
        let isTip = isTip
        let hasTip = hasTip
        let rec rootPath t = VisPath []
        (* no inner cuts in visprooftrees *)
        let rec parentPath t =
          fVisPath <*> parentPath_ns t <*> dePath
        let rec siblingPath t path =
          fVisPath <*> siblingPath_ns t (dePath path)
        let rec subgoalPath t path =
          fVisPath <*> subgoalPath_ns t (dePath path)
        let rec reason proved = joinopt join_why
        (* doesn't make use of proved, because it's already happened... *)
        let subtrees = subtrees
        let sequent = sequent
        let rule = rule
        let thinned = thinned
        let format = format
        let depends = depends
        let findAnyGoal = optioncompose (fVisPath, findAnyGoal_ns)
        let rec findRightwardsGoal skip t =
          fun (VisPath ns) -> try__ fVisPath (findRightwardsGoal_ns skip t ns)
        let fmtstring = visformatstring
        let pathstring = vispathstring
        let prooftreestring = prooftreestring fmtstring
      end
  end



