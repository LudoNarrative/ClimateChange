%%%%%%% SHOULDN"T HAVE TO CHANGE


:- 2 {precondition(C,tick)}.

   
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


:- action(look_at(E1,E2,_)),
	action(look_at(E1,E2,_)),
	action(move(E1,direction(backward))),
	action(move(E2,direction(backward))).
	
:- 3 {precondition(control_event(_),O)},
   outcome(O).

:- N + 1 {precondition(_,_)},
   preconditions_allowed(N)  .

:- behavior(ENTITY,B), controlScheme(ENTITY,C).


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
   trivial(Outcome),
   not entity_related(Outcome).

:- player_model(Outcome,player_will_avoid),
   trivial(Outcome),
   not entity_related(Outcome).


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


:- action(apply_restitution(E,E)),
   static(E).


:- condition(overlaps(E1,E2,true)),
   action(look_at(E1,E2,_)),
   {action(move(E1,_))} 1.


:- condition(overlaps(E1,E2,true)),
   action(look_at(E1,E2,_)),
   {action(move(E2,_))} 1.

  
:- precondition(overlaps(E1,E2,_),O),
	result(O,look_at(_,_,_)).		
   
:- precondition(overlaps(E1,E2,_),O),
	result(O,move(_,_)).		

:- precondition(overlaps(E1,E2,_),O),
	result(O,rotates(_,_,_)).		
      
:- precondition(overlaps(E1,E2,_),O),
	result(O,rotate_to(_,_)).	
   

:- result(O,move(E,direction(D1))),
	result(O,move(E,direction(D2))),
	opposite(D1,D2).
	
	
:- precondition(overlaps(_,_,false),O),
	result(O,modify(_,property(_,_))).
	


:- precondition(overlaps(E1,E2,_),Outcome),
	player_controls(E1),
	speed(E1,_,S1),
	speed(E2,_,S2),
	S1 <= S2.
	
:- precondition(overlaps(E2,E1,_),Outcome),
	player_controls(E1),
	speed(E1,_,S1),
	speed(E2,_,S2),
	S1 <= S2.
	
	
:- action(modify(decrease,property(E,health))),
   not action(add(E,_,_)).