entity(e1)
entity(e2)

resource(r1)
resource(r2)

singular(e2)

many(e1)

initialize(add(e1,upper_left))
initialize(add(e2,center))
initialize(set_sprite(e1,square))
initialize(set_sprite(e2,circle))
initialize(set(r1,low))
initialize(set(r2,high))

goal(prevent(o3))
goal(maintain(r1))

precondition(near(e1,e2),o4)
precondition(le(r1,low),o4)
result(o4,decrease(r2,low))

precondition(le(r1,0),o3)
result(o3,mode_change(game_loss))

precondition(near(e1,e2),o2)
precondition(ge(r2,high),o2)
result(o2,increase(r1,r2))

precondition(control_event(button(mouse_button,released)),o1)
result(o1,add(e1,random))
result(o1,increase(r2,low))
result(o1,decrease(r1,high))

precondition(tick,tick)
result(tick,move_away(e1,cursor))
result(tick,move_away(e2,e1))
result(tick,apply_force(e1,south,mid))
result(tick,apply_force(e2,south,mid))
result(tick,increase(r2,r1))
result(tick,decrease(r1,r2))
