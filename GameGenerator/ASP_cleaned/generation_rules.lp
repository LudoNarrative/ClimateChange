moving(Entity) :- result(_,move(Entity,_)).
moving(Entity) :- controlLogic(draggable(Entity)).

static(Entity) :- entity(Entity), not moving(Entity).

outcome(O) :- result(O,_).
action(A) :- result(_,A).


has_precondition(O) :- precondition(_,O).
has_result(O) :- result(O,_).
condition(Condition) :- precondition(Condition,_).

every_frame(O) :- precondition(tick,O).
 
every_frame(O) :- not not_every_frame(O), precondition(C,O).

not_every_frame(O) :- precondition(control_event(click(E)),O).
not_every_frame(O) :- precondition(control_event(button(B,pressed)),O).
not_every_frame(O) :- precondition(control_event(button(B,released)),O).
not_every_frame(O) :- precondition(timer_elapsed(T),O) .
not_every_frame(O) :- precondition(overlaps(E),O),
		      result(O,delete(E)).

%players must have controls or it's just a weird movie
playerControls :- precondition(control_event(EVENT),OUTCOME).
playerControls :- controlLogic(_).

player_controls(Entity) :-  controlLogic(draggable(Entity)).
player_controls(Entity) :-  action(move(Entity,direction(_,cursor))).
player_controls(Entity) :-  action(look_at(Entity,cursor,_)).
%player_controls(Entity) :-  result(Outcome,move(Entity,direction(_,_))),
%			    precondition(control_event(EVENT),Outcome).

computer_controls(Entity) :- not player_controls(Entity),
			     entity(Entity),
			     not static(Entity).

player_controls_outcome(O) :- precondition(overlaps(E),O),
			      player_controls(E).
player_controls_outcome(O) :- precondition(control_event(E),O).


spatial_condition(E1,E2) :- precondition(overlaps(E1,E2,P),O).
spatial_condition(E2,E1) :- precondition(overlaps(E1,E2,P),O).



moves(E) :- result(_,move(E,_)).
moves(E) :- controlLogic(draggable(E)).


precondition(overlaps(Entity),Outcome) :-  precondition(overlaps(Entity,_,_),Outcome).
precondition(overlaps(Entity),Outcome) :-  precondition(overlaps(_,Entity,_),Outcome).


required(Entity) :- condition(control_event(click(Entity))).
required(Entity) :- condition(overlaps(Entity)).
required(Entity) :- result(_,apply_restitution(Entity,_)).
required(Entity) :- result(_,apply_restitution(_,Entity)).

% a resource is free if there is a way to decrease/increase not conditioned on the same resource - i.e. some way to change things
freeResource(Change,Resource) :- 
    resource(Resource), 
    result(Outcome,modify(Change,Resource)),
    not precondition(compare(_,_),Outcome),
    outcome(Outcome).

%or if it's conditioned in the proper way on a free resource
freeResource(Change,Resource) :- 
    resource(Resource), 
    result(Outcome,modify(Change,Resource)),
    precondition(compare(ge,Resource2),Outcome),
    freeResource(increase,Resource2),
    outcome(Outcome).

freeResource(Change,Resource) :- 
    resource(Resource), 
    result(Outcome,modify(Change,Resource)),
    precondition(compare(le,Resource2),Outcome),
    freeResource(decrease,Resource2),
    outcome(Outcome).


reachableCondition(control_event(E))  :-
    condition(control_event(E)).

reachableCondition(tick)  :-
    condition(tick).

reachableCondition(timer_elapsed(T)) :-
    condition(timer_elapsed(T)).

reachableCondition(overlaps(E1,E2,POLARITY)) :-
    reachableCondition(overlaps(E1)),
    condition(overlaps(E1,E2,POLARITY)).

reachableCondition(overlaps(E1,E2,POLARITY)) :-
    reachableCondition(overlaps(E2)),
    condition(overlaps(E1,E2,POLARITY)).

