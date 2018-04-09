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
  result_g3(init, set_sprite(E3, S)).
initialize(set_color(E, Col)) :-
  entity_3to2(E3,E),
  result_g3(init, set_color(E3, Col)).

singular(E) :-
  entity_3to2(E3,E),
  initial_count(E,1),
  0{result_g3(Outcome, add_collider(E3,_)):outcome_g3(Outcome),Outcome != init}.
many(E) :-
  entity_3to2(E3,E),
  initial_count(E,N),
  N != 1.
many(E) :-
  entity_3to2(E3,E),
  result_g3(O, add_collider(E3,_)),
  outcome_g3(O),
  O != init.
:- many(E),
  singular(E).
:- entity(E),
  not many(E),
  not singular(E).

pool(E, location(Row,Col), ordered, ordered) :-
  result_g3(_,add_collider(E3,grid(Row, Col))),
  entity_3to2(E3, E).
spawn_types(ordered).
initialize(add(E,scalar(1),location(Row,Col))) :-
  result_g3(init,add_collider(E3,grid(Row, Col))),
  entity_3to2(E3, E).

initial_count(Entity,Number) :-
  entity(Entity),
  entity_3to2(E3, Entity),
  Number = {result_g3(init,add_collider(E3,_))}.

initialize(fill(all,Color)) :-
  Rows = {row_g3(_)},
  Cols = {col_g3(_)},
  paint_g3(Color),
  Rows*Cols = {result_g3(init,add_collider(P,_))}.

initialize(fill(location(Row,Col),Color)) :-
  paint_g3(Color),
  result_g3(init,add_collider(P,grid(Row,Col))).

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

moving(E) :-
  entity(E),
  not static(E).

max_resource(M) :- max_resource_g3(M).
resource(R) :- resource_g3(R).
max_outcome(M) :- max_generated_outcome_g3(M).
standard_outcome(outcome(M)) :- generated_outcome_g3(M).
outcome(O) :- outcome_g3(O), not generated_outcome_g3(O).
outcome(O) :- standard_outcome(O).
timer(T) :- timer_g3(T).
max_timer(T) :- max_timer_g3(T).
%%%DONT GET STUCK ON WALLS
% :- precondition(timer_elapsed(T),O),
%    result(O,rotates(E,_,_)),
%    speed(E,tick,scalar(V)),
%    timer_logic(timer(T),scalar(DT),loop),
%    60*DT*V > 200.
{avatar(E)} :- player_controls(E).
{avatar(cursor)}.

player_controls(E) :-
  entity_3to2(E3,E),
  input_map_g3(control, _, E3, _).

angle_speeds(K) :- physics_avel_g3(physics, K).
angle_speeds_discrete(K) :- angle_speeds(K).

outcome_3to2(O3, outcome(O3)) :-
  outcome_g3(O3).

mousestate_3to2(up, up;press,pressed;down, held).
precondition(control_event(click(E)), O) :-
  outcome(O),
  outcome_3to2(O3,O),
  entity(E),
  entity_3to2(E3,E),
  precondition_g3(control_action(E3, Ac), O3),
  input_map_g3(control, button(mouse,press), E3, Ac),
  precondition_g3(touching(E3, cursor, true), O3).
precondition(control_event(button(mouse, State)), O) :-
  outcome_3to2(O3, O),
  entity_g3(E3),
  mousestate_3to2(State3,State),
  precondition_g3(control_action(E3, Ac), O3),
  input_map_g3(control, button(mouse, State3), E3, Ac).

% compare(cmp, dist(), Scalar)
precondition(compare(Cmp, distance(EA, EB, nearest), scalar(Amt)), O) :-
  outcome_3to2(O3, O),
  comparator_g3(Cmp),
  entity_3to2(EA3, EA),
  entity_3to2(EB3, EB),
  distance_g3(Amt),
  precondition_g3(proximity(EA, EB, Amt, Cmp), O3).
  
% compare(cmp, Color, Scalar)
precondition(compare(Cmp, amount(Col), scalar(A)), O) :-
  outcome_3to2(O3, O),
  paint_g3(Col),
  paint_pool_g3(paint(Col)),
  precondition_g3(has_resource(paint(Col), Cmp, r(A)), O3).
% compare(cmp, Color, Rsrc)
precondition(compare(Cmp, amount(Col), R), O) :-
  outcome_3to2(O3, O),
  paint_g3(Col),
  paint_pool_g3(paint(Col)),
  resource_g3(R),
  precondition_g3(has_resource(paint(Col), Cmp, R), O3).
