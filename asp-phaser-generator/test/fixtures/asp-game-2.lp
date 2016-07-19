resource(r1).
entity(e1).
entity(e2).

singular(e1).
many(e2).

initialize(set(r1, low)).

initialize(add(e1, center)).
initialize(set_sprite(e1, star)).
initialize(set_sprite(e2, circle)).

precondition(control_event(click(e1)), o1).
result(o1, add(e2, random)).
result(o1, increase(r1, low)).

precondition(ge(r1, med), o2).
result(o2, change_mode(game_win)).
