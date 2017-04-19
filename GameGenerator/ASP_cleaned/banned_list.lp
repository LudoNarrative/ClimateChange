
keyboard(space;up_arrow;down_arrow;left_arrow;right_arrow).
:- precondition(control_event(button(Key,_)),_),
   keyboard(Key).

:- replace(result(O,move(E,D)),result(O,apply_impulse(E,D,S))).

:- action(add(E,_,E2)),
   entity(E2).

:- action(add(E,_,cursor)).


:- result(tick,rotates(_,_)).
