resource(r1).
entity(e1).
entity(e2).

initialize(set(r1, low)).

initialize(add(e1, random)).
initialize(add(e2, random)).

move(e1, southwest).

initialize(set_sprite(e1, star)).
initialize(set_sprite(e2, circle)).

precondition(control_event(click(e1)), o1).
result(o1, move_away(e2, e1)).
result(o1, increase(r1, low)).
