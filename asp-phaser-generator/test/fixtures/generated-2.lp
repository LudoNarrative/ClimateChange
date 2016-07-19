entity(e1)
entity(e2)

resource(r1)
resource(r2)

many(e1)
many(e2)

initialize(add(e1,upper_right))
initialize(add(e2,upper_right))
initialize(set_sprite(e1,circle))
initialize(set_sprite(e2,pentagon))
initialize(set(r1,medium))
initialize(set(r2,0))

goal(prevent(o2))
goal(maintain(r1))

precondition(near(e1,e2),o3)
precondition(ge(r2,high),o3)
result(o3,increase(r1,r2))

precondition(timerElapsed(t2),o4)
result(o4,decrease(r1,medium))
result(o4,decrease(r2,high))

precondition(control_event(click(e2)),o1)
result(o1,delete(e2))
result(o1,add(e1,lower_right))
result(o1,increase(r2,high))
result(o1,decrease(r1,medium))

precondition(timerElapsed(t1),o5)
result(o5,decrease(r1,r2))
result(o5,decrease(r2,medium))

precondition(le(r1,low),o2)
result(o2,mode_change(game_loss))

precondition(tick,tick)
result(tick,move_towards(e1,cursor))
result(tick,move_away(e1,e2))
result(tick,apply_force(e1,south,mid))
result(tick,apply_force(e2,south,mid))
result(tick,decrease(r1,low))
result(tick,decrease(r2,low))
