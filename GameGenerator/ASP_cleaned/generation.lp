number(N) :- N = 1.
%entity(e(N)) :- N = 1..min_entities.
{max_entity(M)} :- M =min_entities..max_entities.

entity(entity(e(M))) :- M = 1..N, max_entity(N).

1 {initialize(set_sprite(Entity,Sprite)) : sprite(Sprite)} 1 :-
    entity(Entity).

1 {initialize(set_color(Entity,Color)) : colors(Color)} 1 :-
    entity(Entity).

1 { initialize(add(Entity,scalar(1),location(Row,Col))) : row(Row), col(Col) } 1 :-
    singular(Entity).

1 { number_to_place(Entity,Number) : number(Number)} 1 :-
    many(Entity).

1 { initialize(add(Entity,scalar(NumberToPlace),location(Row,Col))) : row(Row), col(Col) } :-
    many(Entity),
    number_to_place(Entity,NumberToPlace).

boundary_types(torus;closed).

1 {boundary(Type) : boundary_types(Type) } 1.

speed_values(3;5;7).
speed_values(R) :- resource(R).
1 {speed(E,O,S) : speed_values(S)} 1 :-
    entity(E),
    not static(E),
    result(O,move(E,_)).				     
	      
:- speed(E,O,7),
   action(look_at(E,_,_)),
   result(O,move(E,direction(left;right))).

total_count(Entity,N) :- N = PerPlace*Places,
			 number_to_place(Entity,PerPlace),
			 Places = {initialize(add(Entity,_,_))},
			 entity(Entity).



{max_resource(M)} :- M =min_resources..max_resources.

resource(resource(r(M))) :- M = 1..min_resources..N, max_resource(N).


{max_outcome(M)} :- M =min_outcomes..max_outcomes.

standard_outcome(outcome(o(M))) :- M = 1..N, max_outcome(N).
1 {outcome(tick)}.

outcome(O) :- standard_outcome(O).

{max_timer(M)} :- M =min_timers..max_timers.

timer(t(M)) :- M = 1..N, max_timer(N).

timer_values(3;5;7).
1 {timer_logic(timer(T),scalar(N),loop): timer_values(N)} 1 :- timer(T).



{ avatar(entity(e(1))) }.

directControls(asteroids;
		tank;
		vertical;
		horizontal;
		cardinal).

1 { controlScheme(ENTITY,SCHEME) : directControls(SCHEME)} 1 :- avatar(ENTITY).


outcome(outcome(avatar(move_up))) :- 
    1 {controlScheme(ENTITY,cardinal); 
    controlScheme(ENTITY,vertical)}.
outcome(outcome(avatar(move_down))) :- 
    1 {controlScheme(ENTITY,cardinal); 
    controlScheme(ENTITY,vertical)}.
%need to move  west  if horizontal axis
outcome(outcome(avatar(move_left))) :- 
    1 {controlScheme(ENTITY,cardinal); 
    controlScheme(ENTITY,horizontal); 
    controlScheme(ENTITY,platformer)}.
outcome(outcome(avatar(move_right))) :- 
    1 {controlScheme(ENTITY,cardinal); 
    controlScheme(ENTITY,horizontal); 
    controlScheme(ENTITY,platformer)}.		

%asteroids/combat tank moving forward
outcome(outcome(avatar(move_forward))) :- 
    1 {controlScheme(ENTITY,tank); 
    controlScheme(ENTITY,asteroids)}.

% tanks can go backwards, spaceships can't
outcome(outcome(avatar_move_backward)) :- controlScheme(ENTITY,tank).
    
%tanks and spaceships can rotate
outcome(outcome(avatar(rotate_right))) :- 
    1{controlScheme(ENTITY,tank); 
    controlScheme(ENTITY,asteroids)}.
outcome(outcome(avatar(rotate_left))) :- 
    1{controlScheme(ENTITY,tank); 
      controlScheme(ENTITY,asteroids)}.


