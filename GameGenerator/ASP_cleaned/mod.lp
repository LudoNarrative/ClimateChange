
    
:- action(move(Entity,direction(away,_))),
   not action(apply_restitution(Entity,Entity)).



:- action(move(Entity,direction(towards,_))),
   not action(apply_restitution(Entity,Entity)).

:- action(move(Entity,direction(towards,Other))),
   not action(apply_restitution(Entity,Other)).


:-  precondition(overlaps(E1,E2,POLARITY),O),
    precondition(control_event(click(E3)),O).
    
:- outcome(outcome(o(N))), N >= 2, not outcome(outcome(o(N-1))).
:- resource(resource(r(N))), N >= 2, not resource(resource(r(N-1))).
:- entity(entity(e(N))), N >= 2, not entity(entity(e(N-1))).
:- timer(timer(t(N))), N >= 2, not timer(timer(t(N-1))).


:- outcome(O), not has_precondition(O).
:- outcome(O), not has_result(O).

:- 2 {precondition(C,tick)}.

   
:- every_frame(O), precondition(compare(ge,R),O), result(O,modify(decrease,R)).
:- every_frame(O), precondition(compare(le,R),O), result(O,modify(increase,R)).

:- result(tick,move(E,direction(_,E))).


:- condition(overlaps(entity(e(N)),entity(e(N2)),_)),
   N2 < N.

:- precondition(overlaps(E1,E2,_),O),
   precondition(control_event(_),O),
   1 { precondition(overlaps(E1,E2,_),_) } 1.

:- precondition(overlaps(E1,E2,true),O1),
   result(O1,delete(entity(E))),
   precondition(overlaps(E1,E2,true),O2),
   precondition(control_event(C),O2),
   O1 != O2.


:- result(O,delete(E1)),
   not precondition(overlaps(_,E1,true),O),
   not precondition(overlaps(E1,_,true),O),
   not precondition(control_event(click(E1)),O).

% Don't have more than 1 control event per outcome
:- 2 {precondition(control_event(EVENT),OUTCOME) }, outcome(OUTCOME).     
:- not playerControls.

%AJS - GETTING RID OF THIS Only 1 avatar
%:-  avatar(ENTITY), 
%    many(ENTITY).



% Don't check more than 1 collision
:- 2 {precondition(overlaps(E1,E2,POLARITY),OUTCOME)}, outcome(OUTCOME).



% simply Don't have more than 2 preconditions
:- 5 {precondition(CONDITION,Outcome)}, outcome(Outcome).



%% different_precondition(O1,O2) :-
%%     precondition(P,O1),
%%     not precondition(P,O2),
%%     outcome(O2).
%% different_precondition(O1,O2) :-
%%     not precondition(P,O1),
%%     precondition(P,O2),
%%     outcome(O1).

different_precondition(O1,O2) :-
    1 {precondition(P,O1);precondition(P,O2)} 1,
    condition(P),
    outcome(O1),
    outcome(O2).

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

  
% require entities
:- entity(Entity), not required(Entity).

% only destroy that which you can create
:-  required(Entity),
   action(delete(Entity)),
   not action(add(Entity,_,_)).


% only allow something to decrease on tick if it can be increased
:- result(tick, modify(decrease,R)),
   not action(modify(increase,R)).


% Don't check more than 1 collision
:- 2 {precondition(overlaps(E1,E2,POLARITY),OUTCOME)}, outcome(OUTCOME).



:- resource(Resource), not freeResource(_,Resource).


% simple feedback loop exclusion
% Don't increase a resource on a positive check of it
:- result(Outcome,modify(increase,Resource)),
  precondition(compare(ge,Resource),Outcome).
% don't decrease a resource on negative check of it
:- result(Outcome,modify(decrease,Resource)),
   precondition(compare(le,Resource),Outcome).


:- action( add(Entity,_,_)), singular(Entity).


% constraint on reachability
:- outcome( O), unreachableOutcome(O).