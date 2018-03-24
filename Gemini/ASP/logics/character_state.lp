logic(L) :- charstate_logic(L).

% Validity
:- charmstate(L, _, _), not charstate_logic(L).
:- charm(L, _), not charstate_logic(L).
:- charmedge(L, _, _, _), not charstate_logic(L).

% Every machine must be initialized
% "guess a default but admit overriding with explicit facts"
1{init(L, charmstate(M, S)) : charmstate(L, M, S)}1 :-
  charstate_logic(L),
  charm(L, M).
:- charstate_logic(L),
  charm(L, M),
  not 1{init(L, charmstate(M, S)):charmstate(L,M,S)}1.

% Constraints:
% No machine without states
:- charstate_logic(L), charm(L, C), {charmstate(L, C, _)}0.
% No machine with a state with no incoming or outgoing edge
:- charstate_logic(L),
  charm(L, C),
  charmstate(L, C, A),
  {charmedge(L, C, A, _)}0,
  {charmedge(L, C, _, A)}0.
% TODO: prevent disconnected state machines too

% * (Alter/Check) the discrete state of an entity according to a given (fixed) transition system.
q_op(L, charmstate(CM, S, B)) :-
  charstate_logic(L),
  charm(L, CM),
  charmstate(L, CM, S),
  bool(B).

a_op(L, set_charmstate(CM, S)) :-
  charstate_logic(L),
  charm(L, CM),
  charmstate(L, CM, S).

% We don't have disjunction so the prereq is the conjunction of "not in any state that can't get to S2"
prerequisite(L, set_charmstate(CM, S2), charmstate(CM, S1, false)) :-
  charstate_logic(L),
  charm(L, CM),
  charmstate(L, CM, S1),
  charmstate(L, CM, S2),
  not charmedge(L, CM, S1, S2).

% feedback(L, charmstate(CM, S, true)) :-
%   charstate_logic(L),
%   q_op(L, charmstate(CM, S, true)).

% feedback(L, set_charmstate(CM, S)) :-
%   charstate_logic(L),
%   a_op(L, set_charmstate(CM, S0, S)).

% * Whenever an entity's discrete state changes, perform some operators of this or another logic.
%   Implicit in Gemini
% * Synchronize state changes between several entities.
%   Hmmm probably ignore for now

