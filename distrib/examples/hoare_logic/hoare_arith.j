﻿/*
    $Id$

    Copyright (C) 2004 Richard Bornat
     
        richard@bornat.me.uk

    This file is part of the jape examples distribution, which is part of jape.

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

*/

RULE "arith_var" IS INFER A∧(x computes) simplifiesto A
RULE "arith_const" IS INFER A∧(K computes) simplifiesto A

RULES "arith_single" ARE
    FROM E∧(A computes) simplifiesto F
    INFER E∧(¬A computes) simplifiesto F
END

RULES "arith_double" ARE
    FROM E∧(A computes) simplifiesto F AND 
         F∧(B computes) simplifiesto G 
    INFER E∧(A → B computes) simplifiesto G
AND FROM E∧(A computes) simplifiesto F AND 
         F∧(B computes) simplifiesto G 
    INFER E∧(A ↔ B computes) simplifiesto G
AND FROM E∧(A computes) simplifiesto F AND 
         F∧(B computes) simplifiesto G 
    INFER E∧(A ∨ B computes) simplifiesto G
AND FROM E∧(A computes) simplifiesto F AND 
         F∧(B computes) simplifiesto G 
    INFER E∧(A ∧ B computes) simplifiesto G
AND FROM E∧(A computes) simplifiesto F AND 
         F∧(B computes) simplifiesto G 
    INFER E∧(A < B computes) simplifiesto G
AND FROM E∧(A computes) simplifiesto F AND 
         F∧(B computes) simplifiesto G 
    INFER E∧(A > B computes) simplifiesto G
AND FROM E∧(A computes) simplifiesto F AND 
         F∧(B computes) simplifiesto G 
    INFER E∧(A ≤ B computes) simplifiesto G
AND FROM E∧(A computes) simplifiesto F AND 
         F∧(B computes) simplifiesto G 
    INFER E∧(A ≥ B computes) simplifiesto G
AND FROM E∧(A computes) simplifiesto F AND 
         F∧(B computes) simplifiesto G 
    INFER E∧(A ≠ B computes) simplifiesto G
AND FROM E∧(A computes) simplifiesto F AND 
         F∧(B computes) simplifiesto G 
    INFER E∧(A = B computes) simplifiesto G
AND FROM E∧(A computes) simplifiesto F AND 
         F∧(B computes) simplifiesto G 
    INFER E∧(A + B computes) simplifiesto G
AND FROM E∧(A computes) simplifiesto F AND 
         F∧(B computes) simplifiesto G 
    INFER E∧(A - B computes) simplifiesto G
AND FROM E∧(A computes) simplifiesto F AND 
         F∧(B computes) simplifiesto G 
    INFER E∧(A × B computes) simplifiesto G
AND FROM E∧(A computes) simplifiesto F AND 
         F∧(B computes) simplifiesto G 
    INFER E∧(A ↑ B computes) simplifiesto G
END

RULES "arith_div" ARE
    FROM E∧(A computes) simplifiesto F AND 
         F∧(B computes) simplifiesto G AND 
         G∧B≠0 equivto H
    INFER E∧(A ÷ B computes) simplifiesto H
AND FROM E∧(A computes) simplifiesto F AND 
         F∧(B computes) simplifiesto G AND 
         G∧B≠0 equivto H
    INFER E∧(A mod B computes) simplifiesto H
END

RULE "arith_index" IS
     FROM E∧(F computes) simplifiesto G AND 
          G∧0≤F equivto H             AND
          H∧F<length(a) equivto I
    INFER E∧(a[F] computes) simplifiesto I

TACTIC simpl IS
  SEQ (LAYOUT HIDEROOT)
      (ALT (LETGOAL (_E∧(_x computes) simplifiesto _F)
              (UNIFY _F _E) (MATCH "arith_var"))
           (LETGOAL (_E∧(_K computes) simplifiesto _F)
              (UNIFY _F _E) (MATCH "arith_const"))
          (SEQ (MATCH "arith_index") simpl equiv equiv)
          (SEQ (MATCH "arith_single") simpl)
          (SEQ (MATCH "arith_double") simpl simpl)
          (SEQ (MATCH "arith_div") simpl simpl equiv))

RULE "arith_defin_var" IS INFER A∧(x defined) simplifiesto A
RULE "arith_defin_const" IS INFER A∧(K defined) simplifiesto A

