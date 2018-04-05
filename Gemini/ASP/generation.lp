
% * General and initialization
% Handled
number(N) :- N = 1.
%entity(e(N)) :- N = 1..min_entities.
{max_entity(M)} :- M =min_entities..max_entities.

% Ignored
palette(clear).
% Handled
entity(entity(e(M))) :- M = 1..N, max_entity(N).
% Handled
1 {initialize(set_sprite(Entity,Sprite)) : sprite(Sprite)} 1 :-
    entity(Entity).
% Handled
1 {initialize(set_color(Entity,Color)) : colors(Color)} 1 :-
    entity(Entity).
% Handled
1 { initialize(add(Entity,scalar(1),location(Row,Col))) : row(Row), col(Col) } 1 :-
    singular(Entity).
% Handled by deleting
1 { number_to_place(Entity,Number) : number(Number)} 1 :-
    many(Entity).
% Handled by modifying/implicit
1 { initialize(add(Entity,scalar(NumberToPlace),location(Row,Col))) : row(Row), col(Col) } :-
    many(Entity),
    number_to_place(Entity,NumberToPlace).
% Handled implicitly
{initialize(fill(all,Color))} :- palette(Color).
{initialize(fill(location(Row,Col),Color)) : row(Row), col(Col)} :- palette(Color).

% Handled
boundary_types(torus;closed).

1 {boundary(Type) : boundary_types(Type) } 1.
% Handled
speed_values(3;5;7).
speed_values(R) :- resource(R).
% Handled
angle_speeds(1;5;10).
angle_speeds_discrete(60,90,180). % Shouldnt these be separated by semicolons, not commas?

% Handled by looking at fastest mode
1 {speed(E,O,S) : speed_values(S)} 1 :-
    entity(E),
    not static(E),
    result(O,move(E,_)).
% Ignored
:- speed(E,O,7),
   action(look_at(E,_,_)),
   result(O,move(E,direction(left;right))).
% Handled by translation to initial_count
total_count(Entity,N) :- N = PerPlace*Places,
			 number_to_place(Entity,PerPlace),
			 Places = {initialize(add(Entity,_,_))},
			 entity(Entity).

% Handled
{max_resource(M)} :- M = min_resources..max_resources.

resource(resource(r(M))) :- M = 1..min_resources..N, max_resource(N).

% Handled
{max_outcome(M)} :- M = min_outcomes..max_outcomes.
standard_outcome(outcome(o(M))) :- M = 1..N, max_outcome(N).
{outcome(tick)}.

outcome(O) :- standard_outcome(O).
% Handled
{max_timer(M)} :- M = min_timers..max_timers.

timer(t(M)) :- M = 1..N, max_timer(N).

timer_values(3;5;7).
1 {timer_logic(timer(T),scalar(N),loop): timer_values(N)} 1 :- timer(T).


%%% * USER INPUT SCHEMES %%%


{ avatar(entity(e(1))) }.

% ** TODO NYI
directControls(asteroids;
		tank;
		vertical;
		horizontal;
		cardinal).
% Why isnt 'platformer' here?
%
1 { controlScheme(ENTITY,SCHEME) : directControls(SCHEME)} 1 :- avatar(ENTITY).

outcome(outcome(avatar(move_up))) :- 
    1 {controlScheme(ENTITY,cardinal); 
    controlScheme(ENTITY,vertical)}.
outcome(outcome(avatar(move_down))) :- 
    1 {controlScheme(ENTITY,cardinal); 
    controlScheme(ENTITY,vertical)}.

% Need to move west if horizontal axis
outcome(outcome(avatar(move_left))) :- 
    1 {controlScheme(ENTITY,cardinal); 
    controlScheme(ENTITY,horizontal); 
    controlScheme(ENTITY,platformer)}.
outcome(outcome(avatar(move_right))) :- 
    1 {controlScheme(ENTITY,cardinal); 
    controlScheme(ENTITY,horizontal); 
    controlScheme(ENTITY,platformer)}.		

% Asteroids/combat tank moving forward
outcome(outcome(avatar(move_forward))) :- 
    1 {controlScheme(ENTITY,tank); 
    controlScheme(ENTITY,asteroids)}.

% Tanks can go backwards, spaceships cannot
outcome(outcome(avatar_move_backward)) :- controlScheme(ENTITY,tank).
    
