
% only allow something to decrease on tick if it can be increased
:- 1 {result(tick, modify(decrease,R));
		result(tick, modify(decrease,R,_))},
	resource(R),
	0 {action(modify(increase,R));
		action(modify(increase,R,_))} 0.

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


:- spatial_condition(E1,E2), not move(E1), not move(E2).





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

:- 2{ result(O,modify(_,R)); 
		result(O,modify(_,R,_))}, 
		resource(R), outcome(O).

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
   
{label(entity(E),E)} :- entity(entity(E)).
{label(resource(E),E,private)} :- resource(resource(E)).
:- 2 {label(E,_)}, entity(E).
:- 2 {label(E,_,_)}, resource(E).
:- entity(E), not label(E,_).
:- resource(E), not label(E,_,_).

:-  controlLogic(draggable(E)),
    action(move(E,_)).

:- precondition(control_event(click(E)),O),
   precondition(overlaps(E),O),
   computer_controls(E).


:- trivial(O),
   player_model(O,player_will_avoid).

   

:- not over_time(Change,Resource),
   precondition(compare(Dir,Resource),O),
   player_model(O,player_will_attempt),
   satisfies(Dir,Change).

    

%:-  precondition(overlaps(E1,E2,POLARITY),O),
%    precondition(control_event(click(E3)),O).
    
:- outcome(outcome(o(N))), N >= 2, not outcome(outcome(o(N-1))).
:- resource(resource(r(N))), N >= 2, not resource(resource(r(N-1))).
:- entity(entity(e(N))), N >= 2, not entity(entity(e(N-1))).
:- timer(t(N)), N >= 2, not timer(t(N-1)).


:- 2 {precondition(C,tick)}.

   
:- every_frame(O), precondition(compare(ge,R),O), result(O,modify(decrease,R)).
:- every_frame(O), precondition(compare(le,R),O), result(O,modify(increase,R)).

:- every_frame(O), precondition(compare(ge,R),O), result(O,modify(decrease,R,_)).
:- every_frame(O), precondition(compare(le,R),O), result(O,modify(increase,R,_)).
:- result(tick,move(E,direction(direction(_)))).


:- condition(overlaps(entity(e(N)),entity(e(N2)),_)),
   N2 < N.

:- action(move(entity(e(E1)),direction(_,entity(e(E2))))),
   E2 < E1.

% THIS WAS A BAD ONE
%:- not condition(control_event(click(entity(e(E1))))),
%   condition(control_event(click(entity(e(E2))))),
%   entity(entity(e(E1))),
%   E1 < E2.


:- precondition(overlaps(E1,E2,true),O1),
   result(O1,delete(entity(E))),
   precondition(overlaps(E1,E2,true),O2),
   precondition(control_event(C),O2),
   O1 != O2.



:- result(O,delete(E1)),
   not precondition(overlaps(_,E1,true),O),
   not precondition(overlaps(E1,_,true),O),
   not precondition(control_event(click(E1)),O).
    
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



  
% require entities
:- entity(Entity), not required(Entity).

% only destroy that which you can create, if it isn't intended to be depleted
:-  required(Entity),
   action(delete(Entity)),
   not action(add(Entity,_,_)),
   not reading(Entity,depletable).

:- action(add(Entity,_,_)),
   not action(delete(Entity)).



% Don't check more than 1 collision
:- 2 {precondition(overlaps(E1,E2,POLARITY),OUTCOME)}, outcome(OUTCOME).



%:- resource(Resource), not freeResource(_,Resource).


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


:- action( add(Entity,_,_)), singular(Entity).




% Don't let something move away from the cursor if we need to click on it.
%:- result(O, move(E, direction(away,cursor))),
%   condition(control_event(click(E))).



:- entity(entity(e(N))),
   not colors(C,N),
   initialize(set_color(entity(e(N)),C)).


:- 2 {controlScheme(ENTITY,SCHEME)},
   entity(ENTITY).

:- chases(ENTITY,ENTITY).

:- flees(ENTITY,ENTITY).

:- outcome(Outcome), not player_model(Outcome,_).

:- entity(E), not structure(_,E).

:- structure(S,_), 2 {structure(S,_)}.

:-  precondition(_,O),
    result(O,add(E,_,location(Y,X))),
    not spawnsAtInitial(E).


%:- resource(R),
%   not reading_about(R).
%:- entity(E),
%   not reading_about(E).


:- reading(grinding,Resource),
   result(Outcome,modify(_,Resource)),
   not player_controls_outcome(Outcome).


:- precondition(overlaps(entity(_)),Outcome),
	result(Outcome,move(_,_)).



%%%DONT GET STUCK ON WALLS

:- precondition(timer_elapsed(T),O),
   result(O,rotates(E,_,_)),
   speed(E,tick,scalar(V)),
   timer_logic(timer(T),scalar(DT),loop),
   60*DT*V > 200.



%If the player wants E1 and E2 to touch, and controls E1, E1 should be faster than E2.
:- precondition(overlaps(E1,E2,true),O),
   player_model(O,player_will_attempt),
   speed(E1,_,scalar(S1)),
   speed(E2,_,scalar(S2)),
   action(move(E2,direction(away,E1))),
   S2 > S1,
   player_controls(E1).