RULES "arith_defin_single" ARE
    FROM E∧(A defined) simplifiesto F
    INFER E∧(¬A defined) simplifiesto F
END

RULES "arith_defin_double" ARE
    FROM E∧(A defined) simplifiesto F AND 
         F∧(B defined) simplifiesto G 
    INFER E∧(A → B defined) simplifiesto G
AND FROM E∧(A defined) simplifiesto F AND 
         F∧(B defined) simplifiesto G 
    INFER E∧(A ↔ B defined) simplifiesto G
AND FROM E∧(A defined) simplifiesto F AND 
         F∧(B defined) simplifiesto G 
    INFER E∧(A ∨ B defined) simplifiesto G
AND FROM E∧(A defined) simplifiesto F AND 
         F∧(B defined) simplifiesto G 
    INFER E∧(A ∧ B defined) simplifiesto G
AND FROM E∧(A defined) simplifiesto F AND 
         F∧(B defined) simplifiesto G 
    INFER E∧(A < B defined) simplifiesto G
AND FROM E∧(A defined) simplifiesto F AND 
         F∧(B defined) simplifiesto G 
    INFER E∧(A > B defined) simplifiesto G
AND FROM E∧(A defined) simplifiesto F AND 
         F∧(B defined) simplifiesto G 
    INFER E∧(A ≤ B defined) simplifiesto G
AND FROM E∧(A defined) simplifiesto F AND 
         F∧(B defined) simplifiesto G 
    INFER E∧(A ≥ B defined) simplifiesto G
AND FROM E∧(A defined) simplifiesto F AND 
         F∧(B defined) simplifiesto G 
    INFER E∧(A ≠ B defined) simplifiesto G
AND FROM E∧(A defined) simplifiesto F AND 
         F∧(B defined) simplifiesto G 
    INFER E∧(A = B defined) simplifiesto G
AND FROM E∧(A defined) simplifiesto F AND 
         F∧(B defined) simplifiesto G 
    INFER E∧(A + B defined) simplifiesto G
AND FROM E∧(A defined) simplifiesto F AND 
         F∧(B defined) simplifiesto G 
    INFER E∧(A - B defined) simplifiesto G
AND FROM E∧(A defined) simplifiesto F AND 
         F∧(B defined) simplifiesto G 
    INFER E∧(A × B defined) simplifiesto G
AND FROM E∧(A defined) simplifiesto F AND 
         F∧(B defined) simplifiesto G 
    INFER E∧(A ↑ B defined) simplifiesto G
AND FROM E∧(A defined) simplifiesto F AND 
         F∧(B defined) simplifiesto G
    INFER E∧(A ÷ B defined) simplifiesto G
AND FROM E∧(A defined) simplifiesto F AND 
         F∧(B defined) simplifiesto G 
    INFER E∧(A mod B defined) simplifiesto G
END

RULE "arith_defin_index" IS
     FROM E∧0≤F equivto H             AND
          H∧F<length(a) equivto I
    INFER E∧(a[F] defined) simplifiesto I

TACTIC defin IS
  SEQ (LAYOUT HIDEROOT)
      (ALT (LETGOAL (_E∧(_x defined) simplifiesto _F)
              (UNIFY _F _E) (MATCH "arith_defin_var"))
           (LETGOAL (_E∧(_K defined) simplifiesto _F)
              (UNIFY _F _E) (MATCH "arith_defin_const"))
          (SEQ (MATCH "arith_defin_index") equiv equiv)
          (SEQ (MATCH "arith_defin_single") defin)
          (SEQ (MATCH "arith_defin_double") defin defin))

TACTIC equiv IS 
  SEQ (LAYOUT HIDEROOT (ALT (SEQ "arith_dup" conjoinstac) SKIP))
      (LAYOUT HIDEROOT (ALT "true_equiv" "equiv_default"))

RULE "arith_dup" IS 
   FROM E conjoins F AND E equivto G 
  INFER E∧F equivto G

DERIVED RULE "arith_true" IS ⊤∧A equivto A
DERIVED RULE "equiv_default" IS A equivto A

TACTIC "true_equiv" IS
  (LETGOAL (⊤∧_A equivto _B) (UNIFY _B _A) (MATCH "arith_true"))
    
