logic_g3(L) :- physics_logic_g3(L).

% Validity
:- physics_body_g3(L,B), not physics_logic_g3(L).

:- physics_body_g3(L,B), not physics_mode_g3(L, B, _).
:- physics_mode_g3(L,_,_), not physics_logic_g3(L).
:- physics_mode_g3(L,B,_), not physics_body_g3(L,B).

{physics_mode_g3(L, B, normal)} :-
  physics_logic_g3(L),
  physics_body_g3(L, B).

physics_lvel_g3(L,lvel(0)) :- physics_logic_g3(L).
physics_avel_g3(L,avel(0)) :- physics_logic_g3(L).

% Linear and angular targets.  One per body*mode in this logic.
% TODO in the future add in external forces like gravity or velocity overrides or whatever.
1{physics_mode_ltarget_g3(L,B,M,Dir):dir_g3(L,Dir)}1 :-
  physics_logic_g3(L),
  physics_mode_g3(L,B,M).

1{physics_mode_atarget_g3(L,B,M,Dir):dir_g3(L,Dir)}1 :-
  physics_logic_g3(L),
  physics_mode_g3(L,B,M).

% Linear and angular velocities
1{physics_mode_lvel_g3(L,B,M,Q):physics_lvel_g3(L,Q)}1 :-
  physics_logic_g3(L),
  physics_mode_g3(L,B,M).

:- physics_logic_g3(L), physics_mode_g3(L,B,M),
  not physics_mode_lvel_g3(L,B,M,_).
:- physics_logic_g3(L), physics_mode_g3(L,B,M),
  physics_mode_lvel_g3(L,B,M,Q), not physics_lvel_g3(L,Q).

1{physics_mode_avel_g3(L,B,M,Q):physics_avel_g3(L,Q)}1 :-
  physics_logic_g3(L),
  physics_mode_g3(L,B,M).

:- physics_logic_g3(L), physics_mode_g3(L,B,M),
  not physics_mode_avel_g3(L,B,M,_).
:- physics_logic_g3(L), physics_mode_g3(L,B,M),
  physics_mode_avel_g3(L,B,M,Q), not physics_avel_g3(L,Q).

% Mode changes
q_op_g3(L, physics_mode(B, M)) :-
  physics_logic_g3(L),
  physics_mode_g3(L, B, M).
a_op_g3(L, set_physics_mode(B, M)) :-
  physics_mode_g3(L, B, M).
% state_feedback_g3(L, physics_mode(B, M)) :-
%   physics_mode_g3(L, B, M).

%% TODO max vel in different dimensions distinct?
%% TODO the idea of controlled vs uncontrolled dimensions??????
%% future physics logics could be more sophisticated, support accelerations, etc.
