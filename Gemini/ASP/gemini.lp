#include "logics/logics.lp".

% Use collision logics
#include "logics/collision.lp".
collision_logic(collision).
% In the collision logic col, these are reasonable distances to check between objects
distance(collision, d(50)) :- collision_logic(collision).
distance(collision, d(500)) :- collision_logic(collision).

% use default "maybe X blocks Y" initialization

% color drawing
%   these will be colliders spaced at uniform positions of one type per color.  they might even be blocking which will give us terrain!
{paint(C)} :- palette(C).
collider(collision, C) :- collision_logic(collision), paint(C).

% structural synthesis with collision
%  one entity:one collider
collider(collision, E) :- collision_logic(collision), entity(E).

#include "logics/physics.lp".
physics_logic(physics).
physics_body(physics, E) :- entity(E).

% Tie physics and character states together

physics_mode(physics, E, M) :-
  entity(E),
  charstate_logic(charstate),
  charmstate(charstate, E, M),
  M != dead.

physics_mode(physics, E, dead) :-
  entity(E).

prerequisite(charstate, set_charmstate(E, M),
             physics, set_physics_mode(E, M)) :-
  a_op(charstate, set_charmstate(E, M)),
  a_op(physics, set_physics_mode(E, M)).

prerequisite(physics, set_physics_mode(E, M),
             charstate, set_charmstate(E, M)) :-
  a_op(charstate, set_charmstate(E, M)),
  a_op(physics, set_physics_mode(E, M)).

steering(stay;seek;flee).
% steering(pursue;avoid). % could also be implemented as adding locs for ahead_of(E) when entity(E).

{steering_mode(E, M, Steer):steering(Steer)} :-
  physics_mode(physics, E, M).

% Even the idea of "character X chases character Y" is more than what a physics logic provides.  Right?  Physics logics govern smooth movement, but can we say that it's smooth movement towards targets?  In HyPED we assume the target is nondeterministically given but the style of movement is sort of provided.  so does it make sense to put steering_mode into physics?  or is it more like "approach loc" where loc can be something or other in the physics world?  I really don't feel like destinations belong there...

% Use character-state logics (alive/dead)
#include "logics/character_state.lp".
charstate_logic(charstate).
% structural synthesis with character-state logics
%  one entity:one char machine
charm(charstate, E) :- charstate_logic(charstate), entity(E).
%  one char machine:two states
charmstate(charstate, E, normal) :- charstate_logic(charstate), entity(E).
charmstate(charstate, E, dead) :- charstate_logic(charstate), entity(E).
%    and one edge
charmedge(charstate, E, normal, dead) :- charstate_logic(charstate), entity(E).

% TODO: maybe generate new states but give them all transitions to dead
%  and give some transitions between the new states too

% always require starting with at least one alive thing
% :- charstate_logic(charstate),
%   {init(charstate, charmstate(E, dead)):entity(E)} = K,
%   not max_entity(K).


% Resource logics
#include "logics/resource.lp".
resource_logic(resource).
%  Valid resource quantities for rules
resource_amount(resource, r(0)) :- resource_logic(resource).
resource_amount(resource, r(-1)) :- resource_logic(resource).
resource_amount(resource, r(1)) :- resource_logic(resource).
resource_amount(resource, r(-3)) :- resource_logic(resource).
resource_amount(resource, r(3)) :- resource_logic(resource).
resource_amount(resource, r(-5)) :- resource_logic(resource).
resource_amount(resource, r(5)) :- resource_logic(resource).
resource_amount(resource, r(-10)) :- resource_logic(resource).
resource_amount(resource, r(10)) :- resource_logic(resource).
resource_pool(resource, health(E)) :-
  resource_logic(resource),
  entity(E).
resource_pool(resource, R) :-
  resource_logic(resource),
  resource(R).
resource_pool_capacity(resource, P, r(10)) :-
  resource_logic(resource),
  resource_pool(resource, P),
  not paint_pool(P).

