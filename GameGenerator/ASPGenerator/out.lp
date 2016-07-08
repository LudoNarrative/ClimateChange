entity(e1).
entity(e2).

resource(r1).

singular(e1).
singular(e2).

initialize(set(r1,high)).

precondition(control_event(button(mouse_button,held)),drawn_to_cursor(e1)).
result(drawn_to_cursor(e1),move_towards(e1,cursor)).

precondition(timerElapsed(e2,change_direction),change_direction(e2)).
result(change_direction(e2),rotate(e2,random_int(0,360))).

precondition(tick,tick).
result(tick,moves(e1,forward,low)).
result(tick,moves(e2,forward,low)).
result(tick,decrease(r1,medium)).

precondition(near(e2,e1),o1).
precondition(ge(r1,medium),o1).
result(o1,delete(e2)).
result(o1,decrease(r1,high)).

precondition(le(r1,medium),eo5).
result(eo5,mode_change(game_loss)).

precondition(timerElapsed(e1,change_direction),change_direction(e1)).
result(change_direction(e1),rotate(e1,random_int(0,360))).

precondition(absent(e2),o2).
result(o2,add(e2)).
result(o2,increase(r1,low)).