% Tanks and spaceships can rotate
outcome(outcome(avatar(rotate_right))) :- 
    1{controlScheme(ENTITY,tank); 
    controlScheme(ENTITY,asteroids)}.
outcome(outcome(avatar(rotate_left))) :- 
    1{controlScheme(ENTITY,tank); 
      controlScheme(ENTITY,asteroids)}.


% Create precondition-result rules for each avatar movement:
% move_up/down/right/left/forward/backward rotate_right/left 


% Moving north 
precondition(control_event(button(up_arrow, held)),outcome(avatar(move_up))) :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(move_up))).
result(outcome(avatar(move_up)),move(ENTITY, direction(north))) :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(move_up))).

% Moving south 
precondition(control_event(button(down_arrow, held)),outcome(avatar(move_down))) :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(move_down))).
result(outcome(avatar(move_down)),move(ENTITY, direction(south))) :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(move_down))).

% Moving east 
precondition(control_event(button(right_arrow, held)),outcome(avatar(move_right))) :- 
    avatar(ENTITY), 
   outcome( outcome(avatar(move_right))).
result(outcome(avatar(move_right)),move(ENTITY, direction(east) )) :- 
    avatar(ENTITY), 
   outcome( outcome(avatar(move_right))).

% Moving west 
precondition(control_event(button(left_arrow, held)),outcome(avatar(move_left))) :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(move_left))).
result(outcome(avatar(move_left)),move(ENTITY, direction(west) )) :- 
    avatar(ENTITY),
    outcome(outcome(avatar(move_left))).

% Moving forward
precondition(control_event(button(up_arrow, held)),outcome(avatar(move_forward))) :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(move_forward))).
% precondition(empty(ENTITY,forward,low),outcome(avatar(move_forward)) :- 
    % avatar(ENTITY), 
    % outcome(outcome(avatar(move_forward)).
result(outcome(avatar(move_forward)),move(ENTITY, direction(forward))) :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(move_forward))).

% Moving backwards
precondition(control_event(button(down_arrow, held)),outcome(avatar(move_backward))) :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(move_backward))).
% precondition(empty(ENTITY,behind,low),outcome(avatar(move_backward)) :- 
    % avatar(ENTITY), 
    % outcome(outcome(avatar(move_backward)).
result(outcome(avatar(move_backward)),move(ENTITY, direction(behind))) :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(move_backward))).

% Rotate counter clockwise
precondition(control_event(button(left_arrow, held)),outcome(avatar(rotate_left))) :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(rotate_left))).
result(outcome(avatar(rotate_left)),rotates(ENTITY, ccw)) :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(rotate_left))).

% Rotate clockwise
precondition(control_event(button(right_arrow, held)),outcome(avatar(rotate_right))) :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(rotate_right))).
result(outcome(avatar(rotate_right)),rotates(ENTITY, cw)) :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(rotate_right))).

% ** TODO NYI, but in theory handled implicitly.  would like to delete controlScheme and controlLogic predicates.
indirectControls(click_and_drag;
	%click_and_click;
  %click_and_aim;
  orbit_the_cursor;
	drawn_to_cursor;
	repeled_from_cursor;
  click_to_spin;
	click_to_move;
	%click_to_chase;
	).

{controlScheme(ENTITY,SCHEME) : indirectControls(SCHEME)} 1 :- entity(ENTITY).


controlLogic(draggable(ENTITY)) :- controlScheme(ENTITY,click_and_drag).
outcome(outcome(drawn_to_cursor(ENTITY))) :- controlScheme(ENTITY,drawn_to_cursor).
outcome(outcome(repeled_from_cursor(ENTITY))) :- controlScheme(ENTITY,repeled_from_cursor). 
outcome(outcome(click_to_spin(ENTITY))) :- controlScheme(ENTITY,click_to_spin).       
outcome(outcome(click_to_move(ENTITY))) :- controlScheme(ENTITY,click_to_move).  
outcome(outcome(click_to_chase(ENTITY))) :- controlScheme(ENTITY,click_to_chase).  
outcome(outcome(orbit_the_cursor(ENTITY))) :- controlScheme(ENTITY,orbit_the_cursor).  

  
% Drawn_to_cursor: Entity looks at and moves to cursor when mouse held
precondition(control_event(button(mouse, held)),outcome(drawn_to_cursor(ENTITY))) :- 
    outcome(outcome(drawn_to_cursor(ENTITY))). 
