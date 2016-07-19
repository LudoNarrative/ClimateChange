resource(r1).
entity(e1).
entity(e2).

initialize(set(r1, low)).

initialize(add(e1, random)).
initialize(add(e2, random)).

controlLogic(draggable(e1)).

initialize(set_sprite(e1, star)).
initialize(set_sprite(e2, circle)).

move(e1, southwest).

precondition(tick,tick)
result(tick,move_away(e1,cursor))
result(tick,move_away(e1,e2))
result(tick,move_away(e2,cursor))
result(tick,decrease(r1,high))

precondition(control_event(click(e1)), o1).
result(o1, move_away(e2, e1)).
result(o1, increase(r1, low)).
