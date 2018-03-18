logic(L) :- physics_logic(L).

% Validity
:- physics_body(L,B), not physics_logic(L).
:- physics_body(L,B), not physics_mode(L, B, _).
:- physics_mode(L,_,_), not physics_logic(L).
:- physics_mode(L,B,_), not physics_body(L,B).

{physics_mode(L, B, normal)} :-
  physics_logic(L),
  physics_body(L, B).

% * Determine an object's physical quantities based on terms from some other logic (e.g., character-state, resource).

physics_max_lvel(L,lvel(0)) :- physics_logic(L).
physics_max_avel(L,avel(0)) :- physics_logic(L).
physics_lacc(L,lacc(0)) :- physics_logic(L).
physics_aacc(L,aacc(0)) :- physics_logic(L).
physics_lacc(L,pinf) :- physics_logic(L).
physics_lacc(L,ninf) :- physics_logic(L).
physics_aacc(L,pinf) :- physics_logic(L).
physics_aacc(L,ninf) :- physics_logic(L).

1{physics_mode_max_lvel(L,B,M,Q):physics_max_lvel(L,Q)}1 :-
  physics_logic(L),
  physics_mode(L,B,M).

:- physics_mode(L,B,M), not physics_mode_max_lvel(L,B,M,Q).
:- physics_mode_max_lvel(L,B,M,Q), not physics_max_lvel(L,Q).

1{physics_mode_max_avel(L,B,M,Q):physics_max_avel(L,Q)}1 :-
  physics_logic(L),
  physics_mode(L,B,M).

:- physics_mode(L,B,M), not physics_mode_max_avel(L,B,M,Q).
:- physics_mode_max_avel(L,B,M,Q), not physics_max_avel(L,Q).

1{physics_mode_lacc(L,B,M,Q):physics_lacc(L,Q)}1 :-
  physics_logic(L),
  physics_mode(L,B,M).

:- physics_mode(L,B,M), not physics_mode_lacc(L,B,M,Q).
:- physics_mode_max_lacc(L,B,M,Q), not physics_max_lacc(L,Q).

1{physics_mode_aacc(L,B,M,Q):physics_aacc(L,Q)}1 :-
  physics_logic(L),
  physics_mode(L,B,M).

:- physics_mode(L,B,M), not physics_mode_aacc(L,B,M,Q).
:- physics_mode_max_aacc(L,B,M,Q), not physics_max_aacc(L,Q).

% let's say steering behaviors are the composition that handle low level physics: adjusting velocities, accelerations, etc

q_op(L, physics_mode(B, M)) :-
  physics_logic(L),
  physics_mode(L, B, M).

a_op(L, set_physics_mode(B, M)) :-
  physics_logic(L),
  physics_mode(L, B, M).

{state_feedback(L, physics_mode(B, M), LocOrGlob)} :-
  feedback_site(LocOrGlob),
  physics_logic(L),
  physics_mode(L, B, M).

