resource(r1).
initialize(set(r1, low)).

entity(e1).

resource(health(e1)).
initialize(set(health(e1), 100)).
initialize(set_sprite(e1, square)).

precondition(le(r1, med), o1).
precondition(gt(health(e1), 0), o1).
result(o1, increase(r1, low)).
result(o1, decrease(health(e1), 1)).
