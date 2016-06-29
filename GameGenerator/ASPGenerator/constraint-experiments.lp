
:- 2 {precondition(control_event(X), Outcome)}.
% :- 2 {precondition(overlaps(X, Y, Z), Outcome)}.
% :- 2 {precondition(ge(X, Y), Outcome)}.
% :- 2 {precondition(le(X, Y), Outcome)}.
% :- 2 {result(Outcome, increase(R, Amount))}.
% :- 2 {result(Outcome, decrease(R, Amount))}.

exists_add_result
  :- result(Outcome, add(E)).
:- not exists_add_result.

% Don't add or delete an entity unless it's because of (a) collision or (b)
% control event
controlled(O) :- precondition(control_event(_), O).
controlled(O) :- precondition(overlaps(_,_, true), O).
:- result(O, add(E)), not controlled(O).
:- result(O, delete(E)), not controlled(O).

