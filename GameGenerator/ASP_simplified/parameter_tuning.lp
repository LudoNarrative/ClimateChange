
1 {replace(result(O,increase(R)),result(O,increase(R,A))) : potentialValues(A) } 1 :- result(O,increase(R)).
1 {replace(result(O,decrease(R)),result(O,decrease(R,A))) : potentialValues(A) } 1 :- result(O,decrease(R)).

1 {replace(precondition(ge(R),O),precondition(ge(R,A),O)) : potentialValues(A) } 1 :- precondition(ge(R),O).
1 {replace(precondition(le(R),O),precondition(le(R,A),O)) : potentialValues(A) } 1 :- precondition(le(R),O).

%% 1 {replace(O,moves(E,D),moves(E,D,A)) : speeds(A) } 1 :- result(O,moves(E,D)).
%% 1 {replace(O,move_towards(E,E2),move_towards(E,E2,A)) : speeds(A) } 1 :- result(O,move_towards(E,E2)).
%% 1 {replace(O,move_away(E,E2),move_away(E,E2,A)) : speeds(A) } 1 :- result(O,move_away(E,E2)).

:- replace(result(O,increase(R)),result(O,increase(R,R))).
:- replace(result(O,decrease(R)),result(O,decrease(R,R))).
:- replace(precondition(ge(R),O),precondition(ge(R,R),O)).
:- replace(precondition(le(R),O),precondition(le(R,R),O)).
:- replace(result(O,increase(R)),result(O,increase(R,0))).
:- replace(result(O,decrease(R)),result(O,decrease(R,0))).


:- result(O, mode_change(M)),
   replace(precondition(le(R),O),precondition(le(R,A),O)), A != 0.

:- result(O, mode_change(M)),
   replace(precondition(ge(R),O),precondition(ge(R,A),O)), A != high.

:- result(O, mode_change(M)),
   replace(precondition(ge(R),O),precondition(ge(R,A),O)),
   2 { replace(precondition(ge(R),_),precondition(ge(R,A),_))}.

:- result(O, mode_change(M)),
   replace(precondition(le(R),O),precondition(le(R,A),O)),
   2 { replace(precondition(le(R),_),precondition(le(R,A),_))}.
