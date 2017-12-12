%%%%%%% SHOULDN"T HAVE TO CHANGE

:- N + 1 {precondition(_,_)},
   preconditions_allowed(N)  .

:- action(modify(decrease,property(E,health))),
   outcome_doesnt_require(O,E),
   result(O,add(E,_,_)).

:- 2 {precondition(C,tick)}.

:- trivial(O),
   player_model(O,player_will_avoid).
   
% simple feedback loop exclusion
% Don't increase a resource on a positive check of it
:- result(Outcome,modify(increase,Resource)),
  precondition(compare(ge,Resource),Outcome).
% don't decrease a resource on negative check of it
:- result(Outcome,modify(decrease,Resource)),
   precondition(compare(le,Resource),Outcome).

% Don't increase a resource on a positive check of it
:- result(Outcome,modify(increase,Resource,_)),
  precondition(compare(ge,Resource),Outcome).
% don't decrease a resource on negative check of it
:- result(Outcome,modify(decrease,Resource,_)),
   precondition(compare(le,Resource),Outcome).

:- result(O,delete(E1)),
   not precondition(overlaps(_,E1,true),O),
   not precondition(overlaps(E1,_,true),O),
   not precondition(control_event(click(E1)),O).

:- outcome(O), not has_precondition(O).
:- outcome(O), not has_result(O).

:- monotonic(R), not allowed(monotonic(R)).
:- result(O,mode_change(_)),
   2 {result(O,_)}.


has_both(O) :-   precondition(control_event(click(_)),O),
		 precondition(control_event(button(mouse,pressed)),O).

:- 2 {precondition(control_event(_),O)},
   not has_both(O),
   outcome(O).


:- precondition(timer_elapsed(_),O),
   2{ precondition(_,O)}.


:- precondition(compare(_,distance(_,_,_),_),O),
   result(O,draw(_,_)).

:- precondition(compare(_,distance(_,_,_),_),O),
   result(O,clear(_)).


:- precondition(overlaps(_,_,_),O),
   result(O,draw(_,_)).

:- precondition(overlaps(_,_,_),O),
   result(O,clear(_)).

:- 2 {precondition(compare(_,amount(Color),_),O)}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%DONT DOUBLE FILL
:- initialize(fill(all,_)),
   initialize(fill(location(_,_),_)).

:- action(clear(_)),   
   0 {initialize(fill(all,_));
      initialize(fill(location(_,_),_));
      action(draw(_,_))} 0.

:- 2{initialize(fill(location(R,C),_))},
   row(R),
   col(C).

:- precondition(compare(le,amount(C),_),O),
   result(O,mode_change(_)),
   not initialize(fill(all,C)).
   
:- condition(compare(_,_,amount(Color))),
   not uses_color(Color).

:- condition(over_color(_,Color)),
   not uses_color(Color).


:- not uses_color,
   action(clear(_)).

:- uses_color(Color),
   not condition(compare(_,amount(Color),_)),
   not condition(over_color(_,Color)).


:- reading(good,O),
   trivial(O),
   not entity_related(O).
    
:- outcome(O1), outcome(O2), not different_precondition(O1,O2), O1 != O2.


:-  result(Outcome,mode_change(game_loss;narrative_gating)),
    player_controls_outcome(Outcome).

:- condition(overlaps(E1,E2,_)),
   not chasing_safe(E1,E2).

:- precondition(C1,O1),
   requires(C1,E1),
   result(O1,add(E2,_,_)),
   precondition(C2,O2),
   requires(C2,E2),
   result(O2,add(E1,_,_)).

:- precondition(control_event(click(E)),O),
   result(O,delete(E)).

:- precondition(control_event(C),O),
   precondition(compare(_,distance(_,_,_),_),O).




:- precondition(control_event(click(E)),O),
   controlLogic(draggable(E)).

:- precondition(control_event(click(E)),O),
   initialize(set_draggable(E),true).



:- 2 {action(draw(E,C));
      action(clear(E))},
   entity(E).

:- result(O,mode_change(_)),
   precondition(compare(_,_),O),
   precondition(compare(_,_,_),O).

:- result(O,mode_change(_)),
   not precondition(overlaps(_),O),
   not precondition(compare(_,_),O),
   not precondition(compare(_,_,_),O).


:- 2 {precondition(compare(_,distance(_,_,_),_),O)},
   outcome(O).

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