entity(e1)
entity(e2)

resource(r1)
resource(r2)

singular(e1)

many(e2)

initialize(add(e1,center))
initialize(add(e2,random))
initialize(set_sprite(e1,circle))
initialize(set_sprite(e2,square))
initialize(set(r1,low))
initialize(set(r2,low))

goal(prevent(o2))
goal(maintain(r1))

precondition(le(r1,0),o2)
result(o2,mode_change(game_loss))

precondition(tick,tick)
result(tick,move_towards(e2,target))
result(tick,move_away(e2,cursor))
result(tick,move_away(e2,e1))
result(tick,apply_force(e2,south,mid))
result(tick,decrease(r1,high))
result(tick,decrease(r2,medium))

precondition(near(e1,e2),o3)
precondition(ge(r2,r1),o3)
result(o3,decrease(r1,medium))

precondition(timerElapsed(change_target(e2)),change_target(e2))
result(change_target(e2),set(target,random_point))

precondition(near(e1,e2),o1)
precondition(control_event(button(mouse_button,pressed)),o1)
result(o1,add(e2,upper_right))
result(o1,increase(r1,r2))
result(o1,increase(r2,r1))
