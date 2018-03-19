#include "logics/logics.lp"

% Use collision logics
#include "logics/collision.lp"
collision_logic(collision).
% In the collision logic col, these are reasonable distances to check between objects
distance(collision, d(50)) :- collision_logic(collision).
distance(collision, d(500)) :- collision_logic(collision).

% use default "maybe X blocks Y" initialization

% TODO: color drawing
%   these will be entities spaced at uniform positions of one type per color.  they might even be blocking which will give us terrain!

% structural synthesis with collision
%  one entity:one collider
collider(collision, E) :- collision_logic(collision), entity(E).

#include "logics/physics.lp"
physics_logic(physics).
physics_body(physics, E) :- entity(E).

physics_quantity(physics,p())

% Tie physics and character states together

physics_mode(physics, E, M) :-
  entity(E),
  charstate_logic(charstate),
  charmstate(charstate, E, M),
  M /= dead.

physics_mode(physics, E, dead) :-
  entity(E).

prerequisite(charstate, set_charmstate(E, M),
             physics, set_physics_mode(E, M)).

prerequisite(physics, set_physics_mode(E, M),
             charstate, set_charmstate(E, M)).

steering(stay;seek;flee).
% steering(pursue;avoid). % could also be implemented as adding locs for ahead_of(E) when entity(E).

{steering_mode(E, M, Steer):steering(Steer)} :-
  physics_mode(physics, E, M).

% Even the idea of "character X chases character Y" is more than what a physics logic provides.  Right?  Physics logics govern smooth movement, but can we say that it's smooth movement towards targets?  In HyPED we assume the target is nondeterministically given but the style of movement is sort of provided.  so does it make sense to put steering_mode into physics?  or is it more like "approach loc" where loc can be something or other in the physics world?  I really don't feel like destinations belong there...

% Use character-state logics (alive/dead)
#include "logics/charstate.lp"
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
:- charstate_logic(charstate),
  {init(charstate, charmstate(E, dead)):entity(E)} = K,
  not max_entity(K).

% Resource logics
#include "logics/resource.lp"
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
resource_pool(resource, health(E)) :- resource_logic(resource), entity(E).
resource_pool(resource, R) :- resource_logic(resource), resource(R).
resource_pool_capacity(resource, P, r(10)) :- resource_logic(resource), resource_pool(resource, P).

% TODO: color pools, prevent altering those pools by resource transactions

% Control logics
#include "logics/control.lp"
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
action(control, E, change_state(S)) :-
  S /= dead,
  control_logic(control),
  charstate_logic(charstate),
  agent(control, E),
  charmstate(charstate, E, S).
% NOTE: to go from action to control for that action you have to use the input_map predicate.


% Structural synthesis between collision and physics
loc(collision, mouse) :- logic(collision).
loc(collision, E) :- logic(collision), entity(E).
loc(collision, target(E)) :- logic(collision), entity(E).
%loc(collision, behind(E)) :- entity(E). 
%loc(collision, ahead_of(E)) :- entity(E). 
% loc(collision, awayfrom(E)) :- entity(E).
dir(physics, aheadof(E)) :- logic(physics), entity(E). 
dir(physics, behind(E)) :- logic(physics), entity(E).
dir(physics, (nw;n;ne;w;e;sw;s;se)) :- logic(physics).
physics_lvel(physics,lvel(1)).
physics_avel(physics,avel(1)).
%loc(physics, L) :- logic(collision), loc(collision, L).

% TODO spawning

#include "logics/gamemode.lp"
gamemode_logic(gamemode).
gamemode(gamemode, (playing;stuck)).
init(gamemode, gamemode(playing)).
:- 2{result(O, set_gamemode(_)):outcome(O)}.
% Only ever do anything when in playing mode, rely on outer game to kick us out of stuck when we get stuck?
prerequisite(L, Op, gamemode, gamemode(playing)) :-
  logic(L),
  (q_op(L,Op);a_op(L,Op))
  L /= gamemode.

% Extra gemini stuff
{max_entity(M)} :- M = min_entities..max_entities.
entity(entity(e(M))) :- M = 1..N, max_entity(N).

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

{precondition(Q, O) :
  logic(L),
  q_op(L,Q),
  outcome(O)}.
  
:- outcome(O), not precondition(_, O).

{result(O, A) :
  outcome(O),
  logic(L),
  a_op(L, A).}

:- outcome(O), not result(O, _).

% Prevent any outcome that moves resource into or out of agent health
:- resource_logic(resource), outcome(O), result(O, move_resource(health(_), _, _)).
:- resource_logic(resource), outcome(O), result(O, move_resource(_, health(_), _)).

% TODO: bottom if there's a rule where any of the preconditions or effects has no feedback?

% Some queries might have other implicit queries
:- precondition(Q, O),
  q_op(L1, Q),
  prerequisite(L1, Q, L2, Q2),
  q_op(L2, Q2),
  not precondition(Q2, O).

% Some conditions might be forced to go with certain outcomes
:- precondition(Q, O),
  q_op(L1, A),
  prerequisite(L1, Q, L2, A),
  a_op(L2, A),
  not result(O, A).

% Some actions might have implicit preconditions
:- result(O, A),
  a_op(L1, A),
  prerequisite(L1, A, L2, Q),
  q_op(L2, Q),
  not precondition(Q, O).

% Some actions might have implicit dependent actions
:- result(O, A),
  a_op(L1, A),
  prerequisite(L1, A, L2, A2),
  a_op(L2, A2),
  not result(O, A2).


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
:- entity(E), not 3{precondition(Q, die(E)):logic(L), q_op(L, Q)}.

outcome(die(E)).

result(die(E), set_charmstate(E, dead)) :-
  charstate_logic(charstate),
  entity(E).