%moving  north 
precondition(control_event(button(up_arrow, held)),outcome(avatar(move_up))) :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(move_up))).
result(outcome(avatar(move_up)),move(ENTITY,  direction(north)))  :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(move_up))).
%moving  south 
precondition(control_event(button(down_arrow, held)),outcome(avatar(move_down))) :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(move_down))).
result(outcome(avatar(move_down)),move(ENTITY,   direction(south)))  :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(move_down))).
%moving  east 
precondition(control_event(button(right_arrow, held)),outcome(avatar(move_right))) :- 
    avatar(ENTITY), 
   outcome( outcome(avatar(move_right))).
result(outcome(avatar(move_right)),move(ENTITY,  direction(east) ))  :- 
    avatar(ENTITY), 
   outcome( outcome(avatar(move_right))).
%moving  west 
precondition(control_event(button(left_arrow, held)),outcome(avatar(move_left))) :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(move_left))).
result(outcome(avatar(move_left)),move(ENTITY,  direction(west) ))  :- 
    avatar(ENTITY),
    outcome(outcome(avatar(move_left))).


%moving forward
precondition(control_event(button(up_arrow, held)),outcome(avatar(move_forward))) :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(move_forward))).
% precondition(empty(ENTITY,forward,low),outcome(avatar(move_forward)) :- 
    % avatar(ENTITY), 
    % outcome(outcome(avatar(move_forward)).
result(outcome(avatar(move_forward)),move(ENTITY, direction(forward)))  :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(move_forward))).
%moving backwards
precondition(control_event(button(down_arrow, held)),outcome(avatar(move_backward))) :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(move_backward))).
% precondition(empty(ENTITY,behind,low),outcome(avatar(move_backward)) :- 
    % avatar(ENTITY), 
    % outcome(outcome(avatar(move_backward)).
result(outcome(avatar(move_backward)),move(ENTITY, direction(behind)))  :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(move_backward))).
%rotate counter clockwise
precondition(control_event(button(left_arrow, held)),outcome(avatar(rotate_left))) :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(rotate_left))).
result(outcome(avatar(rotate_left)),rotates(ENTITY, ccw))  :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(rotate_left))).
%rotate clockwise
precondition(control_event(button(right_arrow, held)),outcome(avatar(rotate_right))) :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(rotate_right))).
result(outcome(avatar(rotate_right)),rotates(ENTITY, cw))  :- 
    avatar(ENTITY), 
    outcome(outcome(avatar(rotate_right))).


indirectControls(click_and_drag;
		 %click_and_click;click_and_aim;
         orbit_the_cursor;
	drawn_to_cursor;%;
	repeled_from_cursor;
        click_to_spin;
	click_to_move;
	%click_to_chase
	).


{controlScheme(ENTITY,SCHEME) : indirectControls(SCHEME)} 1 :- entity(ENTITY).



controlLogic(draggable(ENTITY)) :- controlScheme(ENTITY,click_and_drag).
outcome(outcome(drawn_to_cursor(ENTITY))) :- controlScheme(ENTITY,drawn_to_cursor).
outcome(outcome(repeled_from_cursor(ENTITY))) :- controlScheme(ENTITY,repeled_from_cursor). 
outcome(outcome(click_to_spin(ENTITY))) :- controlScheme(ENTITY,click_to_spin).       
outcome(outcome(click_to_move(ENTITY))) :- controlScheme(ENTITY,click_to_move).  
outcome(outcome(click_to_chase(ENTITY))) :- controlScheme(ENTITY,click_to_chase).  

outcome(outcome(orbit_the_cursor(ENTITY))) :- controlScheme(ENTITY,orbit_the_cursor).  
  
  
  
%cursor is electromagnet
precondition(control_event(button(mouse, held)),outcome(drawn_to_cursor(ENTITY))) :- 
    outcome(outcome(drawn_to_cursor(ENTITY))). 
result(outcome(drawn_to_cursor(ENTITY)), move(ENTITY,direction(forward))):-
    outcome(outcome(drawn_to_cursor(ENTITY))).

result(outcome(drawn_to_cursor(ENTITY)), look_at(ENTITY,cursor,nearest)):-
    outcome(outcome(drawn_to_cursor(ENTITY))).

