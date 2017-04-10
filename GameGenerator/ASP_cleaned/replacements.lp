

replace(result(O,move(E,D)),result(O,apply_impulse(E,D))) :-
    precondition(overlaps(_),O),
    result(O,move(E,D)).

replace(result(O,move(E,D)),result(O,apply_impulse(E,D))) :-
  not_every_frame(O),
  result(O,move(E,D)).
