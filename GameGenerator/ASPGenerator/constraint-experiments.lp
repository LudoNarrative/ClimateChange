
:- 2 {precondition(control_event(X), Outcome)}.
% :- 2 {precondition(overlaps(X, Y, Z), Outcome)}.
% :- 2 {precondition(ge(X, Y), Outcome)}.
% :- 2 {precondition(le(X, Y), Outcome)}.

:- not singular(E), entity(E).

implies(near(E1, E2), near(E2, E1))
  :- condition(near(E1,E2)).

implies(overlaps(E1, E2), near(E1, E2))
  :- condition(overlaps(E1, E2, true)).

implies(overlaps(E1, E2), near(E2, E1))
  :- condition(overlaps(E1, E2, true)).

implies(C, present(E))
  :- spatial_condition(C, E, E').

implies(control_event(click(E)), present(E))
  :- condition(control_event(click(E))).

contradictory(present(E), absent(E))
  :- condition(present(E)).

contradictory(near(E1, E2), far(E1, E2))
  :- condition(near(E1, E2)).

contradictory(near(E1, E2), far(E2, E1))
  :- condition(near(E1, E2)).

:- precondition(X, O), precondition(Y, O), implies(X, Y), X != Y.
:- precondition(X, O), precondition(Y, O), contradictory(X, Y).

:- condition(present(E)), not effect(delete(E)).
:- condition(absent(E)), not effect(delete(E)).

%% Can't test for a spatial condition unless at least one of the entities
%% can move.

:- condition(C), spatial_condition(C, E1, E2), not one_moves(E1, E2).

one_moves(E1, E2)
  :- moves(E1), entity(E2).

one_moves(E1, E2)
  :- moves(E2), entity(E1).

moves(E)
  :- effect(move_toward(E, X)).

moves(E)
  :- effect(move_away(E, X)).

moves(E)
  :- controlScheme(E, Scheme).

moves(E)
  :- effect(move_selected(E)).

moves(E)
  :- effect(moves(E, Direction, Amount)).

%% Temporary
% :- result(repeled_from_cursor(E),_).
% :- result(drawn_to_cursor(E),_).


