


initialize(set_static(E,true)) :-
    static(E).

initialize(set_draggable(E,true)) :-
    controlLogic(draggable(E)).

replace(result(O,move(E,D)),result(O,apply_impulse(E,D,scalar(S)))) :-
    precondition(overlaps(_),O),
    result(O,move(E,D)),
    speed(E,O,S),
    not resource(S).

replace(result(O,move(E,D)),result(O,apply_impulse(E,D,scalar(S)))) :-
  not_every_frame(O),
  result(O,move(E,D)),
    speed(E,O,S),
    not resource(S).

replace(result(O,move(E,direction(D))),result(O,moves(E,D,scalar(S)))) :-
    result(O,move(E,direction(D))),
    every_frame(O),
    speed(E,O,S),
    not resource(S).


%%%%


replace(result(O,move(E,D)),result(O,apply_impulse(E,D,S))) :-
    precondition(overlaps(_),O),
    result(O,move(E,D)),
    speed(E,O,S),
    resource(S).

replace(result(O,move(E,D)),result(O,apply_impulse(E,D,S))) :-
  not_every_frame(O),
  result(O,move(E,D)),
    speed(E,O,S),
    resource(S).

replace(result(O,move(E,direction(D))),result(O,moves(E,D,S))) :-
    result(O,move(E,direction(D))),
    every_frame(O),
    speed(E,O,S),
    resource(S).
