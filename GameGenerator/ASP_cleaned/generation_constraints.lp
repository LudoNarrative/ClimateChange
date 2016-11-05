
:- outcome(o(N)), N > 2, not outcome(o(N-1)).
:- resource(r(N)), N > 2, not resource(r(N-1)).
:- entity(e(N)), N > 2, not entity(e(N-1)).
:- timer(t(N)), N > 2, not timer(t(N-1)).


:- outcome(O), not has_precondition(O).
:- outcome(O), not has_result(O).

:- 2 {precondition(C,tick)}.

   
:- every_frame(O), precondition(overlaps(E,_,true),O), result(O,delete(E)).
:- every_frame(O), precondition(overlaps(_,E,true),O), result(O,delete(E)).

:- every_frame(O), precondition(compare(ge,R),O), result(O,modify(decrease,R)).
:- every_frame(O), precondition(compare(le,R),O), result(O,modify(increase,R)).


 
:- precondition(overlaps(E1,E2,_),O),
   precondition(control_event(_),O),
   1 { precondition(overlaps(E1,E2,_),_) } 1.


:- result(O,delete(E1)),
   not precondition(overlaps(_,E1,true),O),
   not precondition(overlaps(E1,_,true),O),
   not precondition(control_event(click(E1)),O).

% Don't have more than 1 control event per outcome
:- 2 {precondition(control_event(EVENT),OUTCOME) }, outcome(OUTCOME).     
:- not playerControls.

% Only 1 avatar
:-  avatar(ENTITY), 
    many(ENTITY).



% Don't check more than 1 collision
:- 2 {precondition(overlaps(E1,E2,POLARITY),OUTCOME)}, outcome(OUTCOME).



% simply Don't have more than 2 preconditions
:- 3 {precondition(CONDITION,Outcome)}, outcome(Outcome).



different_precondition(O1,O2) :-
    precondition(P,O1),
    not precondition(P,O2),
    outcome(O2).
different_precondition(O1,O2) :-
    not precondition(P,O1),
    precondition(P,O2),
    outcome(O1).

:- has_precondition(O1),
   has_precondition(O2),
   not different_precondition(O1,O2),
   O1 != O2.


% Don't increase a resource on a positive check of it
:- result(Outcome,modify(increase,Resource)),
  precondition(compare(ge,Resource),Outcome).
% don't decrease a resource on negative check of it
:- result(Outcome,modify(decrease,Resource)),
   precondition(compare(le,Resource),Outcome).

:- spatial_condition(E1,E2), not moves(E1), not moves(E2).