reachableCondition(overlaps(E1,E2,POLARITY)) :-
    action(move(E1,direction(towards,E2))),
    condition(overlaps(E1,E2,POLARITY)).

reachableCondition(overlaps(E1,E2,POLARITY)) :-
    action(move(E2,direction(towards,E1))),
    condition(overlaps(E1,E2,POLARITY)).

reachableCondition(collide(E1,E2)) :- reachableCondition(overlaps(E1,E2,P)).

ignoredCondition(overlaps(Entity)) :- condition(overlaps(Entity)).

reachableCondition(overlaps(Entity)) :-
    player_controls(Entity).

reachableCondition(compare(ge,Resource)) :-
    action(modify(increase,Resource)).
reachableCondition(compare(le,Resource)) :-
    action(modify(decrease,Resource)).


unreachableCondition(Condition) :- condition(Condition),
				   not reachableCondition(Condition).

unreachableOutcome(Outcome) :- precondition(Condition,Outcome),
			       unreachableCondition(Condition),
			       not ignoredCondition(Condition).

reachableOutcome(Outcome) :- outcome(Outcome),
			     not unreachableOutcome(Outcome).

only_one_precondition(Outcome) :- 1 {precondition(_,Outcome)} 1, outcome(Outcome).

    
balanced(property(Property,E)) :- action(modify(increase,property(Property,E))),
                                  action(modfiy(decrease,property(Property,E))).
                                  
frivolous(Resource) :- not condition(compare(_,Resource)),
                        resource(Resource).


constant(Entity) :- entity(Entity),
		    not action(add(Entity,_,_)),
		    not action(delete(Entity)).

monotonic(Entity,increase) :- 
    action(add(Entity,_,_)),
    not action(delete(Entity)).
monotonic(Entity,decrease) :- 
    not action(add(Entity,_,_)),
    action(delete(Entity)).

monotonic(Entity) :- monotonic(Entity,_).

non_monotonic(Entity) :- not monotonic(Entity),
			 entity(Entity).
			     


super_trivial(Outcome) :- precondition(control_event(_),Outcome),
		    1 {precondition(_,Outcome)} 1.

super_trivial(Outcome) :- precondition(timer_elapsed(_),Outcome),
		    1 {precondition(_,Outcome)} 1.
super_trivial(tick).

trivial(O) :- super_trivial(O).

trivial(Outcome) :- precondition(overlaps(E1,E2,_),Outcome),
		    2 { player_controls(E1);
			player_controls(E2);
			static(E1);
			static(E2)},
		    every_frame(Outcome).

trivial(Outcome) :- precondition(overlaps(E1,E1,_),Outcome),
		    player_controls(E1),
		    every_frame(Outcome).

hand_eye_coordination(Outcome) :- precondition(overlaps(E), Outcome),
				  computer_controls(E).
		    

hand_eye_coordination(Outcome) :- precondition(control_event(click(E)), Outcome),
				  computer_controls(E).

difficult(Outcome) :-
    precondition(overlaps(E),Outcome),
    precondition(control_event(click(E)), Outcome),
    computer_controls(E).

	
different_movement(E1,E2) :- action(move(E1,W)), not action(move(E2,W)), entity(E2).
different_movement(E1,E2) :- action(look_at(E1,T,W)), not action(look_at(E2,T,W)), entity(E2).
different_movement(E1,E2) :- action(rotate_to(E1,D)), not action(rotate_to(E2,D)), entity(E2).
different_movement(E1,E2) :- action(rotates(E1,D,_)), not action(rotates(E2,D,_)), entity(E2).
different_movement(E1,E2) :- controlLogic(draggable(E1)), not controlLogic(draggable(E2)), entity(E2).
different_movement(E1,E2) :- different_movement(E2,E1).

same_movement(E1,E2) :- entity(E1), entity(E2), not different_movement(E1,E2).



	