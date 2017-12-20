
keyboard(space;up_arrow;down_arrow;left_arrow;right_arrow).
:- precondition(control_event(button(Key,_)),_),
   keyboard(Key).


:- action(add(E,_,E2)),
   entity(E2).


:- action(add(E,_,cursor)).
:- action(add(E,resource(R),_)).

:- action(modify(_,_,_)).
:- precondition(compare(_,_),O),
    precondition(control_event(click(_)),O).


% RUNNING OUT OF GAS
:- precondition(compare(_,_),O),
    precondition(control_event(_),O).
	
    
% PROPERTIES DONT WORK
:- condition(compare(_,property(_,_))).

:- replace(result(O,move(E,D)),result(O,apply_impulse(E,D,_))).

:- condition(overlaps(_,_,false)).

%% clicking is fucked right now
:-  precondition(control_event(click(E1)),O),
    result(O,draw(E2,_)),
    E1 != E2.

:-  precondition(control_event(click(E1)),O),
    result(O,modify(D,E2,_)),
    E1 != E2.

:-  precondition(control_event(click(E1)),O),
    result(O,modify(D,property(E2,_),_)),
    E1 != E2.

:-  precondition(control_event(click(E1)),O),
    result(O,modify(D,property(E2,_))),
    E1 != E2.

:- precondition(control_event(click(E)),O),
   result(O,clear(E2)),
   E2 != E.
