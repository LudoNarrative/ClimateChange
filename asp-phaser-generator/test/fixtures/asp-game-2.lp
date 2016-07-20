entity(e1).
entity(e2).

resource(r1).
resource(r2).

singular(e1).
singular(e2).

initialize(add(e1,lower_right)).
initialize(add(e2,center)).
initialize(set_sprite(e1,square)).
initialize(set_sprite(e2,square)).
initialize(set(r1,high)).
initialize(set(r2,high)).

goal(prevent(o2)).
goal(maintain(r1)).

precondition(tick,tick).
result(tick,move_towards(e2,cursor)).
result(tick,move_away(e2,e1)).
result(tick,decrease(r1,medium)).
result(tick,decrease(r2,r1)).

precondition(ge(r2,medium),o3).
precondition(control_event(click(e1)),o3).
result(o3,increase(r1,r2)).

precondition(le(r1,low),o2).
result(o2,mode_change(game_loss)).

precondition(control_event(click(e2)),o1).
result(o1,increase(r2,medium)).
result(o1,decrease(r1,low)).
