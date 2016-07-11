entity(e1)

resource(r1)

singular(e1)

initialize(set(r1,medium))

precondition(control_event(button(mouse_button,held)),drawn_to_cursor(e1))
result(drawn_to_cursor(e1),move_towards(e1,cursor))

precondition(le(r1,high),o3)
precondition(control_event(click(e1)),o3)
result(o3,delete(e1))

precondition(tick,tick)
result(tick,decrease(r1,low))
result(tick,moves(e1,forward,high))

precondition(le(r1,medium),o1)
precondition(control_event(click(e1)),o1)
result(o1,increase(r1,high))

precondition(le(r1,low),eo5)
result(eo5,mode_change(narrative_progress))

precondition(control_event(button(space,pressed)),o2)
precondition(absent(e1),o2)
result(o2,add(e1))
result(o2,increase(r1,high))

