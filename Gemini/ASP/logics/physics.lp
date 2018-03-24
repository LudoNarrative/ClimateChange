logic(L) :- physics_logic(L).

% Validity
:- physics_body(L,B), not physics_logic(L).

:- physics_body(L,B), not physics_mode(L, B, _).
:- physics_mode(L,_,_), not physics_logic(L).
:- physics_mode(L,B,_), not physics_body(L,B).

{physics_mode(L, B, normal)} :-
  physics_logic(L),
  physics_body(L, B).

physics_lvel(L,lvel(0)) :- physics_logic(L).
physics_avel(L,avel(0)) :- physics_logic(L).

% Linear and angular targets.  One per body*mode in this logic.
% TODO in the future add in external forces like gravity or velocity overrides or whatever.
1{physics_mode_ltarget(L,B,M,Dir):dir(L,Dir)}1 :-
  physics_logic(L),
  physics_mode(L,B,M).

1{physics_mode_atarget(L,B,M,Dir):dir(L,Dir)}1 :-
  physics_logic(L),
  physics_mode(L,B,M).

% Linear and angular velocities
1{physics_mode_lvel(L,B,M,Q):physics_lvel(L,Q)}1 :-
  physics_logic(L),
  physics_mode(L,B,M).

:- physics_logic(L), physics_mode(L,B,M),
  not physics_mode_lvel(L,B,M,_).
:- physics_logic(L), physics_mode(L,B,M),
  physics_mode_lvel(L,B,M,Q), not physics_lvel(L,Q).

1{physics_mode_avel(L,B,M,Q):physics_avel(L,Q)}1 :-
  physics_logic(L),
  physics_mode(L,B,M).

:- physics_logic(L), physics_mode(L,B,M),
  not physics_mode_avel(L,B,M,_).
:- physics_logic(L), physics_mode(L,B,M),
  physics_mode_avel(L,B,M,Q), not physics_avel(L,Q).

% Mode changes
q_op(L, physics_mode(B, M)) :-
  physics_logic(L),
  physics_mode(L, B, M).
a_op(L, set_physics_mode(B, M)) :-
  physics_mode(L, B, M).
% state_feedback(L, physics_mode(B, M)) :-
%   physics_mode(L, B, M).

%% TODO max vel in different dimensions distinct?
%% TODO the idea of controlled vs uncontrolled dimensions??????
%% future physics logics could be more sophisticated, support accelerations, etc.