% compare(cmp, Rsrc, Rsrc)
precondition(compare(Cmp, RA, RB), O) :-
  outcome_3to2(O3, O),
  resource_g3(RA),
  resource_g3(RB),
  precondition_g3(has_resource(RA, Cmp, RB), O3).
% compare(cmp, Rsrc, Scalar)
precondition(compare(Cmp, RA, scalar(B)), O) :-
  outcome_3to2(O3, O),
  resource_g3(RA),
  resource_amount_g3(resource, r(B)),
  precondition_g3(has_resource(RA, Cmp, r(B)), O3).

% precondition(timer_elapsed)
precondition(timer_elapsed(T), O) :-
  timer_g3(T),
  outcome_3to2(O3, O),
  precondition_g3(timer(T,_,_),O3).
interval_qual2quant(short,3;medium,5;long,7).
timer_logic(timer(T),scalar(N),loop) :-
  timer_g3(T),
  interval_qual2quant(Q, N),
  precondition_g3(timer(T,Q,true),_).
% precondition(overlaps)
precondition(overlaps(A, B, Bool), O) :-
  outcome_3to2(O3, O),
  entity_3to2(A3, A),
  entity_3to2(B3, B),
  bool_g3(Bool),
  precondition_g3(touching(A3, B3, Bool), O3).

place(P) :- loc_g3(collision, P).

% results:

% delete, add
result(O, delete(E)) :-
  entity_3to2(E3, E),
  outcome_3to2(O3, O),
  result_g3(O3, remove_collider(E3, Loc)),
  loc_g3(collision, Loc).
result(O, add(E,scalar(1),Loc)) :-
  entity_3to2(E3, E),
  outcome_3to2(O3, O),
  result_g3(O3, add_collider(E3, Loc)).
% clear
result(O, clear(Entity)) :-
  outcome_3to2(O3, O),
  entity_3to2(E3,Entity),
  paint_g3(P),
  result_g3(O3, remove_collider(P, Entity)).
result(O, clear(cursor)) :-
  outcome_3to2(O3, O),
  paint_g3(P),
  result_g3(O3, remove_collider(P, cursor)).
% modify resource, entity health
incdec_3to2(inc,increment;dec,decrement).
result(O, modify(IncDec, resource(R), Amt)) :-
  resource_g3(R),
  outcome_3to2(O3, O),
  incdec_3to2(IncDec3, IncDec),
  result_g3(O3, alter_resource(R, IncDec3, Amt)).
result(O, modify(IncDec, property(Entity, health), Amt)) :-
  entity_3to2(Entity3, Entity),
  outcome_3to2(O3, O),
  incdec_3to2(IncDec3, IncDec),
  result_g3(O3, alter_resource(health(Entity3), IncDec3, Amt)).
result(O, modify(decrease, resource(R1), Amt)) :-
  resource_g3(R1),
  resource_g3(R2),
  outcome_3to2(O3, O),
  result_g3(O3, move_resource(R1, R2, Amt)).
result(O, modify(increase, resource(R2))) :-
  resource_g3(R1),
  resource_g3(R2),
  outcome_3to2(O3, O),
  result_g3(O3, move_resource(R1, R2, Amt)).
result(O, set_value(R, amount(C))) :-
  resource(R),
  paint_g3(C),
  outcome_3to2(O3, O),
  resource_change_direction_g3(IncDec),
  result_g3(O3, alter_resource(R, IncDec, Amt)).
  
% drawing on the world
result(O, draw(Entity,Color)) :-
  outcome_3to2(O3,O),
  entity_3to2(E3,Entity),
  paint_g3(Color),
  result_g3(O3,add_collider(Color,Entity)).
result(O, draw(cursor,Color)) :-
  outcome_3to2(O3,O),
  paint_g3(Color),
  result_g3(O3,add_collider(Color,cursor)).
  
% entity movement, look_at:
%   [ ] physics_mode_ltarget_g3 in particular modes (move(E,Dir,Amt))
outcome(outcome(entity_physics(E, M))) :-
  entity_3to2(E3, E),
  physics_mode_g3(physics, E3, M).
precondition(in_behavior(E, M), outcome(entity_physics(E, M))) :-
  entity_3to2(E3, E),
  physics_mode_g3(physics, E3, M).

% For 3to2, force that entities move in the direction relative to their facing
:- physics_mode_ltarget_g3(physics, _, _, Dir),
  Dir != forward,
  Dir != right.

gt0(arb;inf).
gt0(lvel(S)) :-
  S > 0,
  physics_lvel_g3(physics, lvel(S)).
gt0(avel(S)) :-
  S > 0,
  physics_avel_g3(physics, avel(S)).
lt0(narb;ninf).
lt0(lvel(S)) :-
  S < 0,
  physics_lvel_g3(physics, lvel(S)).
