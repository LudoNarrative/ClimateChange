:-  result(_,add(_,_)).


% %cases %%%%
% %% no controls except mouse.
nonMouseControls  :- 
    condition(control_event(button(B, Action))), 
    B != mouse_button. 
:- nonMouseControls.

:- result(O,apply_restitution(E1,E2)).
:- result(O,reflect_velocity(E,collision_normal(_,_))).

:- result(change_target(ENTITY), set(target(ENTITY),random_point)) .
