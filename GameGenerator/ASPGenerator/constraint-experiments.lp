
% :- 2 {precondition(control_event(X), Outcome)}.
% :- 2 {precondition(overlaps(X, Y, Z), Outcome)}.
% :- 2 {precondition(ge(X, Y), Outcome)}.
% :- 2 {precondition(le(X, Y), Outcome)}.
% :- 2 {result(Outcome, increase(R, Amount))}.
% :- 2 {result(Outcome, decrease(R, Amount))}.

exists_add_result
  :- effect(add(E)).

exists_delete_result
  :- effect(delete(E)).

:- not exists_add_result.
:- not exists_delete_result.

:- not static(_).
:- many(E).
