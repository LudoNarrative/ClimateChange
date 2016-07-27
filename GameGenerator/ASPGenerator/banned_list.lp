
:- precondition(overlaps(E1,E2,POL),O).
:- precondition(control_event(button(B,held)),O).
:-  result(O,moves(E,D)).
:- controlLogic(draggable(ENTITY)).
:- precondition(timerElapsed(T),O) .
:- result(O,add(E,L)).
:- result(O,delete(E)).