result(outcome(drawn_to_cursor(ENTITY)), move(ENTITY,direction(forward))) :-
    outcome(outcome(drawn_to_cursor(ENTITY))).
result(outcome(drawn_to_cursor(ENTITY)), look_at(ENTITY,cursor,nearest)) :-
    outcome(outcome(drawn_to_cursor(ENTITY))).

% Repelled_from_cursor: Entity looks at cursor and backs away
precondition(control_event(button(mouse, held)),outcome(repeled_from_cursor(ENTITY))) :- 
    outcome(outcome(repeled_from_cursor(ENTITY))). 
result(outcome(repeled_from_cursor(ENTITY)), move(ENTITY,direction(backward))) :-
    outcome(outcome(repeled_from_cursor(ENTITY))).
result(outcome(repeled_from_cursor(ENTITY)), look_at(ENTITY,cursor,nearest)) :-
    outcome(outcome(repeled_from_cursor(ENTITY))).

% Orbit_the_cursor: Cursor is sun, entity is earth (Entity looks at cursor and orbits left or right around it)
precondition(control_event(button(mouse, held)),outcome(orbit_the_cursor(ENTITY))) :- 
    outcome(outcome(orbit_the_cursor(ENTITY))). 
1 {result(outcome(orbit_the_cursor(ENTITY)), move(ENTITY,direction(LEFT_RIGHT))): left_right(LEFT_RIGHT)} 1:-
    outcome(outcome(orbit_the_cursor(ENTITY))).
result(outcome(orbit_the_cursor(ENTITY)), look_at(ENTITY,cursor,nearest)) :-
    outcome(outcome(orbit_the_cursor(ENTITY))).
    
% Click_to_spin: Entity spins when clicked, or when mouse is held or pressed.
1 { precondition(control_event(button(mouse, held)),outcome(click_to_spin(ENTITY)));
    precondition(control_event(button(mouse, pressed)),outcome(click_to_spin(ENTITY)));
    precondition(control_event(click(ENTITY)),outcome(click_to_spin(ENTITY)))
  } 1 :- 
    outcome(outcome(click_to_spin(ENTITY))).

% Click_to_spin: Entity rotates in some angular direction and speed when mouse is held
1 { result(outcome(click_to_spin(ENTITY)), rotates(ENTITY,DIR,scalar(AMOUNT))) :
      angle_direction(DIR),
      angle_speeds(AMOUNT)
   %;result(outcome(click_to_spin(ENTITY)), rotate_to(ENTITY,random_int(0,360)))
  } 1 :-
    precondition(control_event(button(mouse, held)),outcome(click_to_spin(ENTITY))).

% Click_to_spin: Entity rotates in some angular direction and speed when it is clicked or mouse is pressed
% Might be able to combine with the above rule?
1 { result(outcome(click_to_spin(ENTITY)), rotates(ENTITY,DIR,scalar(AMOUNT))) :
      angle_direction(DIR),
      angle_speeds_discrete(AMOUNT)
  } 1 :-
    outcome(outcome(click_to_spin(ENTITY))),
    1 { precondition(control_event(button(mouse, pressed)),outcome(click_to_spin(ENTITY)));
        precondition(control_event(click(ENTITY)),outcome(click_to_spin(ENTITY))) }.

% Click_to_spin: Entity always moves forward when spinning? (Why?)
result(tick,move(ENTITY,direction(forward))) :- outcome(outcome(click_to_spin(ENTITY))).
result(tick,move(ENTITY,direction(forward))) :- outcome(click_to_spin(ENTITY)).

% Click_to_chase: Entity1 looks at and moves to nearest entity2 if entity1 is clicked or mouse is pressed or held

look_criterion(nearest).

1 { precondition(control_event(button(mouse, held)),outcome(click_to_chase(ENTITY)));
    precondition(control_event(button(mouse, pressed)),outcome(click_to_chase(ENTITY)));
    precondition(control_event(click(ENTITY)),outcome(click_to_chase(ENTITY)))
  } 1 :- 
    outcome(outcome(click_to_chase(ENTITY))).