% color pools, prevent altering those pools by resource transactions
paint_pool(paint(P)) :- paint(P).
resource_pool(resource, paint(P)) :-
  resource_logic(resource), paint(P).
resource_pool_capacity(resource, P, inf) :-
  resource_logic(resource), resource_pool(resource, P), paint_pool(P).
% TODO URGENT: Decide whether it's the case that nothing can alter the paint pools OR that only events that add or remove paint can alter the paint pools, and if so only by one unit.
:- paint_pool(P), result(_, alter_resource(P, _, _)).
:- paint_pool(P), result(_, move_resource(P, _, _)).
:- paint_pool(P), result(_, move_resource(_, P, _)).

% Control logics
#include "logics/control.lp".
control_logic(control).

input(L, (button(mouse,(up;down));point(mouse))) :-
  control_logic(L).

% mouse is down somewhere
{input_map(L, button(mouse, down), Agent, Action)} :-
  control_logic(L),
  agent(L, Agent),
  action(L, Agent, Action).
% mouse position is somewhere
{input_map(L, point(mouse), Agent, Action)} :-
  control_logic(L),
  agent(L, Agent),
  action(L, Agent, Action).
  
% TODO add keyboard buttons
agent(control, E) :-
  control_logic(control),
  agent(control, E).
action(control, E, set_target(Loc)) :-
  control_logic(control), 
  agent(control, E),
  loc(collision, Loc).
% NOTE: to go from action to control for that action you have to use the input_map predicate.
action(control, E, drop_paint(P)) :-
  control_logic(control),
  agent(control, E),
  paint(P).
action(control, E, clear_paint) :-
  control_logic(control),
  agent(control, E),
  1{paint(_)}.
action(control, E1, create(E2, Loc)) :-
  control_logic(control),
  agent(control, E1),
  entity(E2),
  loc(collision, Loc).

% TODO URGENT: what about AI actions?  Do those have to be caused by something in the input map, or do they need to be implemented as a_ops somewhere?
%  Does this suffice?
% action(control, E, A) :-
%   control_logic(control),
%   logic(L),
%   entity(E),
%   % TODO: connect E to A somehow?
%   L != control,
%   a_op(L, A).

% Structural synthesis between collision and physics
loc(collision, mouse) :- logic(collision).
loc(collision, C) :- logic(collision), collider(collision, C).
loc(collision, target(E)) :- logic(collision), entity(E).
loc(collision, arb) :- logic(collision).
dir(physics, aheadof(E)) :- logic(physics), entity(E). 
dir(physics, behind(E)) :- logic(physics), entity(E).
dir(physics, (nw;n;ne;w;e;sw;s;se)) :- logic(physics).
dir(physics, arb) :- logic(physics).
physics_lvel(physics,lvel(1)).
physics_avel(physics,avel(1)).

#include "logics/gamemode.lp".
gamemode_logic(gamemode).
gamemode(gamemode, (playing;stuck)).
init(gamemode, gamemode(playing)).
:- 2{result(O, set_gamemode(_)):outcome(O)}.
% Only ever do anything when in playing mode, rely on outer game to kick us out of stuck when we get stuck?
prerequisite(L, Op, gamemode, gamemode(playing)) :-
  logic(L),
  q_op(L,Op),
  L != gamemode.
prerequisite(L, Op, gamemode, gamemode(playing)) :-
  logic(L),
  a_op(L,Op),
  L != gamemode.

% Extra gemini stuff
{max_entity(M)} :- M = min_entities..max_entities.
entity(entity(e(M))) :- M = 1..N, max_entity(N).

{max_generated_outcome(M)} :- M = min_outcomes..max_outcomes.
generated_outcome(o(M)) :- M = 1..N, max_generated_outcome(N).

{max_resource(M)} :-
  resource_logic(resource),
  M = min_resources..max_resources.
resource(resource(r(M))) :-
  resource_logic(resource),
  M = 1..min_resources..N,
  max_resource(N).

