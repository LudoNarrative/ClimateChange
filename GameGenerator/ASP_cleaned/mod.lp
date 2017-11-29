
:- action(look_at(E1,E2,C)),
	static(E2).

:- frivolous(R), not allowed(frivolous(R)).


% Don't have more than 1 control event per outcome
:- 2 {precondition(control_event(EVENT),OUTCOME) }, outcome(OUTCOME) ,
   not precondition(control_event(click(_)),OUTCOME),
   not precondition(control_event(button(mouse,pressed)),OUTCOME). 



%player_doesnt_control :- not player_controls(_).
:- not player_controls(_), not condition(control_event(_)).


:- spatial_condition(E1,E2), not moves(E1), not moves(E2).

:- relative(greater,result(Outcome,modify(Direction,Resource)),result(Outcome,modify(Direction,Resource))).
:- read_only(Resource),
	action(modify(_,Resource)).
:- read_only(Resource),
	action(modify(_,Resource,_)).
% constraint on reachability
:- outcome(O), unreachableOutcome(O).


:- precondition(overlaps(E1,E2,_),O),
   precondition(control_event(_),O),
   1 { precondition(overlaps(E1,E2,_),_) } 1.
   
% only allow something to decrease on tick if it can be increased
:- 1 {result(tick, modify(decrease,R));
		result(tick, modify(decrease,R,_))},
	resource(R),
	0 {action(modify(increase,R));
		action(modify(increase,R,_))} 0.

:- 2{ result(O,modify(_,R)); 
		result(O,modify(_,R,_))}, 
		resource(R), outcome(O).

:- condition(compare(_,distance(E,E,_),_)).

:- player_controls(Entity),
	not condition(overlaps(Entity,_)),
	not condition(compare(distance(Entity,_,_),_)),
	not condition(compare(distance(_,Entity,_),_)),
	not condition(control_event(click(Entity))).

	
	
:- precondition(compare(POLARITY1,distance(E1,E2,Comparison),Amount), O1),
	result(O1,modify(_,_)).
	
:- precondition(compare(POLARITY1,distance(E1,E2,Comparison),Amount), O1),
	result(O1,modify(_,_,_)).

:- precondition(compare(POLARITY1,distance(E1,E2,Comparison),Amount), O1),
	result(O1,move(E,direction(forward))),
	result(O1,look_at(E,Other)),
	precondition(compare(POLARITY2,distance(E1,E2,Comparison),Amount), O2),
	result(O2,look_at(E,Other)),
	result(O2,move(E,direction(backward))).

:- boundary(torus),
   not torus_safe(O),
   result(O,look_at(E,_,_)),
   result(O,move(E,direction(left;right;forward;backward))).

:- boundary(torus),
   not torus_safe(O),
   result(O,look_at(E,_,_)),
   result(O,move(E,direction(left;right;forward;backward),Amount)).

:- boundary(torus), 
   result(tick,look_at(E,_,_)),
   result(tick,move(E,direction(left;right))).

% only allow something to decrease on tick if it can be increased
:- 1 {result(tick, modify(increase,R));
		result(tick, modify(increase,R,_))},
	resource(R),
	0 {action(modify(decrease,R));
		action(modify(decrease,R,_))} 0.

:- precondition(timer_elapsed(T),O),
	result(O,modify(_,_)).	

:- precondition(timer_elapsed(T),O),
	result(O,modify(_,_,_)).	
	
:- action(look_at(E,E,C)).

:- result(tick,look_at(E,_,_)),
	result(tick,move(E,direction(backward))).

:- action(modify(decrease,R,R)).

:- precondition(control_event(click(_)),O),
   not precondition(control_event(button(mouse,pressed)),O).

has_both(O) :-   precondition(control_event(click(_)),O),
		 precondition(control_event(button(mouse,pressed)),O).

:- 2 {precondition(control_event(_),O)},
   not has_both(O),
   outcome(O).


:- action(look_at(E1,E2,_)),
	action(look_at(E1,E2,_)),
	action(move(E1,direction(backward))),
	action(move(E2,direction(backward))).
	
:- 3 {precondition(control_event(_),O)},
   outcome(O).

:- N + 1 {precondition(_,_)},
   preconditions_allowed(N)  .