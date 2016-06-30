entity(e1)

resource(r1)

many(e1)

initialize(set(r1,low))

precondition(tick,tick)
result(tick,decrease(r1,low))
result(tick,moves(e1,forward,0))
result(tick,move_towards(e1,cursor))

precondition(ge(r1,high),o3)
precondition(control_event(click(e1)),o3)
result(o3,delete(e1))
result(o3,decrease(r1,high))

precondition(control_event(button(mouse_button,held)),o2)
result(o2,add(e1))
result(o2,increase(r1,r1))

precondition(le(r1,0),eo5)
result(eo5,mode_change(narrative_progress))

precondition(ge(r1,high),o1)
precondition(control_event(click(e1)),o1)
result(o1,delete(e1))
result(o1,decrease(r1,medium))
