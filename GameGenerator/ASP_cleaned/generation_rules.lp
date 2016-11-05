moving(Entity) :- result(_,move(Entity,_)).
moving(Entity) :- controlLogic(draggable(Entity)).

static(Entity) :- entity(Entity), not moving(Entity).

outcome(O) :- result(O,_).
action(A) :- result(_,A).


has_precondition(O) :- precondition(_,O).
has_result(O) :- result(O,_).


every_frame(O) :- precondition(tick,O).
 
every_frame(O) :- not not_every_frame(O), precondition(C,O).

not_every_frame(O) :- precondition(control_event(click(E)),O).
not_every_frame(O) :- precondition(control_event(button(B,pressed)),O).
not_every_frame(O) :- precondition(control_event(button(B,released)),O).
not_every_frame(O) :- precondition(timerElapsed(T),O) .


%players must have controls or it's just a weird movie
playerControls :- precondition(control_event(EVENT),OUTCOME).
playerControls :- controlLogic(_).


spatial_condition(E1,E2) :- precondition(overlaps(E1,E2,P),O).
spatial_condition(E2,E1) :- precondition(overlaps(E1,E2,P),O).


moves(E) :- result(_,move(E,_)).
moves(E) :- controlLogic(draggable(E)).
