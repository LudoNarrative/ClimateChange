entity(e1)
entity(e2)

resource(r1)
resource(r2)

singular(e1)

many(e2)

initialize(add(e1,center))
initialize(add(e2,random))
initialize(set_sprite(e1,pentagon))
initialize(set_sprite(e2,triangle))
initialize(set(r1,medium))
initialize(set(r2,medium))

goal(prevent(o3))
goal(maintain(r1))

precondition(le(r1,low),o3)
result(o3,mode_change(game_loss))

precondition(near(e1,e2),o4)
precondition(ge(r2,0),o4)
result(o4,decrease(r1,high))

precondition(control_event(click(e1)),o1)
result(o1,add(e2,lower_left))
result(o1,decrease(r1,r2))
result(o1,decrease(r2,high))

precondition(timerElapsed(change_target(e1)),change_target(e1))
result(change_target(e1),set(target,random_point))

precondition(near(e1,e2),o2)
precondition(le(r2,0),o2)
result(o2,increase(r1,r2))

precondition(tick,tick)
result(tick,move_towards(e1,target))
result(tick,move_away(e2,cursor))
result(tick,move_away(e2,e1))
result(tick,apply_force(e1,south,mid))
result(tick,increase(r2,high))
result(tick,decrease(r1,medium))