% steering defined at this level?  Or in the physics logic itself?
% steering(seek, ...)?  or physics_mode(L, Ent, Behavior)?
%   there needs to be a way to figure out the physics mode _at a given time_ without re-solving.  like with input_map.  maybe based on preconditions or character states explicitly.
% TODO: steering here to combine info about target position, accels, max vels into controllers?
% TODO: something like "mouse down to drive towards" will probably require a new state for the controlled character, right?

precondition(tick, tick).

% Gemini's operational integrations are all like this:

{precondition(Q, O)} :-
  logic(L),
  q_op(L,Q),
  generated_outcome(O).

outcome(O) :- generated_outcome(O).

unchecked_outcome(O) :-
  outcome(O),
  not precondition(_, O).
:- unchecked_outcome(_).

{result(O, A)} :-
  generated_outcome(O),
  logic(L),
  a_op(L, A).

trivial_outcome(O) :- outcome(O), not result(O, _).
:- trivial_outcome(_).

% Example: prevent any outcome that moves resource into or out of agent health?
%:- resource_logic(resource), outcome(O), result(O, move_resource(health(_), _, _)).
%:- resource_logic(resource), outcome(O), result(O, move_resource(_, health(_), _)).

% Some queries might have other implicit queries
query_needs_query(Q, Q2, O) :-
  precondition(Q, O),
  q_op(L1, Q),
  prerequisite(L1, Q, L2, Q2),
  q_op(L2, Q2),
  not precondition(Q2, O).
:- query_needs_query(_, _, _).
% Some conditions might be forced to go with certain outcomes
query_needs_change(Q, A, O) :-
  precondition(Q, O),
  q_op(L1, A),
  prerequisite(L1, Q, L2, A),
  a_op(L2, A),
  not result(O, A).
:- query_needs_change(_, _, _).
% Some actions might have implicit preconditions
unchecked_action_pre(A, Q, O) :-
  result(O, A),
  a_op(L1, A),
  prerequisite(L1, A, L2, Q),
  q_op(L2, Q),
  not precondition(Q, O).
:- unchecked_action_pre(_, _, _).

% Some actions might have implicit dependent actions
unmet_action_action_req(A, A2, O) :-
  result(O, A),
  a_op(L1, A),
  prerequisite(L1, A, L2, A2),
  a_op(L2, A2),
  not result(O, A2).
:- unmet_action_action_req(_, _, _).

% We also have some special case ones like entities dying when they're out of health
precondition(charmstate(E, dead, false), die(E)) :-
  charstate_logic(charstate),
  q_op(charstate, charmstate(E, dead, false)),
  entity(E).
precondition(has_resource(health(E), le, s(0)), die(E)) :-
  resource_logic(resource),
  q_op(resource, has_resource(health(E), le, s(0))),
  entity(E).

% Must be at least a few reasons to die (in alive state, has edge, and X)
arb_death :- entity(E), not 3{precondition(Q, die(E)):logic(L), q_op(L, Q)}.
:- arb_death.

outcome(die(E)) :- entity(E).

result(die(E), set_charmstate(E, dead)) :-
  charstate_logic(charstate),
  entity(E).

% TODO some kind of 'reset' that I can use in spawn to reset entity instance health, state, etc...

%% TODO URGENT Create collider and destroy collider should be operators of collision logic, likewise create/destroy resource pool and create/destroy physics entity and control agent and charstate machine.  then this glue can make sure that those all come together.  that gives us a way to phrase creation and destruction simply, and handles both colors and entities.  also need a good story for actions vs a_ops vs outcomes:  what's being generated?  are ai knobs and player knobs all the same?
%% TODO URGENT debug no models.  I think the issue might be incomplete initializations required by the logics.

palette(blue).
#const min_entities = 1.
#const max_entities = 3.
#const min_resources = 1.
#const max_resources = 2.
#const min_outcomes = 3.
#const max_outcomes = 5.
