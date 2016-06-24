resource(r1).
entity(e1).
entity(e2).

singular(e1).
many(e2).

initialize(set(r1, low)).

precondition(control_event(click(e1)), o1).
result(o1, add(e2, random)).
result(o1, increase(r1, low)).

precondition(ge(r1, med), o2).
result(o2, change_game_mode(win)).