lt0(avel(S)) :-
  S < 0,
  physics_avel_g3(physics, avel(S)).
neg_lvel(narb, arb;arb, narb).
neg_lvel(ninf, inf;inf, ninf).
neg_lvel(lvel(S), lvel(-S)) :-
  physics_lvel_g3(physics, lvel(S)).
direction_speed_3to2(forward, S3, direction(forward), S3) :-
  S3 > 0,
  gt0(S3),
  physics_lvel_g3(physics, S3).
direction_speed_3to2(forward, S3, direction(backward), S) :-
  lt0(S3),
  neg_lvel(S3,S),
  physics_lvel_g3(physics, S3).
direction_speed_3to2(right, S3, direction(right), S3) :-
  S3 > 0,
  gt0(S3),
  physics_lvel_g3(physics, S3).
direction_speed_3to2(right, S3, direction(left), S) :-
  lt0(S3),
  neg_lvel(S3,S),
  physics_lvel_g3(physics, S3).

result(outcome(entity_physics(E, M)), move(E, Direction, Speed)) :-
  entity_3to2(E3, E),
  physics_mode_g3(physics, E3, M),
  physics_mode_lvel_g3(physics, E3, M, Speed3),
  physics_mode_ltarget_g3(physics, E3, M, Direction3),
  Speed3 != lvel(0),
  Speed3 = lvel(Speed),
  direction_speed_3to2(Direction3, Speed3, Direction, Speed).
result(outcome(entity_physics(E, M)), look_at(E, Direction, nearest)) :-
  entity_3to2(E3, E),
  physics_mode_g3(physics, E3, M),
  physics_mode_atarget_g3(physics, E3, M, Direction),
  Direction != same.
result(outcome(entity_physics(E, M)), rotates(E, cw)) :-
  entity_3to2(E3, E),
  physics_mode_g3(physics, E3, M),
  physics_mode_avel_g3(physics, E3, M, Speed),
  gt0(Speed).
result(outcome(entity_physics(E, M)), rotates(E, ccw)) :-
  entity_3to2(E3, E),
  physics_mode_g3(physics, E3, M),
  physics_mode_avel_g3(physics, E3, M, Speed),
  lt0(Speed).

% game mode change outcomes
result(O, mode_change(Mode)) :-
  outcome_3to2(O3, O),
  result_g3(O3, set_gamemode(Mode)).

precondition(tick, tick) :- outcome_g3(tick).
outcome(tick) :- outcome_g3(tick).

% tick: restitution, just restitute everything that's initialized to blocking
result(tick, apply_restitution(EA, EB)) :-
  entity(EA),
  entity(EB).

% behaviors
% for behaviors and other weird stuff, check to make sure we acutally need it

% etc

control_event(E,delete(E2)) :- 
	precondition(control_event(E),O),
	result(O,delete(E2)).
control_event(E,add(E2)) :-
	precondition(control_event(E),O),
	result(O,add(E2,_,_)).

control_event(E,modify(R)) :- 
	precondition(control_event(E),O),
	result(O,modify(D,R)).

flees(E1, E2) :-
  entity_movement(E1, flees(E2)).
chases(E1, E2) :-
  entity_movement(E1, chases(E2)).

controlLogic(draggable(E)) :-
  entity_3to2(E3,E),
  % a physics state where E3 follows the mouse
  physics_mode_ltarget_g3(physics, E3, DragMode, cursor),
  physics_mode_lvel_g3(physics, E3, DragMode, inf),
  % which is entered when mouse down and cursor overlapping E3
  outcome_g3(OA),
  result_g3(OA, set_physics_mode(E3, DragMode)),
  precondition_g3(control_action(E3, Ac), OA),
  input_map_g3(control, button(mouse,press), E3, Ac),
  precondition_g3(touching(E3, cursor), OA),
  % and is exited when mouse up while in that state
  outcome_g3(OB),
  result_g3(OB, set_physics_mode(E3, NotDragMode)),
  NotDragMode != DragMode,
  precondition_g3(physics_mode(E3, DragMode), OB),
  precondition_g3(control_action(E3, AcB), OB),
  input_map_g3(control, button(mouse,up), E3, AcB).  


reachableCondition(in_behavior(E,normal)) :-
  entity(E).
reachableCondition(in_behavior(E,M)) :-
  entity_3to2(E3,E),
  result_g3(set_physics_mode(E3,M),O3),
  outcome_3to2(O3,O),
  reachableOutcome(O).
ignoredCondition(init).
% chases(E1, E2) and flees should fall out of the restrictions above and translations of movement
% try to fix as many warnings as possible
