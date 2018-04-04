logic_g3(L) :- charstate_logic_g3(L).

% Validity
:- charmstate_g3(L, _, _), not charstate_logic_g3(L).
:- charm_g3(L, _), not charstate_logic_g3(L).
:- charmedge_g3(L, _, _, _), not charstate_logic_g3(L).

% Every machine must be initialized
% "guess a default but admit overriding with explicit facts"
1{init_g3(L, charmstate(M, S)) : charmstate_g3(L, M, S)}1 :-
  charstate_logic_g3(L),
  charm_g3(L, M).
:- charstate_logic_g3(L),
  charm_g3(L, M),
  not 1{init_g3(L, charmstate(M, S)):charmstate_g3(L,M,S)}1.

% Constraints:
% No machine without states
:- charstate_logic_g3(L), charm_g3(L, C), {charmstate_g3(L, C, _)}0.
% No machine with a state with no incoming or outgoing edge
:- charstate_logic_g3(L),
  charm_g3(L, C),
  charmstate_g3(L, C, A),
  {charmedge_g3(L, C, A, _)}0,
  {charmedge_g3(L, C, _, A)}0.
% TODO: prevent disconnected state machines too

% * (Alter/Check) the discrete state of an entity according to a given (fixed) transition system.
q_op_g3(L, charmstate(CM, S, B)) :-
  charstate_logic_g3(L),
  charm_g3(L, CM),
  charmstate_g3(L, CM, S),
  bool_g3(B).

a_op_g3(L, set_charmstate(CM, S)) :-
  charstate_logic_g3(L),
  charm_g3(L, CM),
  charmstate_g3(L, CM, S).

% We don't have disjunction so the prereq is the conjunction of "not in any state that can't get to S2"
prerequisite_g3(L, set_charmstate(CM, S2), charmstate(CM, S1, false)) :-
  charstate_logic_g3(L),
  charm_g3(L, CM),
  charmstate_g3(L, CM, S1),
  charmstate_g3(L, CM, S2),
  not charmedge_g3(L, CM, S1, S2).

% feedback_g3(L, charmstate(CM, S, true)) :-
%   charstate_logic_g3(L),
%   q_op_g3(L, charmstate(CM, S, true)).

% feedback_g3(L, set_charmstate(CM, S)) :-
%   charstate_logic_g3(L),
%   a_op_g3(L, set_charmstate(CM, S0, S)).

% * Whenever an entity's discrete state changes, perform some operators of this or another logic.
%   Implicit in Gemini
% * Synchronize state changes between several entities.
%   Hmmm probably ignore for now

