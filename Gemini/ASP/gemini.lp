% Use collision logics
collision_logic(collision).
% In the collision logic col, these are reasonable distances to check between objects
distance(collision, 50).
distance(collision, 500).

% structural synthesis with collision
%  one entity:one collider
collider(collision, E) :- entity(E).

% Use character-state logics (alive/dead)
charstate_logic(charstate).
% structural synthesis with character-state logics
%  one entity:one char machine
charm(charstate, E) :- entity(E).
%  one char machine:two states
charmstate(charstate, E, alive) :- entity(E).
charmstate(charstate, E, dead) :- entity(E).
%    and one edge
charmedge(charstate, E, alive, dead) :- entity(E).

% always require starting with at least one alive thing
:- {init(charstate, charmstate(E, alive))}0.

% Extra gemini concepts (technically structural synthesis)
{max_entity(M)} :- M = min_entities..max_entities.
entity(entity(e(M))) :- M = 1..N, max_entity(N).
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

% Some queries might have other implicit queries
:- precondition(Q, O),
  q_op(L, Q),
  prerequisite(L, Q, Q2),
  q_op(L, Q2),
  not precondition(Q2, O).

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
precondition(charmstate(E, alive, true), die(E)) :-
  entity(E).
precondition(has_resource(health(E), le, 0), die(E)) :-
  entity(E).
outcome(die(E)).
result(die(E), set_charmstate(E, dead)) :-
  entity(E).