%cursor is opposite polarity (well, same polarity) electromagnet
precondition(control_event(button(mouse, held)),outcome(repeled_from_cursor(ENTITY))) :- 
    outcome(outcome(repeled_from_cursor(ENTITY))). 
result(outcome(repeled_from_cursor(ENTITY)), move(ENTITY,direction(backward))):-
    outcome(outcome(repeled_from_cursor(ENTITY))).
result(outcome(repeled_from_cursor(ENTITY)), look_at(ENTITY,cursor,nearest)):-
    outcome(outcome(repeled_from_cursor(ENTITY))).

%cursor is the sun, entity is the earth

precondition(control_event(button(mouse, held)),outcome(orbit_the_cursor(ENTITY))) :- 
    outcome(outcome(orbit_the_cursor(ENTITY))). 
1 {result(outcome(orbit_the_cursor(ENTITY)), move(ENTITY,direction(LEFT_RIGHT))): left_right(LEFT_RIGHT)} 1:-
    outcome(outcome(orbit_the_cursor(ENTITY))).
result(outcome(orbit_the_cursor(ENTITY)), look_at(ENTITY,cursor,nearest)):-
    outcome(outcome(orbit_the_cursor(ENTITY))).
    
1 {precondition(control_event(button(mouse, held)),outcome(click_to_spin(ENTITY)));
   precondition(control_event(button(mouse, pressed)),outcome(click_to_spin(ENTITY)));
   precondition(control_event(click(ENTITY)),outcome(click_to_spin(ENTITY)))
   } 1:- 
       outcome(outcome(click_to_spin(ENTITY))).

angle_speeds(1;5;10).
1 {result(outcome(click_to_spin(ENTITY)), rotates(ENTITY,DIR,scalar(AMOUNT))) :
   angle_direction(DIR),
   angle_speeds(AMOUNT);
   result(outcome(click_to_spin(ENTITY)), rotate_to(ENTITY,random_int(0,360)))
  } 1 :-
    precondition(control_event(button(mouse, held)),outcome(click_to_spin(ENTITY))).

angle_speeds_discrete(30;45;60;90).
1 {result(outcome(click_to_spin(ENTITY)), rotates(ENTITY,DIR,scalar(AMOUNT))) :
   angle_direction(DIR),
   angle_speeds_discrete(AMOUNT)
  } 1 :-
    outcome(outcome(click_to_spin(ENTITY))),
    1 {precondition(control_event(button(mouse, pressed)),outcome(click_to_spin(ENTITY)));
       precondition(control_event(click(ENTITY)),outcome(click_to_spin(ENTITY)))}.

result(tick,move(ENTITY,direction(forward))) :- outcome(outcome(click_to_spin(ENTITY))).


look_criterion(nearest;furthest;random).
1 {precondition(control_event(button(mouse, held)),outcome(click_to_chase(ENTITY)));
   precondition(control_event(button(mouse, pressed)),outcome(click_to_chase(ENTITY)));
   precondition(control_event(click(ENTITY)),outcome(click_to_chase(ENTITY)))
   } 1:- 
       outcome(outcome(click_to_chase(ENTITY))).
1 {result(outcome(click_to_chase(ENTITY)), look_at(ENTITY,ENTITY2,CRITERION)) :
   entity(ENTITY2), look_criterion(CRITERION)
  } 1 :-
    outcome(outcome(click_to_chase(ENTITY))).

result(tick,move(ENTITY,direction(forward))) :- outcome(outcome(click_to_chase(ENTITY))).

%CLICK TO MOVE

precondition(control_event(button(mouse, pressed)),outcome(click_to_move(ENTITY))) :-
    outcome(outcome(click_to_move(ENTITY))).

result(outcome(click_to_move(ENTITY)),move(ENTITY,direction(forward))) :-
    outcome(outcome(click_to_move(ENTITY))).

