% lots of constraints like "don't generate A in syntax 3 without generating A' in syntax 2"

number(N) :- N = 1.
max_entity(N) :-
  max_entity_g3(N).
entity(E) :-
  entity_g3(E3),
  entity_3to2(E3,E).
entity_3to2(E3,entity(E3)) :-
  entity_g3(E3).
initialize(set_sprite(E, S)) :-
  entity_3to2(E3,E),
  init_g3(gemini, set_sprite(E3, S)).
initialize(set_color(E, Col)) :-
  entity_3to2(E3,E),
  init_g3(gemini, set_color(E3, Col))

% TODO grind through the rest of these then the remainder of generation.lp and friends; then make sure no initialize() or other generation terms show up in intent files, and maybe even add constraints to prevent that somehow?
singular(E) :-
  entity_3to2(E3,E),
  initial_count(E,1),
  not result_g3(_, add_collider(E3,_)).
many(E) :-
  entity_3to2(E3,E),
  initial_count(E,N),
  N != 1.
many(E) :-
  entity_3to2(E3,E),
  result_g3(_, add_collider(E3,_)).
:- many(E),
  singular(E).
:- entity(E),
  not many(E),
  not singular(E).

initialize(add(E,scalar(1),location(Row,Col))) :-
  init_g3(collision,add_collider(E3,grid(Row, Col))),
  entity_3to2(E3, E).

initial_count(Entity,Number) :-
  entity(Entity),
  entity_3to2(E3, Entity),
  Number = {init_g3(collision,add_collider(E3,_))}.

initialize(fill(all,Color)) :-
  Rows = {row_g3(_)},
  Cols = {col_g3(_)},
  paint_g3(Color),
  Rows*Cols = {init_g3(collision,add_collider(P,_))}.

initialize(fill(location(Row,Col),Color)) :-
  paint_g3(Color),
  init_g3(collision,add_collider(P,grid(Row,Col))).

speed(E,Fastest,S) :-
  entity(E),
  entity_3to2(E3,E),
  physics_mode_lvel_g3(physics,E3,Fastest,S),
  physics_mode_g3(physics,E3,Fastest),
  {physics_mode_lvel_g3(physics,E3,_,S2):physics_lvel_g3(physics,S2),S2>S}0.

static(E) :-
  entity(E),
  entity_3to2(E3,E),
  0 = {physics_mode_lvel_g3(physics,E3,_,S):physics_lvel_g3(physics,S),S != 0}.

max_resource(M) :- max_resource_g3(M).
resource(resource(R)) :- resource_g3(R).
max_outcome(M) :- max_generated_outcome_g3(M).
standard_outcome(outcome(M)) :- generated_outcome_g3(M).
outcome(O) :- outcome_g3(O).
timer(T) :- timer_g3(T).
max_timer(T) :- max_timer_g3(T).
%%%DONT GET STUCK ON WALLS
% :- precondition(timer_elapsed(T),O),
%    result(O,rotates(E,_,_)),
%    speed(E,tick,scalar(V)),
%    timer_logic(timer(T),scalar(DT),loop),
%    60*DT*V > 200.
avatar(E) :- player_controls(E).

% precondition(control_event(click(E)),O) :-
  % ....%

% resource comparisons

% overlaps

% timer

% results:

% delete, add
% clear
% modify resource
% entity health property
% drawing on the world
% entity movement
% game mode change outcomes
% tick outcome
% restitution
% behaviors
% for behaviors and other weird stuff, check to make sure we acutally need it