TACTIC maybetrueimpl IS
  ALT (SEQ (LAYOUT HIDEROOT (MATCH "→ intro")) (LAYOUT HIDEROOT (MATCH "truth")))
      SKIP

/* we can simplify length assertions */

TACTIC "length_simpl"(a,E,F) IS
  LAYOUT HIDEROOT ("arith_length" a E F)

RULE "arith_length"(a,E,F,OBJECT x) IS
   FROM A«length(a)/x» simplifiesto B
  INFER A«length(a⊕E↦F)/x» simplifiesto B

/* we can get rid of duplicate obligations */

RULES "arith_conjoins0" ARE
    INFER E∧F conjoins F
AND INFER F conjoins F
END

RULE "arith_conjoinsL" IS
  FROM E conjoins G INFER E∧F conjoins G
RULE "arith_conjoinsR" IS
  FROM F conjoins G INFER E∧F conjoins G

TACTIC conjoinstac IS
  LAYOUT HIDEROOT
    (ALT (MATCH "arith_conjoins0")
         (SEQ (MATCH "arith_conjoinsL") conjoinstac)
         (SEQ (MATCH "arith_conjoinsR") conjoinstac))

/* deducing boundedness from equality/inequality */

RULE "bounded(<)(L)" IS FROM A<B AND A dependson a[E] INFER 0≤E∧E<length(a)
RULE "bounded(<)(R)" IS FROM A<B AND B dependson a[E] INFER 0≤E∧E<length(a)

RULE "bounded(≤)(L)" IS FROM A≤B AND A dependson a[E] INFER 0≤E∧E<length(a)
RULE "bounded(≤)(R)" IS FROM A≤B AND B dependson a[E] INFER 0≤E∧E<length(a)

RULE "bounded(=)(L)" IS FROM A=B AND A dependson a[E] INFER 0≤E∧E<length(a)
RULE "bounded(=)(R)" IS FROM A=B AND B dependson a[E] INFER 0≤E∧E<length(a)

RULE "bounded(≥)(L)" IS FROM A≥B AND A dependson a[E] INFER 0≤E∧E<length(a)
RULE "bounded(≥)(R)" IS FROM A≥B AND B dependson a[E] INFER 0≤E∧E<length(a)

RULE "bounded(>)(L)" IS FROM A>B AND A dependson a[E] INFER 0≤E∧E<length(a)
RULE "bounded(>)(R)" IS FROM A>B AND B dependson a[E] INFER 0≤E∧E<length(a)

TACTIC checkdependencytac (ruleL, ruleR, H, a, E) IS
  CUTIN
    (LAYOUT "bounded")
    (ALT (SEQ (ruleL«a,E/a,E») (LETGOAL _G (UNIFY _G H)) (ANY (MATCH (hyp H))) (dependencyrec a E))
         (SEQ (ruleR«a,E/a,E») (LETGOAL _G (UNIFY _G H)) (ANY (MATCH (hyp H))) (dependencyrec a E))
         (ALERT ("To imply boundedness, an equality/inequality must unconditionally \
                 \depend on the value of an array element.\
                 \\n\n%t doesn't depend on %t in that way.", H, a[E])
                ("OK", STOP)))
                
RULE bounded0 IS a[E] dependson a[E]

RULES bounded1L ARE
    FROM A dependson a[E] INFER A+B dependson a[E]
AND FROM A dependson a[E] INFER A-B dependson a[E]
AND FROM A dependson a[E] INFER A×B dependson a[E]
AND FROM A dependson a[E] INFER A÷B dependson a[E]
AND FROM A dependson a[E] INFER A↑B dependson a[E]
END

RULES bounded1R ARE
    FROM B dependson a[E] INFER A+B dependson a[E]
AND FROM B dependson a[E] INFER A-B dependson a[E]
AND FROM B dependson a[E] INFER A×B dependson a[E]
AND FROM B dependson a[E] INFER A÷B dependson a[E]
AND FROM B dependson a[E] INFER A↑B dependson a[E]
END

TACTIC dependencyrec(a,E) IS
  LAYOUT HIDEROOT
    (ALT (MATCH (bounded0«a,E/a,E»))
         (SEQ (MATCH (bounded1L«a,E/a,E»)) (dependencyrec a E))
         (SEQ (MATCH (bounded1R«a,E/a,E»)) (dependencyrec a E)))
      