1 {timer(click_to_move(ENTITY));
   result(tick,rotates(ENTITY,DIR,scalar(AMOUNT))) :
   angle_direction(DIR), angle_speeds(AMOUNT)} 1 :- 
    outcome(outcome(click_to_move(ENTITY))).

1 {result(timer_elapsed(click_to_move(ENTITY)),  rotates(ENTITY,DIR,scalar(AMOUNT))) :
   angle_direction(DIR),
   angle_speeds_discrete(AMOUNT);
   result(timer_elapsed(click_to_move(ENTITY)),  rotate_to(ENTITY,random_int(0,360)))} 1 :-
    timer(click_to_move(ENTITY)).


result(tick, move(ENTITY,direction(forward))) :-
    outcome(click_to_spin(ENTITY)).


place(E) :- entity(E).
location(-1..1,-1..1).
place(location(X,Y)) :- location(X,Y).

{precondition(control_event(click(ENTITY)),OUTCOME)
 : entity(ENTITY), outcome(OUTCOME)}.

{precondition(compare((ge;le),RESOURCE),OUTCOME)
 : resource(RESOURCE), outcome(OUTCOME)}.

{precondition(control_event(button(BUTTON,STATE)),OUTCOME) 
  : buttons(BUTTON),buttonStates(STATE), outcome(OUTCOME)}.

{precondition(overlaps(ENTITY1,ENTITY2,P),OUTCOME) :
 outcome(OUTCOME),
 entity(ENTITY1),
 entity(ENTITY2),
 polarity(P)}.

1{precondition(timer_elapsed(Timer), Outcome)
  : outcome(Outcome)} 1 :- timer(Timer).



%%%%%%%%%%%

{result(OUTCOME,delete(ENTITY)) : entity(ENTITY), outcome(OUTCOME)}.
% or added to a location

spawn_types(random;ordered).

amount_to_spawn(scalar(1)).
amount_to_spawn(Resource) :- resource(Resource).

{result(Outcome, add(Entity,Amount,pool(Entity))) : amount_to_spawn(Amount)} :-
    entity(Entity),
    outcome(Outcome).

{result(Outcome, add(Entity,Amount,cursor))  : amount_to_spawn(Amount)} :-
    entity(Entity),
    outcome(Outcome).

{result(Outcome, add(Entity,Amount,Other)) : amount_to_spawn(Amount) } :-
    entity(Entity),
    entity(Other),
    outcome(Outcome).

% resources can increase
{result(OUTCOME,modify(increase,RESOURCE))
  : outcome(OUTCOME),resource(RESOURCE)}.
% or decrease
{result(OUTCOME,modify(decrease,RESOURCE)) 
  : outcome(OUTCOME),resource(RESOURCE)}.

% resources can increase
{result(OUTCOME,modify(increase,RESOURCE,RESOURCE2))
  : outcome(OUTCOME),resource(RESOURCE),resource(RESOURCE2)}.
% or decrease
{result(OUTCOME,modify(decrease,RESOURCE,RESOURCE2)) 
  : outcome(OUTCOME),resource(RESOURCE),resource(RESOURCE2)}.
properties(health).

% resources can increase
{result(OUTCOME,modify(increase,property(Entity,Property)))
  : outcome(OUTCOME),entity(Entity),properties(Property)}.
% or decrease
{result(OUTCOME,modify(decrease,property(Entity,Property))) 
  : outcome(OUTCOME),entity(Entity),properties(Property)}.


% {result(OUTCOME,  move(ENTITY1,direction(towards,ENTITY2)))
 % : outcome(OUTCOME),
 % entity(ENTITY1),
 % entity(ENTITY2)}.

% {result(OUTCOME,  move(ENTITY1,direction(away,cursor)))
 % : outcome(OUTCOME),
 % entity(ENTITY1)}.

% {result(OUTCOME,  move(ENTITY1,direction(towards,cursor)))
 % : outcome(OUTCOME),
 % entity(ENTITY1)}.

% {result(OUTCOME,  move(ENTITY1,direction(away,ENTITY2)))
 % : outcome(OUTCOME),
 % entity(ENTITY1),
 % entity(ENTITY2)}.