%If the player wants E1 and E2 to touch, and controls E2, E2 should be faster than E1.
:- precondition(overlaps(E1,E2,true),O),
   player_model(O,player_will_attempt),
   speed(E1,_,scalar(S1)),
   speed(E2,_,scalar(S2)),
   action(move(E1,direction(away,E2))),
   S2 < S1,
   player_controls(E2).

%If the player doesn't want E1 and E2 to touch, and controls E1, E1 should be faster than E2.
:- precondition(overlaps(E1,E2,true),O),
   player_model(O,player_will_avoid),
   speed(E1,_,scalar(S1)),
   speed(E2,_,scalar(S2)),
   action(move(E2,direction(towards,E1))),
   S1 < S2,
   player_controls(E1).

%If the player doesn't want E1 and E2 to touch, and controls E2, E2 should be faster than E1.
:- precondition(overlaps(E1,E2,true),O),
   player_model(O,player_will_avoid),
   speed(E1,_,scalar(S1)),
   speed(E2,_,scalar(S2)),
   action(move(E1,direction(towards,E2))),
   S2 < S1,
   player_controls(E2).


trivial_resource(DIR,RESOURCE) :- result(O,modify(DIR,RESOURCE)), trivial(O).

trivial_resource(DIR,RESOURCE) :- result(O,modify(DIR,RESOURCE,_)), trivial(O).


% don't allow for "running out of gas" unless there's a trivial way to get gas
:- precondition(compare(ge,R),O),
   player_model(O,player_will_attempt),
   not trivial_resource(increase,R).
% don't allow for "running out of gas" unless there's a trivial way to get gas
:- precondition(compare(le,R),O),
   player_model(O,player_will_attempt),
   not trivial_resource(decrease,R).
   
   
  


:- monotonic(R), not allowed(monotonic(R)).

:-  in_corner(E), not allowed(in_corner(E)).


:- result(O,add(E,_,_)),
   result(O2,add(E,_,_)),
   result(O2,delete(E)),
   1 {result(_,delete(E))} 1,
   O != O2.

%It shouldn't be the case that the only way that a player controls something is by making it move towards (or away) from itself
:- player_controls(E),
   action(move(E,direction(_,E))),
   1 {action(move(E,_))} 1,
   1 {player_controls(_)} 1.


player_controls_resource(R,Dir) :-
    result(O,modify(R,Dir)),
    player_controls(O).

player_controls_resource(R,Dir) :-
    result(O,modify(R,Dir,_)),
    player_controls(O).
:- resource(R),
   precondition(compare(R,_),O),
   player_controls(O),
   not player_controls_resource(R,_).
   
:- monotonic(R), not allowed(monotonic(R)).


:- result(O,delete(E)),
   1 { result(O,move(E,_));
       result(O,rotates(E,_));
       result(O,rotate_to(E,_));
       result(O,look_at(E,_,_))}.
:- condition(overlaps(E1,E2,_)),
   not chasing_safe(E1,E2).


%%SIMPLICITY

:- 3 {precondition(overlaps(E1,E2,POLARITY),OUTCOME)},
    entity(E1),
    entity(E2),
    polarity(POLARITY).


:- 2 {result(O,add(E,_,_))}, outcome(O).

:- 3 {precondition(_,Outcome)},
   outcome(Outcome),
   not has_overlaps(Outcome).
:- 6 {precondition(_,Outcome)},
   outcome(Outcome).

:- 4 {result(Outcome,_)},
   outcome(Outcome),
   Outcome != tick.



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

%%%COLOR

%DONT DOUBLE FILL
:- initialize(fill(all,_)),
   initialize(fill(location(_,_),_)).

:- clear(_),   
   0 {initialize(fill(all,_));
      initialize(fill(location(_,_),_));
      action(draw(_,_))} 0.

:- 2{initialize(fill(location(R,C),_))},
   row(R),
   col(C).



:- condition(compare(_,_,amount(Color))),
   not uses_color(Color).

:- condition(over_color(_,Color)),
   not uses_color(Color).


:- not uses_color,
   action(clear(_)).

:- uses_color(Color),
   not condition(compare(_,amount(Color),_)),
   not condition(over_color(_,Color)).

:- 2 {precondition(compare(_,amount(Color),_),O)}.

%:- condition(compare(_,amount(Color),_)).


:- result(outcome(_),delete(E)),
   result(outcome(_),rotates(E,_,_)).

:- result(outcome(_),delete(E)),
   result(outcome(_),rotate_to(E,_)).

:- result(outcome(_),delete(E)),
   result(outcome(_),look_at(E,_)).


:- precondition(compare(_,amount(Color),_),O),
   result(O,move(E,_)).


:- precondition(overlaps(E1,E2,true),O1),
   2 { precondition(overlaps(E1,E2,true),_)},
   result(O1,delete(E1)),
   only_one_precondition(O1).

:- precondition(overlaps(E1,E2,true),O1),
   2 { precondition(overlaps(E1,E2,true),_)},
   result(O1,delete(E2)),
   only_one_precondition(O1).

   
