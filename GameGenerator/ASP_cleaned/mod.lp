
% only allow something to decrease on tick if it can be increased
:- 1 {result(tick, modify(decrease,R));
		result(tick, modify(decrease,R,_))},
	resource(R),
	0 {action(modify(increase,R));
		action(modify(increase,R,_))} 0.

:- 2{ result(O,modify(_,R)); 
		result(O,modify(_,R,_))}, 
		resource(R), outcome(O).


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

 
:- action(look_at(E1,E2,C)),
	static(E2).

% constraint on reachability
:- outcome(O), unreachableOutcome(O).


:- precondition(overlaps(E1,E2,_),O),
   precondition(control_event(_),O),
   1 { precondition(overlaps(E1,E2,_),_) } 1.

% Don't have more than 1 control event per outcome
:- 2 {precondition(control_event(EVENT),OUTCOME) }, outcome(OUTCOME) ,
   not precondition(control_event(click(_)),OUTCOME),
   not precondition(control_event(button(mouse,pressed)),OUTCOME). 

:- frivolous(R), not allowed(frivolous(R)).


:- spatial_condition(E1,E2), not moves(E1), not moves(E2).





:- relative(greater,result(Outcome,modify(Direction,Resource)),result(Outcome,modify(Direction,Resource))).




:- read_only(Resource),
	action(modify(_,Resource)).
:- read_only(Resource),
	action(modify(_,Resource,_)).
%:- read_only(Resource),
%   not condition(compare(_,Resource)).

%player_doesnt_control :- not player_controls(_).
:- not player_controls(_), not condition(control_event(_)).

:- behavior(ENTITY,B), controlScheme(ENTITY,C).

:- outcome(O), not has_precondition(O).
:- outcome(O), not has_result(O).

:- controlScheme(click_to_spin,Entity),
   many(Entity).

:- precondition(control_event(C),O),
	precondition(timer_elapsed(T),O).
	
:- action(move(Entity,direction(forward))),
   action(look_at(Entity,Other,_)),
   not result(tick,apply_restitution(Entity,Other)),
   entity(Other).

:- action(move(Entity,direction(forward))),
   action(look_at(Entity,Other,_)),
   not action(apply_restitution(Entity,Entity)).


:- action(move(Entity,direction(backward))),
   action(look_at(Entity,Other,_)),
   not action(apply_restitution(Entity,Entity)).


:- 2{precondition(compare(_,_),O)},
   outcome(O).

:- result(O,mode_change(_)),
   not precondition(overlaps(_),O),
   not precondition(compare(_,_),O).

:- only_one_precondition(O),
   precondition(compare(_,_),O),
   result(O,modify(_,_)).

:- only_one_precondition(O),
   precondition(compare(_,_),O),
   result(O,modify(_,_,_)).


:- 2 {controlScheme(E,_)}, 
	entity(E).



:-  action(move(E2,backward)),
    action(look_at(E2,E1,_)),
    action(move(E1,backward)),
    action(look_at(E1,E2,_)).


:- result(O,add(E,_,_)), every_frame(O).


%:- precondition(control_event(click(Entity)),Outcome),
%   precondition(overlaps(Entity),Outcome).


%:- precondition(overlaps(E,E,P),O),
%   not precondition(collide(E,E),O).



%Limitation of Phaser
:- precondition(control_event(_),O),
   precondition(overlaps(E1,E2,true),O),
   result(tick,apply_restitution(E1,E2)).



:- precondition(overlaps(_,_,false),O),
   result(O,mode_change(_)).



%Don't delete something if you click on it and it's also draggable
:-  controlLogic(draggable(E)),
    precondition(control_event(click(E)),O),
    result(O,delete(E)),
    only_one_precondition(O).


:- result(O,delete(E)),
   singular(E).


:- condition(overlaps(E,E,_)), singular(E).

:- result(O,mode_change(_)),
   2 {result(O,_)}.

:- result(O,mode_change(_)),
   not precondition(overlaps(_),O),
   not precondition(compare(_,_),O).


    
:-  result(Outcome,mode_change(game_loss;narrative_gating)),
    player_controls_outcome(Outcome).

:-  result(O,modify(_,property(E,_))),
    result(O,delete(E)).

:- condition(overlaps(entity(e(E1)),entity(e(E2)),POLARITY)),
    E2 < E1.
    
:- action(apply_restituion(entity(e(E1)),entity(e(E2)))),
    E2 < E1.
    
:-  precondition(control_event(click(E)),O),
    result(O,add(E,_,_)).
    

:- 5 { initialize(add(E,L,C))},
   entity(E).
   


:- precondition(overlaps(E1,E2,true),O),
   result(O,move(E1,_)).

:- precondition(overlaps(E1,E2,true),O),
   result(O,move(E2,_)).


:-  precondition(compare(ge,R),O),
    result(O,add(E,_,_)),
    precondition(overlaps(E),O2),
    1 {result(O2,modify(increase,R));
	result(O2,modify(increase,R,_))}.


:-  precondition(compare(le,R),O),
    result(O,add(E,_,_)),
    precondition(overlaps(E),O2),
    1 {result(O2,modify(decrease,R));
	result(O2,modify(decrease,R,_))}.


:- not condition(control_event(button(BUTTON1,_))),
   condition(control_event(button(BUTTON2,_))),
   buttonPriority(BUTTON1,BUTTON2).

:- precondition(overlaps(E1,E2,false),O),
   result(O,move(E1,direction(backward))),
   action(look_at(E1,E2,_)).

:- precondition(overlaps(E2,E1,false),O),
   result(O,move(E1,direction(backward))),
   action(look_at(E1,E2,_)).


:- result(outcome(avatar(M1)),A),
   not result(outcome(avatar(M2)),A),
   outcome(outcome(avatar(M2))),
   not movement(A).


:- 3{result(outcome(avatar(M)),A)}.



:- initialize(set_sprite(E1,S)),
   initialize(set_sprite(E2,S)),
   initialize(set_color(E1,C)),
   initialize(set_color(E2,C)),
   E1 != E2.
   
:- result(O,move(E,_)),
   result(O,delete(E)).


:- result(O,move(E,direction(D))),
    2 { result(O,move(E,direction(_))) }.
	
	
:- 2 {initialize(add(_,_,L))},
   initialize(add(_,_,L)).


:- player_model(Outcome,player_will_attempt),
   trivial(Outcome).

:- player_model(Outcome,player_will_avoid),
   trivial(Outcome).

:- initialize(set_color(E1,C)),
   initialize(set_color(E2,C)),
   initialize(set_sprite(E1,S)),
   initialize(set_sprite(E2,S)),
   E1 != E2.
   

:- player_controls(entity(e(E2))),
   not player_controls(entity(e(E1))),
   entity(entity(e(E1))),
   E1 < E2.


:- precondition(timer_elapsed(_),O1),
   1 {result(O1,modify(increase,R));result(O1,modify(increase,R,_))}, 
   precondition(timer_elapsed(_),O2),
   1 {result(O2,modify(decrease,R));result(O2,modify(decrease,R,_))}.

:- reading(good,O),
   trivial(O).