min_end_outcomes 
{result(OUTCOME,mode_change(MODE)) : modes(MODE), outcome(OUTCOME)}
max_end_outcomes.


precondition(tick,tick) :- outcome(tick).


1{many(Entity);singular(Entity)}1 :- entity(Entity).


{result(tick,apply_restitution(Entity1,Entity2)) :
 entity(Entity1),entity(Entity2)}.


behaviors(chase;
	  flee;
	  patrol;
	  pingpong;
	  wander;
      orbit).
	  
	  

{behavior(ENTITY,BEHAVIOR) : behaviors(BEHAVIOR)} 2 :- entity(ENTITY).




1 {chases(ENTITY,OTHER) : entity(OTHER)} 1 :- behavior(ENTITY,chase).

result(tick,move(ENTITY,direction(forward))) :- chases(ENTITY,OTHER).
1{ result(tick,look_at(ENTITY,OTHER,CRITERION)) : look_criterion(CRITERION)} 1 :- chases(ENTITY,OTHER).


1 {flees(ENTITY,OTHER) : entity(OTHER)} 1 :- behavior(ENTITY,flee).
result(tick,move(ENTITY,direction(backward))) :- flees(ENTITY,OTHER).
1{ result(tick,look_at(ENTITY,OTHER,CRITERION)) : look_criterion(CRITERION)} 1  :- flees(ENTITY,OTHER).


1 {orbits(ENTITY,OTHER) : entity(OTHER)} 1 :- behavior(ENTITY,orbit).
left_right(left;right).
1 {result(tick,move(ENTITY,direction(LEFT_RIGHT))) : left_right(LEFT_RIGHT)} 1 :- orbits(ENTITY,OTHER).
1{ result(tick,look_at(ENTITY,OTHER,CRITERION)) : look_criterion(CRITERION)} 1 :- orbits(ENTITY,OTHER).


timer(patrol(ENTITY)) :- behavior(ENTITY,patrol).
precondition(timer_elapsed(patrol(ENTITY)), outcome(patrol(ENTITY))) :- behavior(ENTITY,patrol).
1 {result(outcome(patrol(ENTITY)), rotates(ENTITY, DIRECTION,scalar(AMOUNT)))  :
   angle_direction(DIRECTION),
   angle_speeds_discrete(AMOUNT)} 1 :- behavior(ENTITY,patrol).
result(tick,move(ENTITY,direction(forward)))  :- behavior(ENTITY,patrol).



timer(pingpong(ENTITY)) :- behavior(ENTITY,pingpong).
precondition(timer_elapsed(pingpong(ENTITY)),outcome(pingpong(ENTITY))) :- behavior(ENTITY,pingpong).
result(outcome(pingpong(ENTITY)), rotates(ENTITY, cw,scalar(180))) :- behavior(ENTITY,pingpong).
result(tick,move(ENTITY,direction(forward)))  :- behavior(ENTITY,pingpong).




timer(wander(ENTITY)) :- behavior(ENTITY,wander).
precondition(timer_elapsed(wander(ENTITY)),outcome(wander(ENTITY))) :- behavior(ENTITY,wander).
result(outcome(wander(ENTITY)), rotate_to(ENTITY,random_int(scalar(0),scalar(360)))) :- behavior(ENTITY,wander).

result(tick,move(ENTITY,direction(forward)))  :- behavior(ENTITY,wander).


result(tick,apply_restitution(E,E)) :- entity(E) , not static(E).


%%%%%%%%%%%%%%%% GENERATION TUNING

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
behavior(BEHAVIOR)  :-  behavior(ENTITY,BEHAVIOR) .

project(player_controls(C)) :- player_controls(C).
project(behavior(C)) :- behavior(C).

project(controlScheme(C)) :- controlScheme(C).
project(R) :- resource(R).
project(E) :- entity(E).
project(T) :- timer(T).
project(static(E)) :- static(E).
project( initialize(add(Entity,scalar(1),location(Row,Col))) ) :  initialize(add(Entity,scalar(1),location(Row,Col))) .

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
