#include "logics/logics.lp"

% Use collision logics
#include "logics/collision.lp"
collision_logic(collision).
% In the collision logic col, these are reasonable distances to check between objects
distance(collision, s(50)) :- collision_logic(collision).
distance(collision, s(500)) :- collision_logic(collision).

% use default "maybe X blocks Y" initialization

% TODO: color drawing

% structural synthesis with collision
%  one entity:one collider
collider(collision, E) :- collision_logic(collision), entity(E).

% TODO: physics logic
#include "logics/physics.lp"


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

% always require starting with at least one alive thing
:- charstate_logic(charstate),
  {init(charstate, charmstate(E, normal))}0.

% TODO: put in steering behaviors as separate machines for each agent?  or additional states that also go to dead?

% Resource logics
#include "logics/resource.lp"
resource_logic(resource).
%  Valid resource quantities for rules
resource_amount(resource, s(0)) :- resource_logic(resource).
resource_amount(resource, s(3)) :- resource_logic(resource).
resource_amount(resource, s(5)) :- resource_logic(resource).
resource_amount(resource, s(7)) :- resource_logic(resource).
resource_amount(resource, s(10)) :- resource_logic(resource).
resource_pool(resource, health(E)) :- resource_logic(resource), entity(E).
resource_pool(resource, R) :- resource_logic(resource), resource(R).
resource_pool_capacity(resource, P, s(10)) :- resource_logic(resource), resource_pool(resource, P).

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
  loc(Loc).
action(control, E, change_state(S)) :-
  S /= dead,
  control_logic(control),
  charstate_logic(charstate),
  agent(control, E),
  charmstate(charstate, E, S).
% NOTE: to go from action to control for that action you have to use the input_map predicate. 

% Extra gemini concepts (technically structural synthesis)
loc(mouse).
loc(E) :- entity(E).
loc(dir(nw;n;ne;w;mid;e;sw;s;se)).

{max_entity(M)} :- M = min_entities..max_entities.
entity(entity(e(M))) :- M = 1..N, max_entity(N).

target(E, L) :-
  entity(E),
  loc(L).

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
  q_op(L, Q),
  prerequisite(L, Q, Q2),
  q_op(L, Q2),
  not precondition(Q2, O).

% Some conditions might be forced to go with certain outcomes
:- precondition(Q, O),
  q_op(L, A),
  prerequisite(L, Q, A),
  a_op(L, A),
  not result(O, A).

% Some actions might have implicit preconditions
:- result(O, A),
  a_op(L, A),
  prerequisite(L, A, Q),
  q_op(L, Q),
  not precondition(Q, O).

% Some actions might have implicit dependent actions
:- result(O, A),
  a_op(L, A),
  prerequisite(L, A, A2),
  a_op(L, A2),
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
