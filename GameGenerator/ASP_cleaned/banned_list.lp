
keyboard(space;up_arrow;down_arrow;left_arrow;right_arrow).
:- precondition(control_event(button(Key,_)),_),
   keyboard(Key).


:- action(add(E,_,E2)),
   entity(E2).

:- action(add(E,_,cursor)).


:- precondition(compare(_,_),O),
    precondition(control_event(click(_)),O).


% RUNNING OUT OF GAS
:- precondition(compare(_,_),O),
    precondition(control_event(_),O).
	
:- precondition(compare(_,_),O),
    result(O,move(_,_)).
    
    
    
% PROPERTIES DONT WORK
:- condition(compare(_,property(_,_))).

:- replace(result(O,move(E,D)),result(O,apply_impulse(E,D,scalar(S)))).