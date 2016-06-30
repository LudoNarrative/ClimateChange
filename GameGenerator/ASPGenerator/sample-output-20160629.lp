%% Lecture game example where two particles move randomly; player must wait
%  until they collide and one of them disappears in order to click the other
%  one and increase r1.

entity(e1).
entity(e2).

resource(r1).

singular(e1).
singular(e2).

initialize(set(r1,high)).

precondition(timerElapsed(e2,change_direction),change_direction(e2)).
result(change_direction(e2),rotate(e2,random_int(0,360))).

precondition(tick,tick).
result(tick,moves(e1,forward,low)).
result(tick,moves(e2,forward,low)).
result(tick,decrease(r1,medium)).

precondition(control_event(click(e1)),o1).
precondition(absent(e2),o1).
result(o1,add(e2)).
result(o1,increase(r1,low)).

precondition(le(r1,0),eo5).
result(eo5,mode_change(game_loss)).

precondition(timerElapsed(e1,change_direction),change_direction(e1)).
result(change_direction(e1),rotate(e1,random_int(0,360))).

precondition(overlaps(e1,e2,true),o2).
precondition(le(r1,0),o2).
result(o2,delete(e2)).
