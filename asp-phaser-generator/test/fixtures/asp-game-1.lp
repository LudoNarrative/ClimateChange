entity(e1).
entity(e2).

resource(r1).
resource(r2).

singular(e1).
singular(e2).

initialize(add(e1,upper_left)).
initialize(add(e2,center)).
initialize(set_sprite(e1,star)).
initialize(set_sprite(e2,pentagon)).
initialize(set(r1,low)).
initialize(set(r2,medium)).

goal(prevent(o3)).
goal(maintain(r1)).

precondition(tick,tick).
result(tick,move_towards(e1,cursor)).
result(tick,move_away(e2,e1)).
result(tick,increase(r2,high)).
result(tick,decrease(r1,medium)).

precondition(le(r1,0),o3).
result(o3,mode_change(game_loss)).

precondition(control_event(click(e2)),o2).
result(o2,decrease(r1,r2)).
result(o2,decrease(r2,medium)).

precondition(le(r2,high),o1).
precondition(control_event(click(e1)),o1).
result(o1,increase(r1,r2)).
