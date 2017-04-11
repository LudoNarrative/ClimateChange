

replace(result(O,move(E,D)),result(O,apply_impulse(E,D))) :-
    precondition(overlaps(_),O),
    result(O,move(E,D)).

replace(result(O,move(E,D)),result(O,apply_impulse(E,D))) :-
  not_every_frame(O),
  result(O,move(E,D)).

replace(result(O,move(E,direction(D))),result(O,moves(E,D))) :-
    result(O,move(E,direction(D))),
    every_frame(O).

replace(result(O,move(E,direction(towards,D))),result(O,move_towards(E,D))) :-
    result(O,move(E,direction(towards,D))),
    every_frame(O).

replace(result(O,move(E,direction(towards,D))),result(O,move_away(E,D))) :-
    result(O,move(E,direction(away,D))),
    every_frame(O).
