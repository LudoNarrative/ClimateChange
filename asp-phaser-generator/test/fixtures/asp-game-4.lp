entity(e1).
entity(e2).

resource(r1).
resource(r2).

singular(e1).
singular(e2).

initialize(add(e1,random)).
initialize(add(e2,upper_left)).
initialize(set_sprite(e1,circle)).
initialize(set_sprite(e2,square)).
initialize(set(r1,high)).
initialize(set(r2,0)).

goal(prevent(o2)).
goal(maintain(r1)).

precondition(tick,tick).
result(tick,move_towards(e1,e2)).
result(tick,move_towards(e2,cursor)).
result(tick,increase(r2,r1)).
result(tick,decrease(r1,low)).

precondition(le(r2,high),o3).
precondition(control_event(click(e1)),o3).
result(o3,increase(r1,medium)).

precondition(le(r1,medium),o2).
result(o2,mode_change(game_loss)).

precondition(control_event(click(e2)),o1).
result(o1,decrease(r1,r2)).
result(o1,decrease(r2,medium)).
