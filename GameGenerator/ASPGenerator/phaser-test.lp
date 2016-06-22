entity(e1)
entity(e2)

resource(r1)

singular(e1)
singular(e2)

initialize(set(r1,high))

precondition(overlaps(e1,e2,true),eo2)
precondition(le(r1,low),eo2)
result(eo2,mode_change(game_loss))

precondition(overlaps(e1,e2,true),o3)
precondition(control_event(button(space,pressed)),o3)
result(o3,decrease(r1,low))

precondition(timerElapsed(t2),o4)
precondition(timerElapsed(t3),o4)
result(o4,decrease(r1,low))

precondition(timerElapsed(e2,change_target),change_target(e2))
result(change_target(e2),set(target,random_point))

precondition(timerElapsed(t1),o1)
precondition(timerElapsed(t2),o1)
result(o1,decrease(r1,low))

precondition(near(e2,e1),o5)
precondition(timerElapsed(t1),o5)
result(o5,increase(r1,low))

precondition(overlaps(e1,e2,true),o2)
precondition(near(e2,e1),o2)
result(o2,increase(r1,low))

precondition(tick,tick)
result(tick,move_towards(e2,target))
result(tick,move_away(e1,e2))
result(tick,decrease(r1,low))