1 { result(outcome(click_to_chase(ENTITY)), look_at(ENTITY,ENTITY2,CRITERION)) :
      entity(ENTITY2), look_criterion(CRITERION)
  } 1 :-
    outcome(outcome(click_to_chase(ENTITY))).

result(tick,move(ENTITY,direction(forward))) :- outcome(outcome(click_to_chase(ENTITY))).

% Click_to_move: Entity rotates and moves forward when mouse pressed. Create associated click_to_move timer.

precondition(control_event(button(mouse, pressed)),outcome(click_to_move(ENTITY))) :-
  outcome(outcome(click_to_move(ENTITY))).
result(outcome(click_to_move(ENTITY)),move(ENTITY,direction(forward))) :-
  outcome(outcome(click_to_move(ENTITY))).

1 { timer(click_to_move(ENTITY));
    result(tick,rotates(ENTITY,DIR,scalar(AMOUNT))) :
      angle_direction(DIR), angle_speeds(AMOUNT) } 1 :- 
    outcome(outcome(click_to_move(ENTITY))).

1 { result(timer_elapsed(click_to_move(ENTITY)), rotates(ENTITY,DIR,scalar(AMOUNT))) :
      angle_direction(DIR),
      angle_speeds_discrete(AMOUNT);
    result(timer_elapsed(click_to_move(ENTITY)), rotate_to(ENTITY,random_int(0,360))) } 1 :-
    timer(click_to_move(ENTITY)).


% * Locations
place(E) :- entity(E).
location(-1..1,-1..1).
place(location(X,Y)) :- location(X,Y).


{ precondition(control_event(click(ENTITY)),OUTCOME) 
  : entity(ENTITY), outcome(OUTCOME) }.


% Create preconditions for comparisons
% compare() with 2 terms means 'is positive'/'is negative'

comparison_direction(ge;le).

{ precondition(compare((ge;le),RESOURCE),OUTCOME)
  : resource(RESOURCE), outcome(OUTCOME) }.

{ precondition(compare((ge;le),amount(Color),R),OUTCOME) : outcome(OUTCOME) } 
  :- palette(Color), resource(R).

%{precondition(is_overlapping())}

color_amount(1;5;9).
{ precondition(compare((ge;le),amount(Color),scalar(A)),OUTCOME) : outcome(OUTCOME), color_amount(A) } 
  :- palette(Color).


{ precondition(control_event(button(BUTTON,STATE)),OUTCOME) 
  : buttons(BUTTON),buttonStates(STATE), outcome(OUTCOME)}.

{ precondition(overlaps(ENTITY1,ENTITY2,P),OUTCOME) :
    outcome(OUTCOME),
    entity(ENTITY1),
    entity(ENTITY2),
    polarity(P) }.

1 { precondition(timer_elapsed(Timer), Outcome): outcome(Outcome) } 1 
  :- timer(Timer).


%%%%%%%%%%%

% * Spawning and deleting entities

{ result(OUTCOME,delete(ENTITY)) : entity(ENTITY), outcome(OUTCOME) }.
% or added to a location

spawn_types(random;ordered).

amount_to_spawn(scalar(1)).
amount_to_spawn(Resource) :- resource(Resource).

% Spawn entity at entity pool (area of game window), cursor, or another entity's location
{ result(Outcome, add(Entity,Amount,pool(Entity))) : amount_to_spawn(Amount) } :-
    entity(Entity),
    outcome(Outcome).

{ result(Outcome, add(Entity,Amount,cursor)) : amount_to_spawn(Amount) } :-
    entity(Entity),
    outcome(Outcome).

{ result(Outcome, add(Entity,Amount,Other)) : amount_to_spawn(Amount) } :-
    entity(Entity),
    entity(Other),
    outcome(Outcome).

% Can delete an entity or cursor
{ result(OUTCOME,clear(Entity)) : outcome(OUTCOME) } :- entity(Entity).
{ result(OUTCOME,clear(cursor)) : outcome(OUTCOME) }.


% * Resources can increase
{ result(OUTCOME,modify(increase,RESOURCE))
  : outcome(OUTCOME),resource(RESOURCE) }.
% Or decrease
{ result(OUTCOME,modify(decrease,RESOURCE)) 
  : outcome(OUTCOME),resource(RESOURCE) }.

