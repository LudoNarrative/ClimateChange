
1 {replace(O,increase(R),increase(R,A)) : potentialValues(A) } 1 :- result(O,increase(R)).
1 {replace(O,decrease(R),decrease(R,A)) : potentialValues(A) } 1 :- result(O,decrease(R)).

1 {replace_precondition(O,ge(R),ge(R,A)) : potentialValues(A) } 1 :- precondition(ge(R),O).
1 {replace_precondition(O,le(R),le(R,A)) : potentialValues(A) } 1 :- precondition(le(R),O).

1 {replace(O,moves(E,D),moves(E,D,A)) : speeds(A) } 1 :- result(O,moves(E,D)).
1 {replace(O,move_towards(E,E2),move_towards(E,E2,A)) : speeds(A) } 1 :- result(O,move_towards(E,E2)).
1 {replace(O,move_away(E,E2),move_away(E,E2,A)) : speeds(A) } 1 :- result(O,move_away(E,E2)).

:- replace(O,increase(R),increase(R,R)).
:- replace(O,decrease(R),decrease(R,R)).
:- replace_precondition(O,ge(R),ge(R,R)).
:- replace_precondition(O,le(R),le(R,R)).
:- replace(O,increase(R),increase(R,0)).
:- replace(O,decrease(R),decrease(R,0)).


:- result(O, mode_change(M)),
   replace_precondition(O, le(R), le(R,A)), A != 0.

:- result(O, mode_change(M)),
   replace_precondition(O, ge(R), ge(R,A)), A != high.

:- result(O, mode_change(M)),
   replace_precondition(O, ge(R), ge(R,A)),
   2 { replace_precondition(_,ge(_),ge(_,A))}.

:- result(O, mode_change(M)),
   replace(O, le(R), le(R,A)),
   2 { replace_precondition(_,le(_),le(_,A))}.
