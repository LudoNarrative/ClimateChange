%:-  result(_,add(_,_)).


% %cases %%%%
% %% no controls except mouse.
nonMouseControls  :- 
    condition(control_event(button(B, Action))), 
    B != mouse_button. 
:- nonMouseControls.

:- result(O,reflect_velocity(E,collision_normal(_,_))).

:- result(O,add(E,field)).

:- timerLogic(_,stochastic(_,_),_).
:- result(_,increase(health(E))).
:- result(_,decrease(health(E))).

%% :- entity(E1),
%%    entity(E2),
%%    entityOrdering(E1,E2),  not precondition(collide(E1,E2),_).
%% :- entity(E),
%%    not precondition(collide(E,E),_).
%:- entityOrdering(E1,E2), not collide(E1,E2).


%collision :- entityOrdering(E1,E2),  precondition(collide(E1,E2),_).
%:- not collision.
%:- not collision.
%:- entity(E), not precondition(collide(E,E),_).