% Resources can increase (by another resource's value?)
{ result(OUTCOME,modify(increase,RESOURCE,RESOURCE2))
  : outcome(OUTCOME),resource(RESOURCE),resource(RESOURCE2) }.
% Or decrease
{ result(OUTCOME,modify(decrease,RESOURCE,RESOURCE2)) 
  : outcome(OUTCOME),resource(RESOURCE),resource(RESOURCE2) }.

% Entity property values can increase
{ result(OUTCOME,modify(increase,property(Entity,Property)))
  : outcome(OUTCOME),entity(Entity),properties(Property) }.
% Or decrease
{ result(OUTCOME,modify(decrease,property(Entity,Property))) 
  : outcome(OUTCOME),entity(Entity),properties(Property) }.


% Health is a property
properties(health).


% * TODO Can set the color of entities, resources, and cursor

{ result(OUTCOME,draw(Entity,Color)) : outcome(OUTCOME) } :- 
    entity(Entity), palette(Color).

{ result(OUTCOME,draw(cursor,Color)) : outcome(OUTCOME) } :-  
    palette(Color).

{ result(OUTCOME,set_value(Resource,amount(Color))) : outcome(OUTCOME),resource(Resource) } :-  
    palette(Color).


% * TODO Entities can move towards or away from another entity, or the cursor

% { result(OUTCOME, move(ENTITY1,direction(towards,ENTITY2)))
%   : outcome(OUTCOME),
%     entity(ENTITY1),
%     entity(ENTITY2) }.
  
% { result(OUTCOME, move(ENTITY1,direction(away,ENTITY2)))
%   : outcome(OUTCOME),
%     entity(ENTITY1),
%     entity(ENTITY2) }.
  
% { result(OUTCOME, move(ENTITY1,direction(away,cursor)))
%   : outcome(OUTCOME),
%     entity(ENTITY1) }.
  
% { result(OUTCOME, move(ENTITY1,direction(towards,cursor)))
%   : outcome(OUTCOME),
%     entity(ENTITY1) }.


% * TODO Game modes (e.g., game_win, game_lose, narrative_pause,..)
min_end_outcomes 
{ result(OUTCOME,mode_change(MODE)) : modes(MODE), outcome(OUTCOME) }
max_end_outcomes.

% * TODO Generate the null precondition to match the outcome, tick (triggered every tick)
precondition(tick,tick) :- outcome(tick).

% * TODO An entity can be singular or many, not both
1 { many(Entity); singular(Entity) } 1 :- entity(Entity).

% * TODO Two entities can have restitution applied to them 
% Should there be a check that they aren't the same entity, or okay?
{ result(tick, apply_restitution(Entity1,Entity2)) :
  entity(Entity1), entity(Entity2) }.


% * TODO ENTITY BEHAVIORS

%% behaviors(chase;
%% 	  flee;
%% 	  patrol;
%% 	  pingpong;
%% 	  wander;
%%    orbit).

behaviors(chase(E)) :- entity(E).
behaviors(flee(E)) :- entity(E).
behaviors(orbit(E,D)) :- entity(E), left_right(D).
behaviors(patrol;wander).

left_right(left;right).
distance_amounts(120).

% An entity can have 0-2 behaviors
0 { behavior(ENTITY,BEHAVIOR) : behaviors(BEHAVIOR) } 2 :- entity(ENTITY).

%:- behavior(ENTITY,chase(ENTITY)).

% Behavior conditions
{ behavior_condition(ENTITY,compare(Resource)) : resource(Resource)} :- 
    entity(ENTITY), 2 { behavior(ENTITY,_) }.

{ behavior_condition(ENTITY,compare(distance(ENTITY,OTHER,CRITERION))) : entity(OTHER),look_criterion(CRITERION)} :- 
    entity(ENTITY), 2 { behavior(ENTITY,_) }.


% Prevent entities from having 2+ behaviors and no behavior_conditions?
:-  entity(ENTITY),
    2 { behavior(ENTITY,_) },
    not behavior_condition(ENTITY,_).

% Prevent entities with 2+ behavior_conditions?
:-  entity(ENTITY),
    2 { behavior_condition(ENTITY,_) }.

% Behavior condition polarities (Polarity = ge or le)

1 { behavior_condition_polarity(ENTITY, BEHAVIOR, compare(Polarity,resource(Resource))) 
    : comparison_direction(Polarity) } 1 :-
        behavior_condition(ENTITY,compare(resource(Resource))),
        behavior(ENTITY,BEHAVIOR).

1 { behavior_condition_polarity(ENTITY, BEHAVIOR, compare(Polarity,distance(ENTITY,OTHER,CRITERION),scalar(AMOUNT)))  
    : comparison_direction(Polarity), distance_amounts(AMOUNT) } 1 :-
        behavior_condition(ENTITY,compare(distance(ENTITY,OTHER,CRITERION))),
        behavior(ENTITY,BEHAVIOR).

:- behavior_condition_polarity(ENTITY, _, compare(Polarity1,distance(ENTITY,OTHER,CRITERION1),scalar(AMOUNT1))),
   behavior_condition_polarity(ENTITY, _, compare(Polarity2,distance(ENTITY,OTHER,CRITERION2),scalar(AMOUNT2))),
   AMOUNT1 != AMOUNT2.

:- behavior_condition_polarity(ENTITY, _, compare(Polarity1,distance(ENTITY,OTHER,CRITERION1),scalar(AMOUNT1))),
   behavior_condition_polarity(ENTITY, _, compare(Polarity2,distance(ENTITY,OTHER,CRITERION2),scalar(AMOUNT2))),
   CRITERION1 != CRITERION2.

:- behavior_condition_polarity(ENTITY, Behavior1, compare(Polarity,distance(ENTITY,OTHER,CRITERION),scalar(AMOUNT))),
   behavior_condition_polarity(ENTITY, Behavior2, compare(Polarity,distance(ENTITY,OTHER,CRITERION),scalar(AMOUNT))),
   Behavior1 != Behavior2.

% Choose an outcome for the behavior condition
1 { chosen_outcome(Outcome,Entity,Behavior,Comparison) : outcome(Outcome) } 1 :-
      behavior_condition_polarity(Entity, Behavior, Comparison).

behavior_condition_polarity(ENTITY, BEHAVIOR, tick) :-  
  behavior(ENTITY,BEHAVIOR), 
  1 { behavior(ENTITY,_) } 1.

:- chosen_outcome(Outcome,_,_,tick),
   Outcome != tick.
:- chosen_outcome(tick,_,_,Outcome),
   Outcome != tick.
   
% constraint(eq,
	   % precondition(compare(Polarity1,R),Outcome1),
	   % precondition(compare(Polarity2,R),Outcome2)) :-
    % chosen_outcome(Outcome1,Entity,Behavior1,compare(Polarity1,R)),
    % chosen_outcome(Outcome2,Entity,Behavior2,compare(Polarity2,R)),
    % Outcome1 != Outcome2.

			   
precondition(Comparison,Outcome) :- 
  chosen_outcome(Outcome,Entity,Behavior,Comparison), Outcome != tick, Comparison != tick.

precondition(Comparison,Outcome) :- 
  chosen_outcome_timer(Outcome,Entity,Behavior,Comparison), Outcome != tick, Comparison != tick.


:-  behavior_condition_polarity(ENTITY, BEHAVIOR1, compare(Polarity,Resource)),
    behavior_condition_polarity(ENTITY, BEHAVIOR2, compare(Polarity,Resource)),
    BEHAVIOR1 != BEHAVIOR2.


% ** CHASE -- 
result(Outcome,
        move(ENTITY,direction(forward))) :-
    chosen_outcome(Outcome,ENTITY,chase(OTHER),_).
    
1 { result(Outcome,
        look_at(ENTITY,OTHER,CRITERION)) : look_criterion(CRITERION) } 1 :-
      chosen_outcome(Outcome,ENTITY,chase(OTHER),_).

% ** FLEE -- 
result(Outcome,
        move(ENTITY,direction(backward))) :-
    chosen_outcome(Outcome,ENTITY,flee(OTHER),_).
    
1 { result(Outcome,
        look_at(ENTITY,OTHER,CRITERION)) : look_criterion(CRITERION) } 1 :-
      chosen_outcome(Outcome,ENTITY,flee(OTHER),_).

% ** ORBIT -- 
result(Outcome,
       move(ENTITY,direction(D))) :-
    chosen_outcome(Outcome,ENTITY,orbit(OTHER,D),_).
1 { result(Outcome,
	    look_at(ENTITY,OTHER,CRITERION)) : look_criterion(CRITERION) } 1 :-
      chosen_outcome(Outcome,ENTITY,orbit(OTHER,D),_).

% ** WANDER--

uses_timer(wander;patrol).

1 {chosen_outcome_timer(Outcome,Entity,Behavior,Comparison) : outcome(Outcome)} 1 :-
    behavior_condition_polarity(Entity,
				Behavior,
				Comparison),
    uses_timer(Behavior).

:- chosen_outcome_timer(Outcome,Entity,Behavior,Comparison),
   chosen_outcome(Outcome,Entity,Behavior,Comparison).

:- chosen_outcome_timer(tick,Entity,Behavior,Comparison).

result(Outcome,
       move(ENTITY,direction(forward))) :-
    chosen_outcome(Outcome,ENTITY,wander,_).


%timer(behavior_condition_polarity(ENTITY,wander,C)) :- behavior_condition_polarity(ENTITY,wander,C).
timer(behavior_condition_polarity(Entity,Behavior,Comparison)) :- chosen_outcome_timer(Outcome,Entity,Behavior,Comparison).
precondition(timer_elapsed(behavior_condition_polarity(Entity,Behavior,Comparison)),
	     Outcome) :-
    chosen_outcome_timer(Outcome,Entity,Behavior,Comparison).

result(Outcome,
       rotate_to(Entity,random_int(scalar(0),scalar(360)))) :- chosen_outcome_timer(Outcome,Entity,wander,Comparison).


result(tick,apply_restitution(E,E)) :- entity(E) , not static(E).


% * TODO GENERATION TUNING

control_event(E,delete(E2)) :- 
	precondition(control_event(E),O),
	result(O,delete(E2)).
control_event(E,add(E2)) :-
	precondition(control_event(E),O),
	result(O,add(E2,_,_)).

control_event(E,modify(R)) :- 
	precondition(control_event(E),O),
	result(O,modify(D,R)).


	
%resource_checks(N) :- N = {precondition(compare(_,_),_)}.

%:- resource_checks(N), N > 3.
controlScheme(SCHEME) :- controlScheme(ENTITY,SCHEME).
behavior_(BEHAVIOR)  :-  behavior(ENTITY,BEHAVIOR) .

project(player_controls(C)) :- player_controls(C).
project(behavior_(C)) :- behavior_(C).
pair(C,A) :- precondition(C,O), result(O,A).



project(controlScheme(C)) :- controlScheme(C).
project(R) :- resource(R).
project(E) :- entity(E).
project(T) :- timer(T).
project(behavior(E,B)) :- behavior(E,B).
project(behavior_condition_polarity(ENTITY, BEHAVIOR, CONDITION) ) :- behavior_condition_polarity(ENTITY, BEHAVIOR, CONDITION) .
project(control_event(C)) :- condition(control_event(C)).
%project(relative(greater,result(Outcome1,modify(Direction,Resource1)),result(Outcome2,modify(Direction,Resource2)))) :- relative(greater,result(Outcome1,modify(Direction,Resource1)),result(Outcome2,modify(Direction,Resource2))).
project(static(E)) :- static(E).
%project(pair(C,A)) :- pair(C,A).
%project( initialize(add(Entity,scalar(1),location(Row,Col))) ) :  initialize(add(Entity,scalar(1),location(Row,Col))) .

%grouped(A1,A2) :- result(O,A1), result(O,A2).
%grouped(A1,A2) :- precondition(A1,O), precondition(A2,O).
%project(grouped(A1,A2)) :- grouped(A1,A2).

%#show precondition/2.
#project project/1.


%#project boundary/1.
%#project pruned_action/1.

pruned_action(add(E,L)) :- action(add(E,_,L)).
pruned_action(delete(E)) :- action(delete(E)).
pruned_action(modify(Dir,R)) :- action(modify(Dir,R)).
pruned_action(rotates(E,D,V)) :- action(rotates(E,D,V)).
pruned_action(rotate_to(E)) :- action(rotate_to(E)).
pruned_action(look_at(E,E2,C)) :- action(look_at(E,E2,C)).
pruned_aciton(move(E,D)) :- action(move(E,D)).
