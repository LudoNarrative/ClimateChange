
keyboard(space;up_arrow;down_arrow;left_arrow;right_arrow).
:- precondition(control_event(button(Key,_)),_),
   keyboard(Key).

:- replace(result(O,move(E,D)),result(O,apply_impulse(E,D,S))).

:- action(add(E,_,E2)),
   entity(E2).

:- action(add(E,_,cursor)).


%:- result(tick,rotates(_,_,_)).

:- precondition(compare(_,_),O),
    precondition(control_event(click(_)),O).
	
:- action(look_at(_,_)).


% RUNNING OUT OF GAS
:- precondition(compare(_,_),O),
    precondition(control_event(_,_),O).
	
:- precondition(compare(_,_),O),
    result(O,move(_,_)).